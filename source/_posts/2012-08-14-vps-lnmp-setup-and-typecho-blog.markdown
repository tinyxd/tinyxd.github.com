---
layout: post
title: "VPS申请及博客搭建"
date: 2012-08-14 00:33
comments: true
categories: vps
tags: [vps,typecho]
keywords: vps,typecho,主机申请,博客搭建
description: vps申请，typecho博客安装方法，lnmp安装过程，及博客的数据备份过程。
---

前些天，在网上溜达时，突然看到一款免费的vps。不错。。。免费的。。。哥当时是激动啊，对于像我这样的屌丝，有免费的当然不会放过的。   
于是乎哥就开始折腾了。   
一、Vps申请   
Vps是host1free提供的（128MB,10G,无限流量），申请地址：<http://www.host1free.com/free-vps/> ，看网上说，这已经是第三次开放注册了，一共2万个。最好翻墙注册，注册时最好用Gmail邮箱，不要用qq邮箱，然后就是耐心的等待了。建议大家，真心做正规站的来申请，做采集站的（包括采集类影视、小说、淘客及黑客、成人等违反TOS和中美法律内容）绕道吧。这个免费的vps对于想学习vps搭建博客的人实属不易。   
二、 安装lnmp   
<!--more-->
参考[LNMP一键安装包]( http://lnmp.org/install.html)，其中会用到putty工具，可以到[这里](http://dl.pconline.com.cn/html_2/1/97/id=3978&pn=0.html)下载。   
按照上面的步骤进行操作。需要说明的是   
1. 第一条命令`screen –S lnmp`很重要，当网络突然掉线或者不小心putty被关掉时候，可以用`screen –r lnmp`看到之前lnmp所进行到的情况。对于没有screen的可以按照[这里]( http://www.vpser.net/manage/run-screen-lnmp.html)进行安装。   
2. 当需要将二级域名绑定到此空间时，我所用的博客工具是typecho，当添加了虚拟主机后，进入后台出现404错误，一般出现这样的情况是nginx设置伪静态的问题，这个情况lnmp已经帮我们解决了。但是，我的仍然出现了404问题，最后把`/usr/local/nginx/conf/nginx.conf`里面的server_name 和所绑定的域名重名了。只要随便改个名字就好了。    
三、 安装typecho    
安装过程，[官方文档]( http://docs.typecho.org/install)已经说的够详细了，这里就不再多说了。   
四、 数据库的备份问题    
数据备份，这个始终是个大问题。可以到[这里]( http://www.vpser.net/vps-howto)参考，也可以使用rsync来同步备份。   
五、关于新建站点    
至于这个新建的站点，其实想法还没有成熟，只是想分享一些互联网，linux方面的资讯，还有一些搞笑的轻松的话题。地址是：<http://info.tinyxd.me>    
ps：博客还没有取名，希望大家给点建议。    
<br />
关于vps，lnmp比较好的文章：    
[LNMP一键安装升级nginx及php常用设置 SFTP管理指南](http://www.cnblogs.com/amityat/archive/2011/08/23/2150177.html)   
[VPS新手指南/教程](http://www.vpser.net/vps-howto)   
<br />
