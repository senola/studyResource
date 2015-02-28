#!/bin/bash
#set -x
# tomcat directory
tomcat_dir="/usr/local/tomcat/sync-tomcat-8000" 
# project name
project_name="money-w1"
#zip file
zip_file="$project_name".zip
# log file
log_file="money.log"

if [ -f "$tomcat_dir/webapps/$zip_file" ]; then
   # current day
   backupday_dir=backups/$(date "+%Y%m%d")/

   if [ ! -d "$tomcat_dir/$backupday_dir" ]; then
     mkdir "$tomcat_dir/$backupday_dir"
   fi

   cd "$tomcat_dir"/

   ################  stop tomcat ###################
   cd bin/
   tomcat_pid="`ps aux |grep "$tomcat_dir" |grep -v '/usr/bin/cronolog' |grep -v 'grep' |awk '{print $2}'`"
   if [ -n "$tomcat_pid" ]; then
      echo "[tomcat_pid:$tomcat_pid] stop server..."
      ./shutdown.sh
      sleep 3
      
      checktimes=10
      while [ -n "`ps aux |grep "$tomcat_dir" |grep -v '/usr/bin/cronolog' |grep -v 'grep' |awk '{print $2}'`" ]
      do
         sleep 3
         checktimes=$[checktimes - 1]
         if [ $checktimes -eq 0 ]; then
            kill -9 "$tomcat_pid"
            sleep 3
         fi
      done
      
      if [ $checktimes -eq 0 ]; then
         echo "[tomcat_pid:$tomcat_pid] stop server success by kill command"
      else
         echo "[tomcat_pid:$tomcat_pid] stop server success"
      fi
   fi
   ################  stop tomcat ###################


   ################  backup files ###################
   cd ../webapps/
   echo "begin backup $project_name..." 
   backup_name="$project_name"_$(date "+%Y%m%d%H%M%S").tar
   tar -cf "$backup_name" "$project_name"
   sleep 1
   mv "$backup_name" "../$backupday_dir"
   sleep 3
   echo "backup success!"
   ################  backup files ###################

if [ -f "$tomcat_dir/webapps/sso.zip" ]; then
   sso_name=sso_$(date "+%Y%m%d%H%M%S").tar
   tar -cf "$sso_name" sso
   sleep 1
   mv "$sso_name" "../$backupday_dir"
   rm -rf sso
   sleep 1
   unzip sso.zip
fi

   ################  delete files ###################
   echo "begin delete $project_name..."
   rm -rf "$project_name"
   sleep 3
   echo "delete success!"
   ################  delete files ###################

   echo "begin unzip $project_name ..." 
   unzip "$zip_file"
   sleep 3
   echo "unzip success!" 
   
   ################  start server ###################
   cd ../bin/
   echo "start server now , please wait..."
   ./startup.sh
   sleep 2
   echo "start server success"

   ps aux|grep "$tomcat_dir"
   sleep 3

   tail -f logs/"$log_file"
   ################  start server ###################
else
   echo "$tomcat_dir/webapps/$zip_file is not exist!"
fi
