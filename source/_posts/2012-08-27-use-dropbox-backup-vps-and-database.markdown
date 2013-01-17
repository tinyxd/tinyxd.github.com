---
layout: post
title: "用Dropbox备份VPS网站及数据库 "
date: 2012-08-27 23:28
comments: true
categories: vps
tags: [vps,dropbox]
keywords: vps,dropbox,备份数据库
description: 用Dropbox自动备份同步VPS网站及数据库
---
用SSH客户端（PuTTY）登陆，进入root目录：   
	cd ~
linux下用ssh登录：   
	ssh (ip) -l (用户名) -p (端口号)
	或者
	ssh username@ip
	或者	
	ssh username@domain
下载dropbox程序：   
32位版本：   
    wget -O dropbox.tar.gz http://www.dropbox.com/download/?plat=lnx.x86
64位版本：
    wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64
<!--more-->
解压缩：
        tar -zxof dropbox.tar.gz
然后第一次运行dropbox：
        ~/.dropbox-dist/dropboxd &
运行后会出现一串URL地址，把这个复制到流量器上，跟你的dropbox账户进行绑定。 
绑定好之后就可以开始同步了。   
首先进入dropbox，   
       cd ~/Dropbox
备份整个wwwroot目录，建立一个软连接：   
        ln -s /home/wwwroot
由于dropbox耗费的内存确实够大，建议不要开太长时间   
<img src="http://upload.tinyxd.me/2012/08/dropboxload.jpg"  alt="dropboxload" width="778" height="200">   
如果上面操作没有错误的话，在dropbox就可以看到同步的文件了。   
附别人写的一个脚本：
``` bash dropboxbak.sh 
       #!/bin/sh
        BACKUP_SRC="/root/Dropbox"  #用于同步的本地目录
        BACKUP_WWW="/home/wwwroot"     #你的网站目录
        NOW=$(date +"%Y.%m.%d")
        MYSQL_SERVER="127.0.0.1"
        MYSQL_USER="user"
        MYSQL_PASS="password"
        DAY=$(date +"%u")             #取当前星期，1表示周一
        start() {
       echo starting bak SQL
        #dump数据库数据，以及备份网站整站文件
        mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p$MYSQL_PASS 需要备份的数据库名称 > "$BACKUP_SRC/$NOW-Databases.sql"
        echo starting dropbox
        /root/.dropbox-dist/dropboxd &
        }
        stop() {
        echo stoping dropbox
        pkill dropbox
        }
        case "$1" in
        start)
        start
        ;;
        stop)
        stop
        ;;
        esac
```
将脚本放到~/.dropbox下，修改脚本权限：   
            chmod 755 ~/.dropbox/dropboxbak.sh
添加计划任务：   
            crontab –e
添加两条内容：   
                0   3 * * * sh /root/.dropbox/dropboxbak.sh start

                30 3 * * * sh /root/.dropbox/dropboxbak.sh stop
具体参数参照文档。   
删除dropbox的方法：   
``` bash
# sh /root/.dropbox/dropboxbak.sh stop
# su - root
# cd
# rm -rf .dropbox .dropbox-dist  Dropbox dropbox.tar.gz dbmakefakelib.py dbreadconfig.py
```      
更多内容请参考相关网站。
</br>