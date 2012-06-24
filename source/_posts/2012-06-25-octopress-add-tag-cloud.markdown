---
layout: post
title: "octopress博客添加标签云"
date: 2012-06-25 00:35
comments: true
categories: octopress
tags: [octopress , tag cloud  ]
keywords: octopress , tag cloud
description: 给octopress添加标签云
---

折腾了好久，终于弄好了。我基本是follow这篇文章的：[给 Octopress 加上标签功能](http://log4d.com/2012/05/tag-cloud/)   
官方只提供了category的云显示，和列表显示，这是其[github地址](https://github.com/tokkonopapa/octopress-tagcloud)，其实官方提供的这个第三方插件并没有给文章加入tag的概念。（category和tag分别代表日志分类和标签）  
<!--more--> 
现在我还对ruby不是很熟悉，但是看到了[这篇文章](http://log4d.com/2012/05/tag-cloud/)，找到了[robbyedwards / octopress-tag-pages](https://github.com/robbyedwards/octopress-tag-pages)和[robbyedwards / octopress-tag-cloud](https://github.com/robbyedwards/octopress-tag-cloud)。前者采集文章的tag，后者是标签云的显示。   
这两个使用方法相同，把文件放到相应的目录即可。而第二个插件`octopress-tag-cloud` 会和官方的有冲突，直接用[这个](https://github.com/alswl/octopress-category-list)就好。   
还有最后一点非常重要，得修改两个地方：   
一个是sass/custom/_styles.scss
``` 
#content article .cloud li{
  display: inline;
  list-style: none outside none;
  padding: 0 4px;
}

```
   
然后把显示tagcloud的页面 class改为cloud(class="cloud")。   
大功告成，tag cloud页面请点击[这里](http://tinyxd.me/tags/index.html)。
   