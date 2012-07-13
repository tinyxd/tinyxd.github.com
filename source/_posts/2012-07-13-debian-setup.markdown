---
layout: post
title: "debian硬盘安装笔记"
date: 2012-07-13 11:29
comments: true
categories: linux
tags: [debian,linux]
keywords: debian,linux,setup,硬盘安装
description: 硬盘安装debian系统
---
以前安装的时候都有光盘，这次换的机器，光驱坏了，那么有没有可能硬盘安装debian么？答案当然是可以的。   
1.下载debian最新ISO映像。   
2.下载安装所需要的vmlinuz  initrd.gz  boot.img.gz的这三个文件.   
   下载地址：<http://debian.osuosl.org/debian/dists/Debian6.0.5/main/installer-i386/current/images/hd-media/>   
3.下载grub4 for DOS      
下载地址：<http://download.gna.org/grub4dos/grub4dos-0.4.4-2009-06-20.zip>   
##安装过程：   

1、先把WINXP安装到C盘，这里唯一要说的是如果在安装WINXP时，选择了把C盘格式化为NTFS格式，那么之后安装用的DEBIAN的ISO文件就不能放在C盘了，必须放在FAT32格式的分区的根目录下。切记哦！否则硬盘安装DEBIAN时后找不到ISO文件哦。

WINXP安装好以后，把下载的GRUB4 for DOS包解压缩到C盘根目录，并将目录名改为grub，（个人认为不改也应该可以，不过没试，你可以试下呵），并进入GRUB目录将grldr文件复制到C盘根目录下；把vmlinuz、initrd.gz、boot.img.gz三个文件也复制到C盘根目录下：（基本上这个时候C盘是NTFS格式还是FAT32格式都没有关系的）
<!--more-->
2、打开C盘根目录下的boot.ini文件，打开boot.ini后在文件的最后一行加上    C:\grldr=”GRUB FOR DOS”  

之后保存并关闭boot.ini文件。

3、把前面下载的DEBIAN安装CD的ISO文件复制到C盘根目录下，（要保证C盘是FAT32格式的），否则就复制到其它FAT32分区的根目录下。

4、以上检查没有问题后重新启动电脑，这时应该会出现如下启动菜单：

5、选第二项“GRUB FOR DOS”后，等屏幕出现如下画面时，按键盘上的“C”进入命令行状态。

6、按“C”键后屏幕显示如下：

7、这个时候输入如下三行命令：

	kernel (hd0,0)/vmlinuz
	
	initrd (hd0,0)/initrd.gz
	
	boot

这里的（hd0,0）指的是C盘，hd是指硬盘啦，第一个0是指电脑里的第一块硬盘，第二个0是指该硬盘上的第一个主分区，如果是第二个主分区就是（hd0,1）啦，如果你有兴趣上网查一下相关的知识了，这里不说了。

8、接下来就是安装debian，先会自动寻找ISO映像，找到后就开始安装，不再赘述。

9、如果你的C盘是FAT32格式的，ISO文件也复制到C盘根目录，那么就不用担心了，安装程序会自动找到的。（ISO文件在其它FAT32分区根目录下也一样，我已试过呵）

10、我的分区是这样的：/boot 200M  、2G swap、15G / 、其余大概40G的/home   

11、等系统装好后，需要设置中文字体，还需要安装一些必要软件等等。见我以前的文章，下面是链接：<http://blog.chinaunix.net/uid-26053577-id-3011222.html>   

本文章来自本人**[ChinaUnix](http://blog.chinaunix.net/uid/26053577.html)**博客。    
本站文章如果没有特别说明，均为**原创**，转载请以**链接**方式注明本文地址：<http://tinyxd.me/blog/2012/07/13/debian-setup/>   