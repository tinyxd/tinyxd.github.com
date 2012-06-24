---
layout: post
title: "linux下使用lftp的小结"
date: 2012-06-04 07:08
comments: true
categories: linux 
tags: [linux , lftp]
keywords: linux,lftp
description: linux下使用lftp的小结
---

lftp的功能比较强大，相比原来用ftp，方便了很多。

1、登陆：

lftp ftp://yourname@site   

pwd:*****   

或 open ftp://yourname@site   

 
<!--more-->
2、基本操作（转）   
lftp使用介绍   

lftp 是一个功能强大的下载工具，它支持访问文件的协议: ftp, ftps, http, https, hftp, fish.(其中ftps和https需要在编译的时候包含openssl库)。llftp的界面非常想一个shell: 有命令补全，历史记录，允许多个后台任务执行等功能，使用起来非常方便。它还有书签、排队、镜像、断点续传、多进程下载等功能。   
命令行语法
要看lftp的命令行语法，只要在shell中输入lftp --help   
lftp [OPTS]
'lftp'是在 rc 文件执行后 lftp 执行的第一个命令   
-f 执行文件中的命令后退出   
-c 执行命令后退出   
--help 显示帮助信息后退出   
--version 显示 lftp 版本后退出   
其他的选项同 'open' 命令   
-e 在选择后执行命令   
-u [,] 使用指定的用户名/口令进行验证   
-p 连接指定的端口   
主机名, URL 或书签的名字   
如果在命令行中输入的站点名称，lftp将直接登录站点，比如   
ftp ftp://.............   
如果在命令行不输入站点名称，则必须在进入到lftp界面后用open命令打开   
[yhj@ccse-yhj yhj]$ lftp   
lftp :~> open ftp://...................   
常用命令   
* 下载单个文件和一组文件，断点续传用-c参数   
lftp ................:/> get -c ls-lR.txt   
lftp ...............:/> mget *.txt   
* 镜像(反镜像即上传)一个目录，可以用多个线程并行镜像一个目录(--parallel=N)   
lftp ................:/> mirror incoming local_name   
lftp ................:/> mirror -R local_name   
lftp ................:/> mirror --parallel=3 incoming local_name   
* 多线程下载，类似网络蚂蚁的功能;缺省是5个线程   
lftp ................:/> pget -n 4 ls-lR.txt   
* 后台任务管理   
缺省情况下，按 Ctrl+z,正在执行的任务将转为后台执行，也可以在命令行末尾加&符号使任务在后台执行。用jobs命令可以查看所有的后台进程。用queue命令可以排队新的任务。如果退出lftp是还有任务在后台执行，lftp将转为后台执行。   
* 其它用法   
lftp支持类似bash的管道操作，例如用下面的命令可以将ftp服务器上的特定目录下(也可以是整个站点)所有文件的大小存到本地的文件ls.txt中   
lftp ................:/> du incoming > ls.txt   
相关文件
/etc/lftp.conf   
全局配置文件，实际位置依赖系统配置文件目录，可能在/etc，也可能在/usr/local/etc   
~/.lftp/rc, ~/.lftprc   
用户配置文件，将在/etc/lftp.conf之后执行，所以这里面的设置会覆盖/etc/lftp.conf中的设置。   
lftp 缺省不会显示 ftp 服务器的欢迎信息和错误信息，这在很多时候不方便，因为你有可能想知道这个服务器到底是因为没开机连不上，还是连接数已满。如果是这样，你可以在 ~/.lftprc 里写入一行   
debug 3
就可以看到出错信息了。   
更多的配置选项请查man手册或在lftp界面内用命令 set -a 获得。   
~/.lftp/log   
当lftp转为后台非挂起模式执行时，输出将重定向到这里   
~/.lftp/bookmarks   
这是lftp存储书签的地方，可以lftp查看bookmark命令   
~/.lftp/cwd_history   
这个文件用来存储访问过的站点的工作目录   
   
~/.lftprc    
在用lftp访问国内一些ftp服务器时，往往看到的中文是乱码    
^_^不用慌，这是由于服务器和本地编码不一致造成的。我们只要在主目录下新建一个文件~/.lftprc或者~/.lftp/rc    
并在其中加入以下内容：    
debug 3set ftp:charset GBKset file:charset UTF-8#set ftp:passtive-mode no#alias utf8 " set ftp:charset UTF-8"#alias gbk " set ftp:charset GBK"    
登录ftp服务器    
言归正传，我们先来看看怎么登录ftp服务器    
lftp ftp://user:password@site:port    
lftp user:password@site:port    
lftp site -p port -u user,password    
lftp site:port -u user,password    
上面的几种方式都能正常工作，不过密码都是明文，这样好像不太安全哦。没关系    
lftp user@site:port    
系统会提示输入password，密码就回显为******了    
不过每次都输入这么多，好麻烦哦。 如果有类似leapftp的站点管理器就好了，其实lftp早就给我们想好了： 这就是bookmark。后面我们将会看到。    
常用命令    
在终端运行    
man lftp    
或登录ftp后输入    
help    
就可以看到命令列表    
下面我们看一下lftp常用的命令：    
ls    
显示远端文件列表(!ls 显示本地文件列表)。    
cd    
切换远端目录(lcd 切换本地目录)。    
get    
下载远端文件。    
mget    
下载远端文件(可以用通配符也就是 \*)。    
pget    
使用多个线程来下载远端文件, 预设为五个。    
mirror    
下载/上传(mirror -R)/同步 整个目录。    
put    
上传文件。    
mput    
上传多个文件(支持通配符)。    
mv    
移动远端文件(远端文件改名)。    
rm    
删除远端文件。    
mrm    
删除多个远端文件(支持通配符)。    
mkdir    
建立远端目录。    
rmdir    
删除远端目录。    
pwd    
显示目前远端所在目录(lpwd 显示本地目录)。    
du    
计算远端目录的大小    
!    
执行本地 shell的命令(由于lftp 没有 lls, 故可用 !ls 来替代)    
lcd    
切换本地目录    
lpwd    
显示本地目录    
alias    
定义别名    
bookmark    
设定书签。    
exit    
退出ftp    
快捷书签    
补充作者：aBiNg    
ftp中的bookmark命令，是将配置写到~/.lftp/bookmarks文件中；我们可以直接修改此文件，快速登陆ftp服务器。   



 

3、mirror 同步镜像，备份服务器文件

今天主要的问题是解决如何备份服务器端文件的问题。了解了mirror指令的用法后，发现比较适合而且好用。

 

基本使用方法：

1）、下载服务器端文件：

 mirror –vn RCD LCD   //RCD为远程路径，LCD为本地路径

2）、上传文件：

 mirror –R LCD RCD

 

下附一个自动同步的脚本：
```bash
#!bin/bash
echo “script start at  `date ”+%Y-%m-%d %H:%M:%S”
HOST=”hostname”
USER=”yourname”
PASS=”password”
LCD=”LocalePath”
RCD=”RemotePath”
/usr/sbin/lftp << EOF
open ftp://$USER:$PASS@$HOST
mirror $RCD $LCD
EOF
echo “script end at “ `date ”+%Y-%m-%d %H:%M:%S”
```





