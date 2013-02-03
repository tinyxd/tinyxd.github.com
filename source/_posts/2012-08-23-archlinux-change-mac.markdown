---
layout: post
title: "archlinux修改mac地址"
date: 2012-08-23 00:03
comments: true
categories: linux
tags: [mac,archlinux,linux]
keywords: mac,修改mac,archlinux,
description: 校园网需要mac地址验证，故需要在linux系统下修改mac地址。
---
快开学了，开学了紧接着就是找工作。由于今年的形势还不太好，所以最近一直在复习一些编程方面的东西，好久没更新文章了。   
还没到月底，自己的流量都已经用完了，悲催啊！！！借用别人的，这就需要修改mac地址。学校流量3G真的伤不起阿！！！囧   
查阅Archlinux Wiki可以看到有两种临时改变mac地址的方法：    
1.使用macchanger或者使用ip命令：    
``` bash
macchanger --mac=XX:XX:XX:XX:XX:XX
```
或者
``` bash
ip link set dev eth0 down
ip link set dev eth0 address XX:XX:XX:XX:XX:XX
ip link set dev eth0 up
```
2.在每次启动时自动修改MAC地址。     
创建文件`/etc/rc.d/functions.d/macspoof`     
```
spoof_mac() {
	ip link set dev eth0 address XX:XX:XX:XX:XX:XX
}

add_hook sysinit_end spoof_mac
```
具体可参见Archlinux wiki。   

inode上网可参考我以前的一篇文章:<http://blog.tinyxd.me/blog/2012/05/25/archbang-arch-linux-an-zhuang-inode/>   
 

