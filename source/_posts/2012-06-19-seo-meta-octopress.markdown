---
layout: post
title: "给octopress添加关键字和网站描述"
date: 2012-06-19 21:10
comments: true
categories: octopress
tags: [octopress, meta,seo]
keywords: octopress, meta,seo
description: How to optimize Octopress for SEO
---

给octopress添加keywords和description。   

1.修改source/_includes/head.html   
{% gist 2460469  head.html %}   
2.在_config.yml中添加如下内容
```
description: Keen on the software programming and Embedded development.（专注软件编程及嵌入式技术。）
keywords: ruby , linux , archlinux , debian , software ,programming , embedded ,gem,web development ,ubuntu , java
```
3.这样在主页代码中也会出现keywords和description信息。每个post也会出现。方便被搜索网站索引。这个涉及到了SEO。
以上文章参考自[这里](http://www.yatishmehta.in/seo-for-octopress)。

