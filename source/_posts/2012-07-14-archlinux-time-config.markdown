---
layout: post
title: "archlinux下的时间时区设置"
date: 2012-07-14 23:56
comments: true
categories: linux
tags: [archlinux,linux]
keywords: archlinux,linux,time,timezone,config
description: 众所周知,archlinux时间的设置比较麻烦，本文将提供几种方法解决此问题。
---
本文方法适合于archlinux，archbang等衍生版本。archbang亲测。   
1.打开`/etc/rc.conf`，将`TIMEZONE`改为`"Asia/Shanghai"`。   
2.打开`/etc/rc.conf`，将`HARDWARECLOCK`改为`"localtime"`。   
下面是改完的rc.conf：   
<!--more-->   
{% codeblock  %}
#
# /etc/rc.conf - Main Configuration for Arch Linux

LOCALE="en_US.UTF-8"
DAEMON_LOCALE="no"
HARDWARECLOCK="localtime"
TIMEZONE="Asia/Shanghai"
KEYMAP="us"
CONSOLEFONT=
CONSOLEMAP=
USECOLOR="yes"

MODULES=()

UDEV_TIMEOUT=30
USEDMRAID="no"
USEBTRFS="no"
USELVM="no"

HOSTNAME="archbang"

interface=eth0
address=
netmask=
broadcast=
gateway=

DAEMONS=(dbus networkmanager !network !dhcdbd syslog-ng @alsa @iNodeAuthService @openntpd)
{% endcodeblock %}   
3.在`/etc/localtime`做个软链接给具体的`zoneinfo`：      
	sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime     
4.这个时候时区应该算是正确设置好了，把硬件时钟再同步回系统来。   
	$ sudo hwclock --hctosys   
5.现在看时间正确了没，如果还有问题，参照archlinux的官方wiki（题外话：wiki是个好东西，可以找到你需要的）安装openNTPD，自动同步时间。   
	$ sudo pacman -S openntpd   
配置文件看了下，基本都不用修改，直接起服务：   
	$ sudo /etc/rc.d/openntpd start   
确保网络通畅，等一会，系统时间应该就会更新了，确实蛮方便   
最后在`rc.conf`的DAEMONS里面加上`@openntpd`，确保开机后台运行。
<br />   

