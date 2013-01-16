---
layout: post
title: "文章末尾自动添加本文地址"
date: 2013-01-16 13:23
comments: true
categories: octopress
tags: octopress
keywords: octopress|本文地址
description: 文章末尾自动添加本文地址
---
为每篇post添加本文地址和keywords信息。   
Ruby脚本如下，添加到plugins文件夹中。    
``` ruby post_footer_filter.rb
#
# post_footer_filter.rb
# Append every post some footer infomation like original url
# Written by Kevin Lynx .
# Modified by Tiny (http://tinyxd.me/) .
# Email: admin#tinyxd.me
# Date: 1.16.2013
#
require './plugins/post_filters'

module AppendFooterFilter
  def append(post)
     author = post.site.config['author']
     url = post.site.config['url']
     pre = post.site.config['original_url_pre']
     post.content + %Q[<p class='post-footer'>
#{pre or "original link:"}
<a href='#{post.full_url}'>#{post.full_url}</a><br/>
&nbsp;Written by <a href='#{url}'>#{author}</a>
&nbsp;Posted at <a href='#{url}'>#{url}</a><br/>
&nbsp;Keywords : {{ page.keywords }}
</p>]
  end
end

module Jekyll
  class AppendFooter < PostFilter
    include AppendFooterFilter
    def pre_render(post)
      post.content = append(post) if post.is_post?
    end
  end
end

Liquid::Template.register_filter AppendFooterFilter
```   
本人已将插件上传到https://github.com/tinyxd/post_footer。   
<!--more-->
在_config.yml中添加origional_url_pre，本文配置为"本站文章如果没有特别说明，均为原创，转载请以链接方式注明本文地址："。   


本文参考：`http://codemacro.com/2012/07/26/post-footer-plugin-for-octopress/`。 
