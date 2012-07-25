---
layout: post
title: "archlinux升级出现关于glibc的问题解决办法"
date: 2012-07-25 18:44
comments: true
categories: linux
tags: [archlinux,linux]
keywords: archlinux,update,glibc
description: 由于arlinux目录更新，glibc更新，升级archlinux出现错误。本文讲述了此次升级出现问题的解决方法。
---
好久没更新archlinux，今天更新，发现由于archlinux系统根目录结构的改变，导致好多人遇到问题，不错，笔者必然也遇到了。由于有前人的探索，再加上查阅archlinux官网论坛，得以顺利解决问题。
运行`pacman -Syu`时会出现   
```
error: failed to commit transaction (conflicting files)
glibc: /lib exists in filesystem
Errors occurred, no packages were upgraded.
```   
由于这次是glibc的升级，绝对不可以用`--force`，而之前是filesysterm的升级，必须用`--force`。   
那么接下来该怎么办呢？   
查阅了archlinux论坛地址：<https://bbs.archlinux.org/viewforum.php?id=44>，并参考了[这篇文章](http://www.j927.net/arch/archlinux%E5%8D%87%E7%BA%A7%E5%A4%B1%E8%B4%A5%E9%97%AE%E9%A2%98%E8%A7%A3%E5%86%B3%E8%AE%B0%E5%BD%95.html)。      
发现这个[帖子](https://bbs.archlinux.org/viewtopic.php?id=145186)，其中提到这两篇文章：[updating-arch-linux-from-a-core-install](http://allanmcrae.com/2012/07/updating-arch-linux-from-a-core-install/) 和[DeveloperWiki:usrlib](https://wiki.archlinux.org/index.php/DeveloperWiki:usrlib)，总结以下命令：   
<!--more-->   
```
shell > pacman -Sy
shell > rm -rf /var/run /var/lock && pacman -Sf filesystem
shell > pacman -S tzdata
shell > pacman -U http://pkgbuild.com/~allan/glibc-2.16.0-1-i686.pkg.tar.xz #32位的用这个包(和下面的一条命令二选一)
shell > pacman -U http://pkgbuild.com/~allan/glibc-2.16.0-1-x86_64.pkg.tar.xz #64位的用这个包 具体的包名称可以打开http://pkgbuild.com/~allan/看一下
shell > rm /etc/profile.d/locale.sh
shell > pacman -Su --ignore glibc #因为pacman也升级了，新版本开启了软件包签名验证，故还需要运行下面2条命令
shell > pacman-key --init #该命令运行后不要什么都不做，随机敲键盘或者切换到其它终端(Alt+F2)运行些命令或做些其它操作
shell > pacman-key --populate archlinux
shell > pacman -Su #再更新被忽略的glibc
```
执行完上述命令后，系统顺利更新好了，但是依然出现下述问题：   
```
error: failed to commit transaction (conflicting files)
glibc: /lib exists in filesystem
Errors occurred, no packages were upgraded.
```   
我就去论坛中寻找，果不其然也有类似于我的情况，原帖[在此](http://bbs.archbang.org/viewtopic.php?pid=16509)。
```
shell > pacman -R broadcom-wl
shell > pacman -Su
shell > pacman -S broadcom-wl #如果需要的话，再次安装即可
```
至此，升级结束。  
<br />
本站文章如果没有特别说明，均为**原创**，转载请以**链接**方式注明本文地址：<http://tinyxd.me/blog/2012/07/25/archlinux-update-about-glibc/>

