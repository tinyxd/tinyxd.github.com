---
layout: post
title: "arch linux 下lxr的安装"
date: 2012-05-26 23:14
comments: true
categories: linux
---

经过自己两天的折腾，参考了好几个资料终于搞定。
参考资料见文章末尾。
LXR是使用WEB方式下的源代码整理浏览工具，最大的用途在于清理出了代码中函数、变量的定义、说明、应用的关系，并用链接的形式表现在网页上。LXR整理出代码的结构和调用关系，存在数据库中，并在显示时与源代码树结合，从功能上说，包括代码浏览、标识符搜索、文本搜索和文件搜索，其中的文本搜索和文件搜索利用的是第三方工具（即glimpse或swish-e）（我使用的glimpse）。它的主要组成部分包括三个：Perl编写的网页/CGI部分，基于MySQL的索引数据管理（新版本才有）和通用的文本搜索工具。目前的版本，采用Glimpse或者Swish-e中的一种作为通用文本搜索工具。在安装上，基本上也按照这三个部分来配置。    

1.下载安装所需的工具。   
a。glimpse（http://webglimpse.net/download.php）

安装glimpse:（其中会用到flex 安装下就行了）

	$ ./configure
	
	$ make
	
	$ sudo make install

b。pacman -S apache php php-apache mysql

c。pacman -s ctags perl-dbi perl-dbd-mysql

d。安装完mysql 以root用户身份运行设置脚本

	# rc.d start mysqld && mysql_secure_installation

然后重启 Mysql

	# rc.d restart mysqld

本文需要设置密码为空（后面有说明）
<!--more-->
用mysql -p -u root

登陆mysql,然后执行下面语句: set password for 'root'@'localhost' =password('');flush privileges;e.安装Perl的Magic模块

下载地址http://search.cpan.org/~knok/File-MMagic-1.27/MMagic.pm

	[root@localhost File-MMagic-1.27]# ls ChangeLog COPYING      MANIFEST MMagic.pm README.ja contrib    Makefile.PL META.yml README.en t [root@localhost File-MMagic-1.27]# perl Makefile.PL Checking if your kit is complete... Looks good Writing Makefile for File::MMagic [root@localhost File-MMagic-1.27]# ls
	ChangeLog COPYING   Makefile.PL META.yml   README.en t
	contrib    Makefile MANIFEST     MMagic.pm README.ja
	
	[root@localhost File-MMagic-1.27]# make
	cp MMagic.pm blib/lib/File/MMagic.pm
	Manifying blib/man3/File::MMagic.3pm
	[root@localhost File-MMagic-1.27]# make install
	Installing /usr/lib/perl5/site_perl/5.8.8/File/MMagic.pm
	Installing /usr/share/man/man3/File::MMagic.3pm Writing /usr/lib/perl5/site_perl/5.8.8/i386-linux-thread-multi/auto/File/MMagic/.packlist Appending installation info to /usr/lib/perl5/5.8.8/i386-linux-thread-multi/perllocal.pod
2.设置

尽管lxr源码里有一个INSTALL文件，但不详，这里写下来我自己配置的步骤。 
1）位置规划 
LXR除了数据库那一部分不需要考虑存放位置以外，还有CGI/HTML部分、索引生成工具部分和

所需要索引的源代码部分需要考虑，我的实践中使用的与INSTALL缺省的不同，最大的一点不同在于我

将WEB部分和工具部分分离开，只允许WEB部分暴露给浏览器——主要是基于也许会更安全一些的考虑。 
另一个不同是用符号链接而不是真正的源代码目录作为源代码部分，因为LXR索引的Linux Kernel是最常用的，

而Kernel本身还被用来重编内核和升级，所以不适合完全拷贝过来。 
本例中使用的是/usr/local/lxr目录作为LXR的根目录。 
	#tar zxvf lxr-0.9.1.tar.gz -C /usr/local ；将lxr解压到/usr/local/lxr下 
	#cd /usr/local/
	
	#mv Local.pm diff ident search source templates  #将web相关部分移到templates下  
	
	#mv templates http                            #http目录，用于存放WEB部分  
	
	#ln -s /usr/local/lxr/http/Local.pm /usr/lib/perl5/site_perl/ 
	
	#ln -s http/lxr.conf         #为web部分和工具部分都需要用的文件建符号连接 
	#mv lib /usr/lib/perl5/site_perl/LXR  #将自定义的perl库文件拷贝
	
到perl/mod_perl使用的缺省库文件目录中 

	#ln -s /usr/lib/perl5 /usr/local/lib  #否则在运行时会出现Can't locate LXR/Files.pm等错误 
	
建立源代码根目录,（当前在lxr目录）
	
	#mkdir src ；源代码部分的根 
	
	并将 linux-2.6.39的源码链接到此目录下。
	
	#cd src 
	
	mkdir glimpse 
	
	ln -s ../../../../src/linux-2.6.39 2.6.39
	
	#vi versions ；编辑/usr/local/lxr/src/versions文件，内容为2.6.39，表示让lxr索引2.6.39
	
	#cd ../../ ；回到/usr/local/lxr 
	
