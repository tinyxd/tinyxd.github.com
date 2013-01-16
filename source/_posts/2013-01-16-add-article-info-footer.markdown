---
layout: post
title: "文章末尾自动添加本文地址"
date: 2013-01-16 13:23
comments: true
categories: octopress
tags: octopress
keywords: octopress | 本文地址
description: 文章末尾自动添加本文地址
---
为每篇post添加本文地址和keywords信息。   
Ruby脚本如下，添加到plugins文件夹中。    
{% gist 4545472 post_footer_filter.rb%}   
本人已将插件上传到https://github.com/tinyxd/post_footer。   
<!--more-->
在_config.yml中添加origional_url_pre，本文配置为"本站文章如果没有特别说明，均为原创，转载请以链接方式注明本文地址："。   


本文参考：`http://codemacro.com/2012/07/26/post-footer-plugin-for-octopress/`。 
