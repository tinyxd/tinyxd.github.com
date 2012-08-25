---
layout: post
title: "图床管理"
date: 2012-08-26 00:08
comments: true
categories: vps
tags: [vps,explorer]
keywords: 图床管理,Encode Explorer,vps
description: 做网站，尤其是做多个网站的，文件的统一管理，备份是很重要的。本文介绍Encode Explorer如何作为本站的文件管理程序的。
---
做网站，尤其是做多个网站的，文件的统一管理，备份是很重要的。本站用[Encode Explorer](http://encode-explorer.siineiolekala.net/)来管理本站图片、上传附件等。   
去Encode Explorer在sourceforge的[项目官网](http://sourceforge.net/projects/encode-explorer/files/encode-explorer/)下载程序，其代码不过3k多行。只要将index.php上传到网站根目录，然后把nginx设置好用[2级域名](http://upload.tinyxd.me/)指向此根目录，就可以了。      
其中index.php需要改几个地方：     
1.`$_CONFIG['lang'] = "zh_CN";` 支持中文    
2.`$_CONFIG['users'] = array(array('username', 'password', 'admin'));`  建立admin用户     
其中index.php介绍比较详细了。语法格式：array(username, password, status)    status为user可以查看目录但不可以修改，admin能够上传文件和删除文件。     
3.`$_CONFIG['new_dir_mode'] = 0755;`       
`$_CONFIG['upload_file_mode'] = 0644;`   
修改新建文件夹和上传文件的默认权限。      
这就是最终完成的，用二级域名（只要将该域名dns解析到vps服务器地址就可以了）<http://upload.tinyxd.me/>来上传/浏览/删除文件。    
本文参考了[log4d](http://log4d.com/)的[使用独立图床子域名](http://log4d.com/2012/05/image-host/)。    
<br />
本文地址：<http://tinyxd.me/2012/08/26/imag-file-explorer/>