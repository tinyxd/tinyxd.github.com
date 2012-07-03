---
layout: post
title: "vc debug 变 release"
date: 2012-07-03 12:23
comments: true
categories: software
tags: [c++,software,vc]
keywords: c++,software,vc
description: vc debug 变 release
---
今天遇到将debug改为release版本出现好多问题，最后一一解决，现将方法贴到下面   
生成release版的步骤：   
1.首先修改`project-setting-general-using mfc in a static libraryproject-setting `右键点击菜单空白处——选择“组建”——选择“Win32 Release“——重新编译链接。   
2.然后`project-setting -c++ -precompiled Headers- not using `   
最后出现这个错误   
	nafxcwd.lib(afxmem.obj) : error LNK2005: "void __cdecl operator delete(void *)" (??3@YAXPAX@Z) already defined in LIBCMTD.lib(dbgdel.obj)   
关于静态库引发 nafxcw.lib LNK2005 错误的解决方法   
<!--more-->
解决方法，进入vc6 选择菜单：    
	project -> settings -> link -> Category : input   -> Object/library modeules ,
输入：nafxcw.lib 即可。   
原因：必须先编译这个库，才能避免函数名字重复引用。   
<br />
Note：记住rebuiled   
<br />
附：debug版本和release版本的区别：   
Debug 通常称为调试版本，它包含调试信息，并且不作任何优化，便于程序员调试程序。Release 称为发布版本，它往往是进行了各种优化，使得程序在代码大小和运行速度上都是最优的，以便用户很好地使用。Debug 和 Release 的真正秘密，在于一组编译选项。下面列出了分别针对二者的选项    
<br />
Debug 版本：
{% blockquote %}
/MDd /MLd 或 /MTd 使用 Debug runtime library(调试版本的运行时刻函数库)
/Od 关闭优化开关
/D "_DEBUG" 相当于 #define _DEBUG,打开编译调试代码开关(主要针对assert函数)
/ZI 创建 Edit and continue(编辑继续)数据库，这样在调试过程中如果修改了源代码不需重新编译
/GZ 可以帮助捕获内存错误
/Gm 打开最小化重链接开关，减少链接时间
 {% endblockquote %}
<br />
Release 版本：   
{% blockquote %}
/MD /ML 或 /MT 使用发布版本的运行时刻函数库
/O1 或 /O2 优化开关，使程序最小或最快
/D "NDEBUG" 关闭条件编译调试代码开关(即不编译assert函数)
/GF 合并重复的字符串，并将字符串常量放到只读内存，防止 被修改
{% endblockquote %}   
<br />
 实际上，Debug 和 Release 并没有本质的界限，他们只是一组编译选项的集合，编译器只是按照预定的选项行动。事实上，我们甚至可以修改这些选项，从而得到优化过的调试版本或是带跟踪语句的发布版本。