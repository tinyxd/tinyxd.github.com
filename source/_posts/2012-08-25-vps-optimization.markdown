---
layout: post
title: "vps lnmp配置优化"
date: 2012-08-25 23:40
comments: true
categories: vps
tags: [vps,lnmp]
keywords: vps优化,lnmp配置
description: 由于资金有限，多数朋友选用了内存比较小的vps，这样就需要进行一些优化。
---
我选用了lnmp（linux + Nginx + PHP + MySQL ）来安装，方便快捷，安装后发现其实好多已经优化好了。    
其中需要注意到的有以下几个：   
一. 基于xen架构的可以增加swap分区大小
我的vps是openVZ的，swap分区是不能随意更改的。PS.主机商已经提供了128M的swap了。满足了！   
```
cd /var/
dd if=/dev/zero of=swapfile bs=1024 count=262144
/sbin/mkswap swapfile
/sbin/swapon swapfile
```
然后让自己做的swap分区在系统启动时自动加载：
	vi /etc/fstab   
在适当位置添加以下内容：    

	/var/swapfile swap swap defaults 0 0
<!--more-->
二.Nginx主配置文件（nginx.conf）的优化
Nginx每个进程耗费10M~12M内存，只开启一个Nginx进程，节省内存。   
	worker_processes 1;   
对网页文件、CSS、JS、XML等启动gzip压缩，减少数据传输量，提高访问速度。   
	gzip on;
	gzip_min_length  1k;
	gzip_buffers     4 16k;
	gzip_http_version 1.0;
	gzip_comp_level 2;
	gzip_types       text/plain application/x-javascript text/css application/xml;
	gzip_vary on;
还有：   
	location ~ .*\.(php|php5)?$
	   {
	     #将Nginx与FastCGI的通信方式由TCP改为Unix Socket。TCP在高并发访问下比Unix Socket稳定，但Unix Socket速度要比TCP快。
	     fastcgi_pass  unix:/tmp/php-cgi.sock;
	     #fastcgi_pass  127.0.0.1:9000;
	     fastcgi_index index.php;
	     include fcgi.conf;
	   }
	
	   location ~ /read.php
	   {
	     #将Nginx与FastCGI的通信方式由TCP改为Unix Socket。TCP在高并发访问下比Unix Socket稳定，但Unix Socket速度要比TCP快。
	     fastcgi_pass  unix:/tmp/php-cgi.sock;
	     #fastcgi_pass  127.0.0.1:9000;
	     fastcgi_index index.php;
	     include fcgi.conf;
	   }
	   
	   #博客的图片较多，更改较少，将它们在浏览器本地缓存15天，可以提高下次打开我博客的页面加载速度。
	   location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
	   {
	     expires      15d;
	   } 
	
	   #博客会加载很多JavaScript、CSS，将它们在浏览器本地缓存1天，访问者在看完一篇文章或一页后，再看另一篇文件或另一页的内容，无需从服务器再次下载相同的JavaScript、CSS，提高了页面显示速度。
	   location ~ .*\.(js|css)?$
	   {
	     expires      1d;
	   }   
	
其实上面说的lnmp自动安装包已经做好了这些优化！   
包括后面[这篇文章](http://blog.s135.com/post/375/2/1/)提到的，lnmp已经配置好了。   

<br />
对于新手的忠告，将配置改好后，记得reload，或者restart。   
经过优化后的vps，有人做过测试一小时，1000+的pv量都是没有问题的。相同的价格可见买vps还是比较合算的。   
PS.我的vps现在放了两个站：[本站](http://tinyxd.me/)、[冰之竹语](http://info.tinyxd.me/)。后期准备再弄个技术bbs之类的玩玩。   
对了我还放了个文件管理器[Encode Explorer](http://encode-explorer.siineiolekala.net/)，专门用来存放上传的图片和文件的。地址在[这里](http://upload.tinyxd.me/)。其实这一招是从[这里](http://log4d.com/2012/05/image-host/)学来的。。。
我将在我的下一篇[文章](http://tinyxd.me/2012/08/25/imag-file-explorer/)中详细说明。   
<br />
本文地址：<http://tinyxd.me/2012/08/25/vps-optimization/>

