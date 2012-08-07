---
layout: post
title: "linux缺页异常处理程序"
date: 2012-08-07 12:54
comments: true
categories: linux
tags: [linux,kernel]
keywords: linux page fault exception，缺页异常处理
descripption: Linux的缺页（Page Fault）异常处理程序必须区分以下两种情况：由编程错误所引起的异常，及由引用属于进程地址空间但还尚未分配物理页框的页所引起的异常。
---
Linux的缺页（Page Fault）异常处理程序必须区分以下两种情况：由编程错误所引起的异常，及由引用属于进程地址空间但还尚未分配物理页框的页所引起的异常。  

线性区描述符可以让缺页异常处理程序非常有效地完成它的工作。do_page_fault()函数是80x86上的缺页中断服务程序，它把引起缺页的线性地址和当前进程的线性区相比较，从而能够根据和下图所示的方案选择适当的方法处理这个异常。 
<!--more-->
<iframe src="https://skydrive.live.com/embed?cid=1F260DE1061FCF3E&resid=1F260DE1061FCF3E%21159&authkey=ACvRvyPr-3BWicI" width="320" height="207" frameborder="0" scrolling="no"></iframe> 

在实际中，情况更复杂一些，因为缺页处理程序必须处理多种分得更细的特殊情况，它们不宜在总体方案中列出来，还必须区分许多种合理的访问。处理程序的详细流程图如图所示： 

<iframe src="https://skydrive.live.com/embed?cid=1F260DE1061FCF3E&resid=1F260DE1061FCF3E%21160&authkey=AFYUnmLPL0RCxXM" width="299" height="319" frameborder="0" scrolling="no"></iframe> 

 

 

本文参考自《深入理解linux内核》和[缺页异常处理程序](http://blog.csdn.net/yunsongice/article/details/5637671) 。   
本文地址：<http://tinyxd.me/blog/2012/08/07/linux-page-fault-exception/>   