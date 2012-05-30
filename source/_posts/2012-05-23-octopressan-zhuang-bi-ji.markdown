---
layout: post
title: "Octopress安装笔记"
date: 2012-05-23 07:16
comments: true
categories: octopress
---
在阅读此教程之前，先安装git和ruby环境。

**1.安装ruby环境**

如果已经安装了ruby,就不用安装rvm 了。
Archlinux用户建议用pacman 安装ruby,方便省事。

Archlinux安装RVM教程：
[archlinux安装RVM教程](https://wiki.archlinux.org/index.php/RVM)

	[tinyxd@archbang  ~]$ sudo bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )

添加当前用户到rvm 组
	[tinyxd@archbang  ~]$ sudo usermod -a -G rvm admin

查看下添加成功了没：
	[tinyxd@archbang ~]$ grep rvm /etc/group
	rvm:x:1004:admin

再注销，登录。
> To start using RVM you need to run `source /etc/profile.d/rvm.sh` in all your open shell windows, in rare cases you need to reopen all shell windows.

已经安装了ruby的就可以从这里开始了。
<!--more-->
**2.安装依赖**

	[tinyxd@archbang ～]$ gem install bundler
	WARNING:  You don't have /home/tinyxd/.gem/ruby/1.9.1/bin in your PATH,
	      gem executables will not run.
	vim ~/.bashrc
	#for ruby gem
	PATH=$PATH:~/.gem/ruby/1.9.1/bin
	export PATH
注意路径后面不能带/，不然它还是会报错。
	[tinyxd@archbang ~]$ sudo gem install bundler
	[tinyxd@archbang ~]$ cd ovtopress/
	[tinyxd@archbang ~]$ bundle install
	[tinyxd@archbang ~]$ rake install 
	rake aborted!
	You have already activated rake 0.9.2.2, but your Gemfile requires rake 0.9.2. Using bundle exec may solve this.
	
	(See full trace by running task with --trace)
出现上述问题，按以下方法解决：
	bundle update
	rake install
	[tinyxd@archbang octopress]$ rake install
	## Copying classic theme into ./source and ./sass
	mkdir -p source
	cp -r .themes/classic/source/. source
	mkdir -p sass
	cp -r .themes/classic/sass/. sass
	mkdir -p source/_posts
	mkdir -p public

**3.Deploying to Github Pages**

http://octopress.org/docs/deploying/github/

首次deploy 之前的准备活动
创建 username.github.com 仓库
执行rake setup_github_pages来设置。

	[tinyxd@archbang octopress]$ rake setup_github_pages
	Enter the read/write url for your repository: git@github.com:akm/akm.github.com.git
	Added remote git@github.com:akm/akm.github.com.git as origin
	Set origin as default remote
	Master branch renamed to 'source' for committing your blog source files
	rm -rf _deploy
	mkdir _deploy
	cd _deploy
	Initialized empty Git repository in /home/admin/public_html/octopress/_deploy/.git/
	[master (root-commit) ff105cf] Octopress init
	 1 file changed, 1 insertion(+)
	 create mode 100644 index.html
	cd -
	
	---
	## Now you can deploy to http://ihacklog.github.com with `rake deploy` ##
>This will:Ask you for your Github Pages repository url.Rename the remote pointing to imathis/octopress from ‘origin’ to ‘octopress’.Add your Github Pages repository as the default origin remote.Switch the active branch from master to source.Configure your blog’s url according to your repository.Setup a master branch in the _deploy directory for deployment.

生成静态页面：
	[tinyxd@archbang octopress]$ rake generate
把源码push搭配github上
	git add .
	git commit -m "commit the source for my Octopress blog"
	git push origin source

Configuring Octopress配置略，见 http://octopress.org/docs/configuring/

写日志	
	rake new_post["文章标题"] #新建页面
	rake new_page[super-awesome]

详见 http://octopress.org/docs/blogging/
写完了之后

	rake generate
	rake deploy

如果想本地预览一下效果，可以用

	rake preview

要注意的是，如果修改源码和配置，是在source 分支修改和提交。
而发布日志，也是在source分支，rake deploy会自动将生成的静态页面push到master分支。因此，master分支的内容不用你管。


