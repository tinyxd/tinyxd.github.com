---
layout: post
title: "解决pygments.rb (RubyPython) 找不到libpython的问题(archlinux下)"
date: 2012-06-05 08:01
comments: true
categories: ruby
keywords: pygments.rb, ruby, rubypython ,libpython,archlinux
description:  解决pygments.rb (RubyPython) 找不到libpython的问题(archlinux下)
---

本文章转自：[Ruby China 论坛](http://ruby-china.org/topics/289)   
如果找不到python，或者系统默认得python是3.x (比如Arch Linux)，手动制定下路径   
```
RubyPython.configure python_exe: '/usr/bin/python2.7'
```
对于rails项目比如ruby-china，可以把这行代码丢到config/initializers下。   

不过RubyPython仍然可能找不到libpython而提示lib.so not found。这是由于RubyPython确定正确libpython的规则和你的系统不兼容，可以通过手动加些symbol links来解决 (目前RubyPython的git最新代码相对当前稳定版本0.5.3改动非常大，希望新版本能解决这个问题，就先不去提交fixing了)。   

可以参考 PythonExec initialize 方法中的规则来建symbol link.   
<!--more-->
首先运行该python，得到版本号x.y，以python2.7为例   
```
$ python2.7 -c "import sys;print '%d.%d' % sys.version_info[:2]"

=> 2.7
```
找到该python对应得libpython，可以用工具ldd:   
```
$ ldd /usr/lib/python2.7 | grep python

=> libpython2.7.so.1.0 => /usr/lib/libpython2.7.so.1.0
```
为找到的这个文件创建链接。下面用#{exe_base}表示通过RubyPython.configure指定的python可执行程序的文件名部分，#{x}和#{y}是通过运行这个python找到得版本号，#{libpython}是该python对应得libpython库文件路径。   
```
sudo ln -s #{libpython} /usr/lib/lib#{exe_base}#{x}#{y}.so
sudo ln -s #{libpython} /usr/lib/lib#{exe_base}#{x}.#{y}.so
```
以我的环境(Arch Linux)为例，exe_base是python2.7，版本号x.y是2.7，libpython是/usr/lib/libpython2.7.so.1.0，   
```
sudo ln -s /usr/lib/libpython2.7.so.1.0 /usr/lib/libpython2.727.so
sudo ln -s /usr/lib/libpython2.7.so.1.0 /usr/lib/libpython2.72.7.so
```