2）修改lxr.conf 
准备好了目录结构，下一步就是改写lxr.conf文件。缺省的lxr.conf已经从templates拷贝到/usr/local/lxr/http/下了，

并在/usr/local/lxr/下有个连接。 注释掉所有与swish-e相关的变量定义,其余设置如下
	
	'glimpsebin' => '/usr/local/bin/glimpse', 
	
	'glimpseindex' => '/usr/local/bin/glimpseindex', 
	
	'ectagsbin' => '/usr/bin/ctags', 
	
	'genericconf' => '/usr/lib/perl5/site_perl/LXR/Lang/generic.conf' 
	
	'ectagsconf' => '/usr/lib/perl5/site_perl/LXR/Lang/ectags.conf' 
	
	'baseurl' => 'http://192.168.1.102/lxr'                 #主机的IP地址 
	
	'range' => [ readfile('/usr/local/lxr/src/versions') ]  
	
	'default' => '2.6.39'                                  #缺省的代码树名 
	
	# Templates used for headers and footers 下所有路径均设置为绝对路径,如 
	
	'htmlhead' => '/usr/local/lxr/http/html-head.html' 
	
	 
	
	'sourceroot' => '/usr/local/lxr/src'       #源码根目录    (注意，最后无/) 
	
	'sourcerootname' => 'Linux-$v'        #它将显示在缺省的最高级源码目录上 
	
	'glimpsedir' => '/usr/local/lxr/src/glimpse'         #(注意，最后无/) 
	
3）apache的httpd.conf (/etc/httpd/conf/httpd.conf)
保证装了mod_perl的时候，在httpd.conf中添加以下几行： 

	Alias /lxr/ /usr/local/lxr/http/ 
	
	<Directory /usr/local/lxr/http/>
	
	AllowOverride None
	
	Options FollowSymLinks
	
	<Files ~  "(search|source|ident|diff|find)$">
	
	SetHandler perl-script
	
	PerlHandler ModPerl::Registry       #注意这里不是Apache::Registry
	
	Options +ExecCGI
	
	PerlOptions +ParseHeaders
	
	</Files>
	
	</Directory> 
表示访问/lxr就相当于访问/usr/local/lxr/http，且用perl解释search、source、ident、diff和find几个脚本，

而其他的仍然当成html来使用。 
如果没有mod_perl，可以用SetHandler cgi-script代替perl-script，一样可以用，PerlHandler就不用了。 
4.initialize 
1）初始化MySQL数据库 (mysql) :

进入lxr目录/usr/local/lxr

\# mysql   

(反斜杠). initdb-mysql

2).建glimpse索引    
在/usr/local/lxr/src/2.6.39/下运行'find . -name "*.[chS]" -follow | glimpseindex -H . -o -F'，索引所有.c、.h、.S（汇编）文件。这个过程比较耗时，但比起下一个过程来，就小巫见大巫了。 
3.)建identity索引 这是LXR精髓所在
在/usr/local/lxr/下运行'./genxref --version=2.6.39--url=http://192.168.1.102/lxr'，这个过程时间比较长，其结果就是在MySQL中添东西。如果已经做过索引了，它就只关心那些修改过的或新的文件，速度就快多了。这个过程如果中断了，最好清空数据库重新来过，否则可能会有错误。    
4).修改权限    
最简单的办法就是把/usr/local/lxr/http下所有的文件都改成apache的属主。在/usr/local/lxr/下运行'chown -R apache.apache http '。     
5.startup   (rc.d restart httpd;rc.d restart mysqld)   
重启mysql和httpd，然后访问http://192.168.1.102/lxr/source/就可以了。比较奇怪的是，因为这个cgi允许用类似目录一样的形式（source/）来访问，所以，如果服务器端有更新，浏览器端仍会使用老的页面，refresh也没用。这时只有清空本地cache了。   
 6.参考博客   

[内核分析]LXR安装心得(0.9.3版)---RH8.0测试通过http://www.cnblogs.com/huqingyu/archive/2005/02/19/106080.html

利用LXR建立源代码交叉索引 【原】http://hi.baidu.com/kissdev/blog/item/6e493daf15cf33c77cd92af9.html

LXR安装过程简介(0.3版) http://blog.chinaunix.net/u1/46901/showart_397299.html

高亮LXR的代码 http://mjxian.cn/wordpress/archives/lxr-syntax-highlighting.html

mysql wiki：https://wiki.archlinux.org/index.php/MySQL_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87

附：部分软件版本

File-MMagic-1.27.tar.gz

perl-dbi-1.616-2-i686.pkg.tar.xz

perl-dbd-mysql-4.020-1-i686.pkg.tar.xz

lxr-0.9.10.tgz

glimpse-4.18.6