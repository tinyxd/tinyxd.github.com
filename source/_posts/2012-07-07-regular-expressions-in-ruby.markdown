---
layout: post
title: "正则表达式"
date: 2012-07-07 23:40
comments: true
categories: ruby
tags: ruby
keywords: ruby,Regular Expressions
description: 介绍了正则表达式在ruby的用法
---
Ruby语言是一种“万事万物皆对象”的程序语言，正则表达式也是一个对象。正则表达式所属的类，就是Regexp类。  
要建立正则表达式两种方法：   
1.用“//”括住。    
2.当正则表达式内部用到“/”字符的时候，改用%r会比较方便。 示例%r(样式)
下面介绍一些规则。   
1.^ 行首匹配 $行尾匹配 \A 字符串头 \Z字符串尾   
2.指定想要匹配成功的文字范围用[]   
	比如[A-Z]所有大写英文字母[A-Za-z]所有英文字母[0-9]所有阿拉伯数字[^ABC]A、B、C以外的字   
3.匹配任意字符用.   
	想要指定字数/^…$/ 刚好三个字的一行   
	配合“*”等转义字符使用   
<!--more-->
4.使用反斜杠的样式（“\”+“一个英文字母”）      
	\s 空白 会与空白字符（0x20）、定位字符、换行字符、换页字符匹配成功   
	\d与0-9之间的数字匹配成功
	\w与英文与数字匹配成功
	\A与字符串前端匹配成功
	\Z与字符串末端匹配成功
5.将转义字符当作一般字符   
	“\”后接上“^”、“$”、“[”这些英文、数字以外的转义字符时，这些字符就不在具备转义字符的效用了，而可以去匹配这些字符本身。
6.匹配连续出现的相同字符或单字   
	*出现0次以上
	+出现1次以上
	?出现0次或1次
7.最短匹配   
	*?出现0次以上，但取最短的匹配结果
	+?出现1次以上，但取最短的匹配结果
8.“()”与反复   
	使用“()”可以多个字构成的字符串反复匹配
9.多选
	/^(ABC|DEF)$/
	正则项选项/```/后面类似/.../ei
	i忽略英文大小写差异
	s e u n 指定字符编码方式 s是Shift_JIS,e是EUC-JP，u是UTF-8 n是匹配是不考虑文字编码。
	x忽略正则表达式内部的空白，并忽略“#”后面的内容。加上这个选项就可以在正则表达式内部写注释了。
	m 让“.”能与换行符号匹配成功
	p /DEF.GHI/m =~ "ABC\nDEF\nGHI" #=> 4 匹配成功
<br />
**正则表达式的方法**    
sub、gsub、scan    
sub方法只会取代第一个匹配成功处的字符串，而gsub则会取代所有匹配成功的字符串    
	str = “abc def g hi”    
	p str.sub(/\s+/,' ') #=> "abc def g hi"   
	p str.gsub(/\s+/,' ') #=> "abc def g hi"   
scan跟gsub一样会匹配字符串里所有符合样式的部分，但只是获取不会取代。    
<br />
取出服务器的地址的正则表达式：    
	/http:\/\/([^\/]*)\// %r|http://([^/]*)/|   
``` ruby url_match.rb
str = "http://www.ruby-lang.org/ja/"   
%r|http://([^/]*)/| =~ str   
print "server address: ", $1, "\n"   
```  
运行：    
	>ruby url_match.rb   
	server address: www.ruby-lang.org

正则表达式的圣书：`Mastering Regular Expressions, Third Edition (Jeffrey E.F.Friedl 著/O'REILLY 出版) `   
<br />
本站文章如果没有特别说明，均为**原创**，转载请以**链接**方式注明本文地址：`http://tinyxd.me/blog/2012/07/07/regular-expressions-in-ruby/`