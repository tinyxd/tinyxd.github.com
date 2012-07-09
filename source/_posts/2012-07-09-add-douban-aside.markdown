---
layout: post
title: "给octopress博客添加豆瓣侧边栏"
date: 2012-07-09 22:38
comments: true
categories: octopress
tags: octopress
keywords: octopress|豆瓣|侧边栏
description: 给octopress博客添加豆瓣侧边栏，利用豆瓣开放API。
---
1.添加`source/_includes/custom/asides/douban.html`   
{% gist 3076932 douban.html %}  
其中`<div> </div>`中间的代码从[这里](http://www.douban.com/service/badgemakerjs)获取，记得改成自己的哦！   
2.在`_config.yml`中添加：       
douban_user: XXX  
(XXX为你的豆瓣用户名)   
3.记得把这里（default_asides: ）加上douban.html的位置
然后，`rake generate` 和`rake preview`看看效果吧    
类似微薄侧边浪也是这么弄的。   
<br />
本站文章如果没有特别说明，均为**原创**，转载请以**链接**方式注明本文地址：<http://tinyxd.me/blog/2012/07/09/add-douban-aside/>
