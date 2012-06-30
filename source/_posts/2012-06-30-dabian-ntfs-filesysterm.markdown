---
layout: post
title: "让Debian支持ntfs文件系统读写"
date: 2012-06-30 15:45
comments: true
categories: linux
tags: [debian , ntfs , linux ]
keywords: debian , ntfs , linux , filesysterm，文件系统
description: debian , ntfs , linux , filesysterm，文件系统
---
刚装好debian发现在debian下往windows盘下拷贝不过去资料，上网查了些资料发现是因为不知道ntfs的读写。   
查看我的版本号6.0.5   
	#more /etc/debian_version   
	6.0.5   
我的Debian系统: 6.0.5   
要是用的软件使用软件:ntfs-3g   
1.修改默认源   
因为我们学校有自己的源，故而修改成我们学校的源，而后进行更新   
	apt-get update   
<!--more-->
2.执行安装   
执行命令:   
	apt-get install ntfs-3g   
3.使用   
直接使用执行命令:   
	mount -t ntfs-3g /dev/hdax /mnt/windows   
这里的/dev/hdax 请改为你自己的windows磁盘分区，可利用fdisk -l 查看。    
如下：   
```   
debian:/mnt# fdisk -l
Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x559ed1e5

  Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1        6528    52436128+   7  HPFS/NTFS
/dev/sda2            6529       60802   435949345+   f  W95 Ext'd (LBA)
/dev/sda5            6529       24543   144705456    7  HPFS/NTFS
/dev/sda6           24544       42558   144705456    7  HPFS/NTFS
/dev/sda7           42559       53060    84357283+   7  HPFS/NTFS
/dev/sda8           53061       53321     2096451    b  W95 FAT32
/dev/sda9   *       53322       53346      194560   83  Linux
/dev/sda10          53346       53589     1951744   82  Linux swap / Solaris
/dev/sda11          53589       55413    14647296   83  Linux
/dev/sda12          55413       60802    43287552   83  Linux   
```

如果是加入开机自动映射的话，编辑/etc/fstab,加入如下内容就可以了。   
	/dev/hdax /mnt/windows ntfs-3g defaults 0 0   
下面是我的系统加载NTFS文件系统的相关命令：   
	mount -t ntfs-3g /dev/sda6 /mnt/D
	mount -t ntfs-3g /dev/sda7 /mnt/E   
以上文章是对网上搜集的资料的整理。如需转载请注明出处，本文地址：   
`http://tinyxd.me/blog/2012/06/30/debian-ntfs-filesysterm/`  