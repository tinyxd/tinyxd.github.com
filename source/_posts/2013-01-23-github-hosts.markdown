---
layout: post
title: "恢复访问Github"
date: 2013-01-23 10:55
comments: true
categories: git
tags: [hosts,git]
keywords: github屏蔽 | 修改hosts
description: 12306订票助手拖慢Github，致使Github被屏蔽。因为使用DNS污染来屏蔽Github，所以可以修改Hosts来解决这一问题。
---
12306订票助手拖慢Github，最近Github被屏蔽。具体是不是这个原因导致被屏蔽还不得而知。因为使用DNS污染来屏蔽Github，所以可以通过修改Hosts来解决这一问题。    
因为本博客源码，还有一些非常优秀的开源项目在Github上，不得以才出此下策。     
windows下修改`C:\WINDOWS\system32\drivers\etc`，Archlinux下修改`/etc/hosts` ,在其中添加：    
```   
207.97.227.239 github.com 
65.74.177.129 www.github.com 
207.97.227.252 nodeload.github.com 
207.97.227.243 raw.github.com 
204.232.175.78 documentcloud.github.com 
204.232.175.78 pages.github.com
```   
希望此次事件能够尽快过去。   
小贴士：   
Github---全球最大的社交编程及代码托管网站。    
