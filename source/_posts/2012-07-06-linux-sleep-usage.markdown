---
layout: post
title: "linux sleep 的用法"
date: 2012-07-06 12:40
comments: true
categories: linux
tags: linux
keywords: linux,sleep
description: linux sleep的用法
---
**应用程序**：   
	#include <syswait.h>
	usleep(n) //n微秒
	Sleep（n）//n毫秒
	sleep（n）//n秒
<!--more-->
**驱动程序**：   
	#include <linux/delay.h>
	mdelay(n) //milliseconds 其实现
```
#ifdef notdef
#define mdelay(n) (\
{unsigned long msec=(n); while (msec--) udelay(1000);})
#else
#define mdelay(n) (\
(__builtin_constant_p(n) && (n)<=MAX_UDELAY_MS) ? udelay((n)*1000) : \
({unsigned long msec=(n); while (msec--) udelay(1000);}))
#endif
```
调用asm/delay.h的udelay,udelay应该是纳秒级的延时   

dos:    
	sleep(1); //停留1秒 
	delay(100); //停留100毫秒   
Windows:    
	Sleep(100); //停留100毫秒 
Linux:    
	sleep(1); //停留1秒 
	usleep(1000); //停留1毫秒 
每一个平台不太一样,最好自己定义一套跨平台的宏进行控制     
附：Linux下（使用的gcc的库），sleep()函数是以秒为单位的，sleep(1);就是休眠1秒。而MFC下的sleep()函数是以微秒为单位的，sleep(1000);才是休眠1秒。而如果在Linux下也用微妙为单位休眠，可以使用线程休眠函数:void usleep(unsigned long usec);当然，使用的时候别忘记#include <system.h>哦。另外，linux下还有个delay()函数，原型为extern void delay(unsigned int msec);它可以延时msec*4毫秒，也就是如果想延时一秒钟的话，可以这么用 delay(250)。   

