## world of linux 

#### 1. 语系支持

有时候我们使用linux时会发现不能正常显示中文，显示结果是乱码~ 只需要将支持语系改为英文即可：

显示目前所支持的语系   

    echo $LANG 

修改诧系成为英文语系（注意指令中没有空格）

    LANG="en_US.UTF-8"

修改诧系成为中文文语系（注意指令中没有空格）

	LANG="zh_CN.UTF-8"

把LANG变量清空，由于英语是无论什么情况都支持的，LANG变量被清空后，系统就默认用英语。

	LANG=""


