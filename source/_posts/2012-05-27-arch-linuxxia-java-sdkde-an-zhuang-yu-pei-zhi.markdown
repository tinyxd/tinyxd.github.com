---
layout: post
title: "arch linux下java SDK的安装与配置"
date: 2012-05-27 19:58
comments: true
categories:  java
---

为了节省以后查资料的时间，故而转到自己的blog做个备份。
转自：
[Arch Linux中Java SDK的安装与配置](http://www.cnblogs.com/heart-runner/archive/2011/11/30/2269640.html)

因为版权和公司对开源软件的态度，Oracle Java SDK已经不再包含于Arch Linux默认的Repository。
 
不过对于有开发需要，又不得不使用Oracle公司的产品的民工们，还好有AUR中提供的相应支持，让我们能方便地用安装脚本来处理Oracle Java SDK的安装和配置。
 
下面就简单地记录下的JDK的安装方法。
 
安装环境如下：

	archbang 3.3.6-1-ARCH
	Oracle Java SDK 7 update 1

**安装**
---
*   jre   
这里先安装JDK，虽然据说openjdk的jre也能兼容Oracle Java SDK，但还是有点担心它们的兼容性。    
先在[Arch Linux AUR](https://aur.archlinux.org/)中找到[JRE](https://aur.archlinux.org/packages.php?ID=51908)。  
 <!--more-->
制作安装包   
```	
	$ wget --no-check-certificate -c https://aur.archlinux.org/packages/jr/jre/jre.tar.gz   
	$ tar -zxvf jre.tar.gz   
	$ cd  jre   
	$ makepkg    
   
```
处理依赖条件，开始安装    


	$ sudo pacman -S desktop-file-utils libxtst shared-mime-info xdg-utils
	[zzz@archbang jre]$ sudo pacman -U ./jre-7.4-1-i686.pkg.tar.xz 
	loading packages...
	resolving dependencies...
	looking for inter-conflicts...
	
	Targets (1): jre-7.4-1
	
	Total Installed Size:   92.30 MiB
	
	Proceed with installation? [Y/n] 
	(1/1) checking package integrity                   [----------------------] 100%
	(1/1) loading package files                        [----------------------] 100%
	(1/1) checking for file conflicts                  [----------------------] 100%
	(1/1) checking available disk space                [----------------------] 100%
	(1/1) installing jre                               [----------------------] 100%
	
	The jre package is licensed software.
	You MUST read and agree to the license stored in
	/usr/share/licenses/jre/LICENSE before using it.
	Please relogin to include jre in your PATH.
	
	Optional dependencies for jre
	    alsa-lib: sound support
	    ttf-dejavu: fonts
	
	
Arch Linux中，Java SDK默认的安装位置是/opt/java

	$ pwd 
	/opt/java
	$ ls
	jre
至此，JRE成功安装。
---
*   JDK
JDK的安装过程与JRE类似。   

	\$ wget -c --no-check-certificate https://aur.archlinux.org/packages/jd/jdk/jdk.tar.gz   
	\$ tar -zxvf jdk.tar.gz   
	\$ cd jdk   
	\$ makepkg   
	\$ sudo pacman -U ./jdk-7.4-1-i686.pkg.tar.xz   
	loading packages...   
	resolving dependencies...   
	looking for inter-conflicts...   
	
	Targets (1): jdk-7.4-1   
	
	Total Installed Size:   86.05 MiB   
	
	Proceed with installation? [Y/n]    
	(1/1) checking package integrity                   [----------------------] 100%   
	(1/1) loading package files                        [----------------------] 100%   
	(1/1) checking for file conflicts                  [----------------------] 100%   
	(1/1) checking available disk space                [----------------------] 100%   
	(1/1) installing jdk                               [----------------------] 100%   
	   
	The jdk package is licensed software.   
	You MUST read and agree to the license stored in   
	/usr/share/licenses/jdk/LICENSE before using it.   
	Please relogin to include jdk in your PATH.   
   
配置
安装之后打开/etc/environment文件编辑，添加如下内容：

	#Java SDK 
	#
	CLASSPATH=.:/opt/java/lib
	JAVA_HOME=/opt/java

添加之后就可以使用java和javac命令了

	$ java -version
	java version "1.7.0_01"
	Java(TM) SE Runtime Environment (build 1.7.0_01-b08)
	Java HotSpot(TM) Client VM (build 21.1-b02, mixed mode)
	$ javac -version
	javac 1.7.0_01   
更详细的内容可参考[傻东の学习笔记](http://sillydong.com/myjava/arch-linux%E5%BF%AB%E9%80%9F%E9%85%8D%E7%BD%AEjava%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83.html)
3、解决中文乱码问题，还是用超级用户，进入/usr/share/fonts/wenquanyi，将wqy-zenhei文件夹复制到/opt/java/jre/lib/fonts下，改名为fallback，进入fallback文件夹，终端执行
   
	# mkfontdir
	和
	# mkfontscale

4、安装eclipse，只需要打开终端执行pacman -S eclipse就可以安装eclipse最新的英文版   

5、执行jar文件的办法。在Arch中，jar文件默认是使用归档文件管理器打开的，也就相当于解压缩，而我们需要的是执行这个jar程序，跟我做：在目标jar文件上右击，选择“属性”，找到“打开方式”的标签，选择“添加”，打开“使用自定义命令”，向其中加入下面的命令：   
	java -jar

输完之后选择“添加”，这时候在打开方式标签下有两个选择，一种就是原来就有的“归档文件管理器”，还有就是“java”，勾选上“java”，然后关闭，这时候双击jar文件就是执行它了。