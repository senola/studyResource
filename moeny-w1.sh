#!/bin/bash 

# tomcat directory
tomcat_dir="/usr/local/tomcat/sync-tomcat-8000/" 
# project name
project_name="money-w1"

cd $tomcat_dir

################  stop tomcat ################
echo "stop server..."
cd bin/ 
./shutdown.sh 
echo "stop server success..."
sleep 2 
################  stop tomcat ################


################  backup files ###################
cd ../webapps/
echo "begin backup $project_name" 
tar -cvf $project_name-$(date "+%y%m%d%H%M%S").tar $project_name
echo "backup success!" 
sleep 3
################  backup files ###################


################  delete files ###################
echo "begin delete $project_name..." 
rm -rf $project_name
echo "delete success!"
sleep 2 
################  delete files ###################


################  unzip files ###################

if test -e  $project_name.zip
then
    echo "begin unzip $project_name ..." 
	unzip $project_name.zip
	echo "unzip success!" 
	sleep 2 
	################  start server ###################
	cd ../bin/
	./startup.sh
	echo "start server now , please wait..." 
	################  start server ###################
else
	echo "$project_name.zip is not exist!"
	return
fi
################  unzip files ###################
