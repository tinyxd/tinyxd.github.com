---
layout: post
title: "嵌入式linux应用程序自启动"
date: 2012-06-10 19:46
comments: true
categories: Embedded
tags: [linux,embedded ]
keywords: linux,embedded systerm ,start up
description: 嵌入式linux应用程序自启动.
---
在很多嵌入式系统中，由于可用资源较少，常常在系统启动后就直接让应用程序自动启动，以减少用户操作和节省资源。如何让自己的应用程序自动启动呢？    在Linux系统中，配置应用程序自动启动的方法有以下三种：   
<!--more-->
## 1.通过/Linuxrc脚本直接启动   
Linux内核一旦开始执行，它将通过驱动程序来初始化所有硬件设备，这个初始化过程可以在启动时的PC显示器上看到，每个驱动程序都打印一些相关信息。初始化完成后，通常调用的是init，通过loader调用init内的init=/app_program语句（通过loader向核心传入init=/program可以定制首先运行的程序）。   
比如在桌面Linux系统中，init进程会读取/etc/inittab文件，来决定执行级别和哪些脚本和命令。嵌入式应用开发中，可以根据实际情况决定是否使用标准的init执行方式，也许这个init是个静态程序，它能够完成我们的嵌入应用的特定任务，那完全不用考虑inittab了，在这里可以采用比较灵活的措施。   
## 2.在/etc/init.d下添加启动脚本    
一般情况下，大多数的Linux操作系统使用/etc/init.d/(或/etc/rc.d/init.d)下的脚本来配置应用程序的自动启动。   
例如，在某些Linux系统中，corn程序通过/etc/init.d/corn脚本启动，Apache通过/etc/init.d/httpd启动，syslogd通过/etc/init.d/syslogd启动，而sshd则通过/etc/init.d/sshd脚本启动。   
通常这些脚本通过来自特定rc.d目录的符号链接运行。为了配置从哪个rc.d目录运行脚本，Linux系统提供了许多不同的工具，同时也可以手工进行配置。Linux系统有一个包含所有实际启动脚本文件的目录。它可能是/etc/init.d，也可能是/etc/rc.d/rc.d。同时对应每个运行级别（runlevel）又有一个另外的目录，它们可能是/etc/rc2.d，也可能是/etc/rc.d/rc2.d。这些目录中的文件通常是指向实际脚本文件的符号链接。   
## 3.直接在/etc/rc.d/rc.local脚本中添加命令  
在Linux系统中，有一个类似Windows系统中autoexec.bat的文件，它就是/etc/rc.d/rc.local，系统开机后自动运行用户的应用程序或启动系统服务的命令保存在开发板根文件系统的这个文件中。因此可以编辑rc.local文件，将要执行的程序（命令）添加到该文件夹中。Linux系统在启动后还未登录前，将自动执行该程序（命令），达到开机自动运行用户的应用程序的目的。   
下面具体说明：    
首先解压ramdisk.image.gz文件，然后挂载到系统中。接着创建自己的应用程序文件夹hello，将所要自动运行的应用程序hello复制到该文件夹。   
然后打开/usr/etc/rc.local文件，在最后一行加入：/Myapp/hello/hello   
再按上面的顺序将ramdisk.image打包下载到目标板，启动运行，则可以看到用户编写的应用程序一启动就运行起来了。   
本文参考《基于ARM9的嵌入式Linux开发技术》，李新峰等编著。   