---
layout: post
title: "VPS安装openVPN"
date: 2012-08-30 12:24
comments: true
categories: vps
tags: [vps,vpn]
keywords: debian,ubuntu,安装openvpn
description: 在vps(openvz架构)上安装openVPN，至于为什么要安装openVPN，我想大家都懂的。
---
首先，你得有VPS或者独立服务器。   
因为我的VPS是openVZ的，查资料发现新的openVZ的VPS是支持PPTP的。不过鉴于安全性的考虑我还是使用openVPN。   
本文后面会介绍在debian 6下面安装openvpn的一些注意事项以及在xp下面安装openVPN。   
使用一键安装包来安装openVPN   
---
1.检查你的VPS是否支持Tun/Tap/nat/ppp，登录VPS检查    
	cat /dev/net/tun
如果返回 `cat: /dev/net/tun: File descriptor in bad state` 说明tun是可用的。   
	iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o venet0 -j MASQUERADE
如果返回`iptables: No chain/target/match by that name`说明nat也是可以用的。   
<!--more-->
如果返回结果不是以上描述的，那么说明你的VPS服务商默认没有开通。你可以发ticket要求VPS提供商提供这个，我的VPS就没有提供这个，就发了ticket，不过很快就解决了。   
2.检查服务器的DNS    
	vi /etc/resolv.conf
可以使用    
OpenDNS提供的DNS服务器地址
　　208.67.222.222
　　208.67.220.220
Google提供的DNS服务
	8.8.8.8
	8.8.4.4
3.下载John Malkowski的Debian OpenVPN脚本。    
	wget http://vpsnoc.com/scripts/debian-openvpn.sh
	chmod +x debian-openvpn.sh
	./debian-openvpn.sh
连续填写server和client的信息，出现y/n的时候都选择y。   
然后把生成的`keys.tgz`下载自本地。   
不使用一键安装包，一步步自己安装
---
以下内容参考了：[VPS侦探 Linode VPS OpenVPN安装配置教程(基于Debian/Ubuntu)](http://www.vpser.net/build/linode-install-openvpn.html)      
1.安装   
	apt-get install openvpn udev lzop
2.OpenVPN提供了”easy-rsa”这套加密方面的工具openvpn安装好之后easy-rsa在/usr/share/doc/openvpn/examples/easy-rsa/文件夹中为了使OpenVPN正常工作需要把easy-rsa复制到/etc/openvpn中.运行下列命令:     
	#cp -R /usr/share/doc/openvpn/examples/easy-rsa/ /etc/openvpn
在`/etc/openvpn/easy-rsa/2.0/`中设置，基本所有的OpenVPN配置都在这。   
生产CA证书：   
```
cd /etc/openvpn/easy-rsa/2.0
source vars
./clean-all
./build-ca
```
`./build-ca`时会提示输入一些信息，可以都直接回车按默认信息。   
3.生成服务器端证书和密钥：
	./build-key-server server
有两次需要输入y。   
4.生产客户端证书和密钥：   
	./build-key client
生成的证书和密钥在`/etc/openvpn/easy-rsa/2.0/keys/`下面。   
5.生成Diffie Hellman参数：    
	./build-dh
6.安装配置openVPN客户端    详情见参考。   
windows客户端下载
---
1.下载OpenVPN：<http://www.openvpn.net/index.php/open-source/downloads.html>下载最新版本安装包。   
2.安装，建议win7/vista用户安装到非系统分区。
3.修改虚拟网卡DNS，Google DNS :8.8.8.8和 8.8.4.4；OpenDNS的208.67.222.222 和208.67.220.220。   
4.将keys.tgz解压至openVPN安装目录下的config目录。   
5.运行openVPN。   
6.如果没有什么差错的话至此安装成功。   
可以进<http://www.dnsstuff.com> 或者facebook/twitter等测试下。惊喜等着你哦！   
如果需要和你的朋友分享这个，可以新建个用户，重新生成客户端证书。   
```
cd /etc/openvpn/easy-rsa/2.0
 ./vars
./build-key user1
```
将新生成的user1.crt,user1.key,user1.csr三个文件和*.ovpn和ca.crt、ca.key三个文件一起下载到本地，编辑下载下来的`*.ovpn`文件将其中的`cert client1.crt`和`key client1.key`修改为：`cert user1.crt`和`key user1.key`。    
把以上文件，打包发送给你的朋友。并将其解压到config目录下。     
<br />
本文地址：<http://tinyxd.me/blog/2012/08/30/debian-ubuntu-setup-openvpn/>    

