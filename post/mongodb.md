## java + mongodb

### 一、 简介

略...

### 二、安装

	1. 从官方下载页面的第一行（这是推荐的稳定版本）下载与您操作系统相应的安装包。根据不同的开发需要，选择32位或是64位的包。
	
	2. 解压下载的包（到任意路径）并进入bin子目录，暂且不要执行任何命令。让我先介绍一下，mongod将启动服务器进程而mongo会打开客户端的shell——大部分时间我们将和这两个可执行文件打交道。
	
	3. 在bin子目录中创建一个新的文本文件，取名为mongodb.config。
	
	4. 在mongodb.config中加一行：dbpath=PATH_TO_WHERE_YOU_WANT_TO_STORE_YOUR_DATABASE_FILES。例如，在Windows中您需要添加的可能是dbpath=c:\mongodb\data而在Linux下可能就是dbpath=/etc/mongodb/data。
	
	5. 确认您指定的dbpath是存在的。
	
	6. 执行mongod，带上参数--config /path/to/your/mongodb.config。

以Windows用户为例，如果您把下载的的文件解压到c:\mongodb\，创建了c:\mongodb\data\，然后在c:\mongodb\bin\mongodb.config中添加了dbpath=c:\mongodb\data\。那么您就可以在命令行中输入以下指令来启动mongod：

	c:\mongodb\bin\mongod --config c:\mongodb\bin\mongodb.config

此时您可以运行mongo了（没有d），它会启动一个shell并连接到运行中的服务器。输入'db.version()`以确认所有的东西都正常工作：您应该可以看到您所安装的软件版本。
	
    > db.version();
	> 2.27
	