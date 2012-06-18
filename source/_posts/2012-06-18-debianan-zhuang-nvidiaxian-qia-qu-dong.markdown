---
layout: post
title: "debian安装nvidia显卡驱动"
date: 2012-06-18 20:31
comments: true
categories: linux
---

在自己的电脑上硬盘安装了Debian.下面介绍一下我是如何安装显卡驱动的.我的显卡是GForce 7100GS的.

1>下载显卡驱动.

这个可以到Nvidia的官网上去找,找到自己对应的版本就可以了。

2>安装gcc并设置版本.  

\#apt-get install gcc 这样安装的是gcc-4.4,如果在安装过程中提示您安装的gcc版本有问题,你可以再安装一下gcc-4.3并将gcc版本设置为4.3,具体做法:

\#apt-get install gcc-4.3

\#ln -sf /usr/bin/gcc-4.3 /usr/bin/gcc 这一句用来将gcc的版本设置为4.3

\#ls -l /usr/bin/gcc* 这一句用来查看当前使用的gcc版本
<!--more-->
3>安装make

\#apt-get install make

4>安装编译头文件

\#apt-get install build-essential linux-headers-$(uname -r)

5>编辑 /boot/gurb/grub.cfg

在linux /vmlinuz -2.6.32-5.........quite 后面加上 nomodeset  (作用是将原来普适的显卡驱动禁用)

6>进入字符界面 Ctrl+Alt+F1

7>停用X-Server:

\#/etc/init.d/gdm3 stop

8>安装显卡驱动:

 \# sh .... (省略号部分为你下载的显卡驱动的名称) 你将会看到安装的进度条.

9>\#startx
