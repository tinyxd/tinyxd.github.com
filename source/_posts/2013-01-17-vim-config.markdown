---
layout: post
title: "vim的一些配置"
date: 2013-01-17 17:44
comments: true
categories: linux
tags: [vim,linux]
keywords: vim  |  vi  |  配置  | vimwiki
description: vim的一些配置方法
---
一直很想系统的学习vim，因为各种原因把，一直把这个计划搁置到了现在，现在凑着学习vimwiki，再次把这个提上日程。   
vim配置：   
使用了[vingel](https://github.com/vingel/vim/blob/master/vimrc)的配置文件。   
由于我还要学习vimwiki，所以添加了vimwiki的一些配置。
```    
"""""""""""""""""""""""""""""""""""""""
"vimwiki设置
"""""""""""""""""""""""""""""""""""""""
" 打开语法高亮
"syntax enable
syntax on

" 打开对文件类型插件的支持
filetype indent on
filetype plugin on
"filetype plugin indent on

" ######### VimWiki 写作助手 ######### "

" 使用鼠标映射
let g:vimwiki_use_mouse = 1

" 不要将驼峰式词组作为 Wiki 词条
let g:vimwiki_camel_case = 0

let g:vimwiki_list = [{
\ 'path': '/media/software/Dropbox/my_vimwiki_site/wiki',
\ 'path_html': '/media/software/Dropbox/my_vimwiki_site/html/',
 \'template_path' : 'd:/vimwiki/template/',
            \'template_default' : 'default_template',
            \'template_ext' : '.html',
\ 'auto_export': 1,}] 

 
```



