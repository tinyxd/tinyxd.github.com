---
layout: post
title: "octopress博客添加flickr侧边栏"
date: 2012-07-02 11:14
comments: true
categories: octopress
tags: [octopress , flickr]
keywords: octopress , flickr 
description: add flickr aside in octopress(octopress博客添加flickr侧边栏)
---
octopress添加侧边栏：   
1.新建 `source/_includes/custom/asides/flickr.html`，代码如下：
{% gist 1421792  flickr.html %}  
<!--more--> 
2.在_config.yml添加   
```
# Flick Badges
# Find your user id here: http://idgettr.com/ It should be something like "81221217@N08".
flickr_user: 81221217@N08
flickr_count: 6
```   
记住要把 flickr_user 换成你自己的 id。   
ID在这个[网址](http://idgettr.com/)获取，只需把username换成自己的，然后点find。   
3.在`_config_yml`中`default_asides`添加`custom/asides/flickr.html`。   
4.大功告成。
本文参考了：[Lucifr](http://lucifr.com/2011/12/02/add-flickr-aside-to-octopress/)和[melandri](http://melandri.net/2012/01/10/octopress-flickr-aside/)。


