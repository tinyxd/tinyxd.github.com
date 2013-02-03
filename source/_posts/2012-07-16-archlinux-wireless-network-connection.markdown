---
layout: post
title: "archlinux 无线网络连接"
date: 2012-07-16 11:24
comments: true
categories: linux
tags: [linux,archlinux]
keywords: archlinux,linux,network,无线网络连接
description: archlinux下的无线网络连接
---
今天，回家了。由于家里用的无线路由器，我的本是archlinux系统，所以这就涉及到archlinux的无线网络配置。   
本文参考了[archlinux官方wiki](https://wiki.archlinux.org/index.php/Wireless_Setup)。   
配置无线网络一般分两步：   
第一步是识别硬件、安装正确的驱动程序并进行配置；   
第二步是选择一种管理无线连接的方式。   
关于第一步，wiki中有详细的介绍，我就不多叙述。   
第二步，有几个命令和无线网络的加密方法，需要说说。   
大概有两种方法：一个是手动，一个是自动。   
<!--more-->
##方法一：手动##
不加密/WEP ：ifconfig + iwconfig + dhcpcd/ifconfig    
WPA/WPA2 PSK：ifconfig + iwconfig + wpa_supplicant + dhcpcd/ifconfig    
1.激活内核接口: 
 	# ifconfig wlan0 up    
2.查看可以的无线接入点信息：
	# iwlist wlan0 scan
3.根据加密方式不同，需要使用密码将无线设备关联到接入点。
假设要使用的接入点 ESSID 为 MyEssid:    
a.无加密    
 	# iwconfig wlan0 essid "MyEssid"   
b.WEP    
使用十六进制密码：    
 	# iwconfig wlan0 essid "MyEssid" key 1234567890   
使用 ascii 密码：       
 	# iwconfig wlan0 essid "MyEssid" key s:asciikey   
c.WPA/WPA2     
需要安装 WPA_Supplicant 编辑 /etc/wpa_supplicant.conf 文件。   
a.先备份下 /etc/wpa_supplicant.conf：
	mv /etc/wpa_supplicant.conf /etc/wpa_supplicant.conf.original   
b.修改此文件，适合你的无线网络环境。当然可以阅读系统自带的/etc/wpa_supplicant.conf ，然后根据自己的无线环境来手动编辑。也可以使用下面的命令。   
	wpa_passphrase linksys "my_secret_passkey" > /etc/wpa_supplicant.conf   
这里，linksys代表的是要连接的无线网络的essid,而my_secret_passkey则是无线网络的密码。然后运行： 
	# wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf
假设设备使用 wext 驱动。如果无法工作，可能需要调整选项，参见 [WPA_Supplicant](https://wiki.archlinux.org/index.php/WPA_Supplicant)。   
4.获取IP地址。
静态IP：    
	# ifconfig wlan0 192.168.0.2
	# route add default gw 192.168.0.1
动态IP获取使用 DHCP： 
	# dhcpcd wlan0

如果因为“waiting for carrier”出现超时错误，可以设置通道模式为 auto    
	# iwconfig wlan0 channel auto 
注意: 尽管手动配置可以帮助解决无线问题，每次重启都需要执行这些步骤。

##方法二：使用管理工具来管理      
netcfg, newlan (AUR), wicd, NetworkManager, 等。
我使用的是NetworkManager，地址在[这里](https://wiki.archlinux.org/index.php/NetworkManager)。  
<br />   