>插一句：如果以后要从另一个电脑pull源码来新电脑，用如下命令：
	cd your_local_octopress_directory
	cd _deploy
	git pull origin master
	cd ..
	git pull origin source
>只要记住“your_local_octopress_directory”对应的的remote source branch，而”_deploy”对应的是remote master branch即可。

>    如果你是和别人合作博客，或者自己同时在好几个电脑上写博客，每次开始之前，git pull origin source获得最新的文件,rake generate生成新的页面

    我们在source分支做了博客的发布，或者改变了博客的设置之后，rake generate生成网站

    rake watch+pow 或者rake review+http://localhost:4000就可以看到我们所做的变化

    确认无误后，rake deploy文章就发布到了博客中

    当然，不要忘了更新项目 git push origin source

    特别的，如果你克隆了博客，记得在git checkout source，然后rake setup_github_pages执行初始化，当然，在那之前也需要bundle install，然后rake generate就生成页面了.

    如果是新建的Repo ，记得
	$ mkdir yourrepo
	$ cd yourrepo
	$ git init
	# 其实这这时如果你多新建一个index.html文件的话，github会为你生成一个jekyll博客。
	$ touch README
	$ git add .
	$ git commit -m 'first commit'
	$ git remote add origin git@github.com:username/yourname.github.com.git
	$ git push origin master
>对于新手有几个提醒:

    时常git status,git log避免误操作
    不要在github上直接编辑文件
    想清楚了再下手
 >   github pages的 username 大小写敏感。如果用户名和username不一致的话,默认会生成这个Repo的project pages。


rake watch 检测文件变化，实时生成新内容
rake preview 监听本机4000端口，可查看生成页面效果。


个性化
文档： http://octopress.org/docs/theme/template/
修改定制文件/source/_includes/custom/head.html 把google的自定义字体去掉或自行定义，如我的（自己下载了google font)：
1
2
	
<link href="/assets/font/PT_Serif.css" rel="stylesheet" type="text/css">
<link href="/assets/font/PT_Sans.css" rel="stylesheet" type="text/css">

我把下载的google font放在 source/assets/font 目录下面。

图片发布
我把图片放在source/static 目录。
在文章中引用（注意URL前面的/)：

	![ Ultrablog.vim post title bug ](/static/2012/04/UltraBlog-post-title-bug.png)

个性域名
先去给域名建立一个CNAME记录，指向 username.github.com ,如 ihacklog.github.com
在source目录下建一个名为CNAME的文件，然后将自己的域名输入进去
如：
	
tinyxd.tk

文档： http://help.github.com/pages/
   
其它，如sidebar的修改等，可参考文档。http://octopress.org/docs/theme/template/
我这就不写了。   
主题的修改参考了这篇文章[Octopress Theme Customization](http://melandri.net/2012/02/14/octopress-theme-customization/)，以后自己研究下css，做个自己的。
   
其它可参考的文章： http://blog.devtang.com/blog/2012/02/10/setup-blog-based-on-github/   


**一些技术：**  
https://github.com/mojombo/jekyll 静态页面发布技术，使用 Textile or Markdown and Liquid converters，是Github页面引擎背后的技术。  
http://daringfireball.net/projects/markdown/ 简单的标记语言，现在很多编辑器支持，快速编写并可编译成HTML、LaTeX等格式。  
http://gembundler.com/ 将一个应用需要的Ruby软件包写入一个Gemfile文件，当应用安装时可以用Bundle命令自动从服务器上下载需要的软件包。  
http://rack.rubyforge.org/ 基于Ruby的web服务器界面。  
http://pow.cx/ 配置好的Rack服务，即开即用。  
http://rake.rubyforge.org/ 用Ruby写成的Make，批处理操作。  
http://sass-lang.com/ CSS3扩展，方便编写CSS并提供更多功能。  
http://ethanschoonover.com/solarized 一套便于阅读的代码配色方案。  
https://github.com/ 代码平台，基于git。  
http://www.heroku.com/ 云计算平台，发布非常方便。  
