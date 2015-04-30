## pyspider 

### 一、 在window 下安装pyspider

系统： window8 64bit 

python: <a href="https://www.python.org/ftp/python/3.4.2/python-3.4.2">python-3.4.2.msi</a>


注意不要下载64位的 会出现软件崩溃现象

### 1. 安装

注意安装时候要将python加入path

### 2. 升级pip

在 linux 或 OS 中

    pip install -U pip

在 window 中	

    python -m pip install -U pip

详细地址： <a href="https://pip.pypa.io/en/latest/installing.html#install-pip">https://pip.pypa.io/en/latest/installing.html#install-pip</a>

### 3 安装依赖的库 lxml 和 pycurl 

window下，python二进制库下载地址：<a href="http://www.lfd.uci.edu/~gohlke/pythonlibs/">http://www.lfd.uci.edu/~gohlke/pythonlibs/</a>

下载 lxml-3.4.4-cp34-none-win32.whl 和 pycurl-7.19.5.1-cp34-none-win32.whl

用pip手动安装二进制文件

    pip lxml-3.4.4-cp34-none-win32.whl
    pip install pycurl-7.19.5.1-cp34-none-win32.whl

### 4 安装pyspider

	pip install pyspider

运行pysipder

    pyspider

访问地址：

    http://localhost:5000/

尼玛，搭建环境都花了就个上午。差点就放弃了~ 

接下来就好好享受爬虫带来的快乐喽~

等等， centos下安pycurl 和 lxml 装又出了毛病：

安装的时候出现

    error Python headers needed to compile C extensions, please install develop

谷歌一下： 

	yum install python-devel

然后接着安装 lxml 和 pycurl：

    pip install lxml;
    pip install pycurl


然后就是安装pyspider了，但是他奶奶的又提示：

	  Traceback (most recent call last):
		 File "/usr/bin/pyspider", line 5, in <module>
		    from pkg_resources import load_entry_point
		 File "/usr/lib/python2.6/site-packages/pkg_resources.py", line 2655, in <module>
		    working_set.require(__requires__)
		 File "/usr/lib/python2.6/site-packages/pkg_resources.py", line 648, in require
		    needed = self.resolve(parse_requirements(requirements))
		 File "/usr/lib/python2.6/site-packages/pkg_resources.py", line 546, in resolve
		    raise DistributionNotFound(req)
		 pkg_resources.DistributionNotFound: six

又折腾了一会，https://github.com/binux/pyspider/blob/master/requirements.txt 原来运行pyspider还要这些条件：

    Flask>=0.10
	Jinja2>=2.7
	chardet>=2.2
	cssselect>=0.9
	lxml
	pycurl
	pyquery
	requests>=2.2
	tornado>=3.2
	mysql-connector-python>=1.2.2
	pika>=0.9.14
	pymongo>=2.7.2,<3.0
	unittest2>=0.5.1
	Flask-Login>=0.2.11
	u-msgpack-python>=1.6
	click>=3.3
	SQLAlchemy>=0.9.7
	six
	amqp>=1.3.0
	redis
  
没办法，升级呗，键入一下口令：

    easy_install --upgrade six；
    easy_install --upgrade click；
    easy_install --upgrade requests；
    easy_install --upgrade certifi；
    easy_install --upgrade Werkzeug；

之后再次运行`pyspider`命令出现：

	[I 150430 02:21:44 result_worker:49] result_worker starting...
	[I 150430 02:21:44 scheduler:436] loading projects
	[I 150430 02:21:44 tornado_fetcher:427] fetcher starting...
	[I 150430 02:21:44 processor:206] processor starting...
	[I 150430 02:21:44 scheduler:377] in 5m: new:0,success:0,retry:0,failed:0
	[I 150430 02:21:44 app:65] webui running on http://0.0.0.0:5000/
  
测试地址http://locahost:5000 可爱的画面终于出现了！！！

至此，环境搭建终于搞定了！ 嘎嘎嘎嘎....