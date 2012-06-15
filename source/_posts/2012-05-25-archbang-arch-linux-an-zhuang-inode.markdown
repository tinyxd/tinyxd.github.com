---
layout: post
title: "archbang arch linux 安装inode "
date: 2012-05-25 14:34
comments: true
categories: linux 
---

第一步：cp iNodeClient.tar.gz 到 /home/\*\*\*\*\* 目录下。进入~目录下    
第二步：终端运行 tar -xvf iNodeClient.tar.gz。  
第三步：修改/home//iNodeClient/下install.sh，把 OS_UBUNTU=\`cat /etc/issue | grep 'Ubuntu'\`那一行及以下的脚本都删除，然后保存，执行sudo ./install.sh。  
第四步：cp  home/\*\*\*\*\*/iNodeClient/ 目录下的iNodeAuthService到/etc/rc.d/目录下，并修改权限chmod 755 /etc/rc.d/iNodeAuthService。  
第五步：打开/etc/rc.conf ，在DAEMONS处添加@iNodeAuthService。（让iNode认证服务开机自启动）   
第六步：现在执行sudo /etc/rc.d/iNodeAuthService start，发现出错了。错误出现在enablecards.ps这个文件里，打开看，你会发现这个文件的作用只是用来up网卡。一般来说你的网卡都已经up了的啦。你可以把里面的内容改成：   
\#!/bin/sh  
x=eth0（你所使用的网卡）   
ifconfig $x up    
再运行一次sudo /etc/rc.d/iNodeAuthService start，你应该会发现服务启动成功了。    
第七步：命令行里面执行一下sudo ./iNodeClient 然后楼主发现出现了一些库的依赖问题。iNode需要一些比较旧的库，对于jpeg tiff等库 你可以用ln -s 来用新版本的库代替旧版本。而其中有一个是libpng12.so.0是必须需要旧版本的。见附件 或者可以去官网自己下载ftp://ftp.simplesystems.org/pub/libpng/png/src/    
需要下载的文件是libpng-1.2.49.tar.bz2   
安装方法如下：   
1.解压，然后执行./configure --prefix=/usr/   
2.编译及安装   
\#make    
\#make install   
安装之前可以make check 以下 看看有没有什么错误，如果没错误 make install 那么libpng就安装好了。   

   


参考：http://ecnc.sysu.edu.cn/viewthread.php?tid=18558