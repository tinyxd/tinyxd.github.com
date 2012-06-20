---
layout: post
title: "给octopress添加关键字和网站描述"
date: 2012-06-19 21:10
comments: true
categories: octopress
keywords: octopress, meta,seo
description: How to optimize Octopress for SEO
---

给octopress添加keywords和description。   

1.修改source / _includes / head.html
```
<meta name="author" content="{{ site.author }}">
{% capture description %}{% if page.description %}{{ page.description }}{% elsif site.description %}{{ site.description }}{%else%}{{ content | raw_content }}{% endif %}{% endcapture %}
<meta name="description" content="{{ description | strip_html | condense_spaces | truncate:150 }}">
{% if page.keywords %}<meta name="keywords" content="{{ page.keywords }}">{%else%}<meta name="keywords" content="{{ site.keywords }}">{% endif %}
```
2.在_config.yml中添加如下内容
```
description: Keen on the software programming and Embedded development.（专注软件编程及嵌入式技术。）
keywords: ruby , linux , archlinux , debian , software ,programming , embedded ,gem,web development ,ubuntu , java
```
3.这样在主页代码中也会出现keywords和description信息。每个post也会出现。方便被搜索网站索引。这个涉及到了SEO优化。

