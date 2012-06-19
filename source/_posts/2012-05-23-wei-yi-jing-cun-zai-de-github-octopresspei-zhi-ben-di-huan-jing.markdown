---
layout: post
title: "为已经存在的github Octopress配置本地环境"
date: 2012-05-23 20:59
comments: true
categories: octopress
keywords: octopress, github
description: 为已经存在的github Octopress配置本地环境。
---


**转自：**  
http://www.360doc.com/content/12/0520/19/3565338_212362686.shtml  

本文介绍如何为已经存在于github上的octopress配置本地环境。  
在本地安装RVM(Ruby Version Manager)和Ruby 1.9.2；  

从你的github得到你的octopress内容：  	

	git clone -b source git@github.com:username/username.github.com.git octopress # get the source code from your "source" branch of your octopress on github
	＃ learn from: http://stackoverflow.com/questions/1911109/git-clone-a-specific-branch
	cd octopress
	git clone git@github.com:username/username.github.com.git _deploy # get your static pages content from your "master"branch of your cotopress on github

<!--more-->
安装依赖gems: 
	
	gem install bundler # Install dependencies   
	bundle install   #如果出现bundle命令没找到，还需要修改～/.bashrc
	vim ~/.bashrc
	#for ruby gem
	PATH=$PATH:~/.gem/ruby/1.9.1/bin
	export PATH
	rake install # Install the default Octopress theme  不需要 因为我已经有了自己的主题   
	rake setup_github_pages #需要这个 要不然rake deploy会出错   
    
这就基本结束了。



编写文章，预览部署：  

	cd octopress
	rake new_post["Your Title of Your Article"]
	rake generate # generate your blog static pages content according to your input. 
	rake preview # start a web server on "http://localhost:4000", you can preview your blog content.
	rake deploy # push your static pages content to your github pages repo ("master" branch)

提交你的文本修改到github:   	

	cd your_local_octopress_directory
	git add .
	git commit -m 'your message'
	git push origin source

注意：如果要从github得到最新的source内容，请运行以下命令：   

	cd your_local_octopress_directory
	cd _deploy
	git pull origin master
	cd ..
	git pull origin source

原则很简单，只要记住“your_local_octopress_directory”对应的的remote source branch，而”_deploy”对应的是remote master branch即可。
