---
layout: post
title: "cache一致性问题总结"
date: 2012-05-31 20:59
comments: true
categories: embedded
tags: [embedded ,cache ,dsp]
keywords: cache
description: cache一致性问题总结
---

##1.现代并行机中，为了提高处理器的速度，处理器往往带有Cache。  
一个数据在整个系统内可能有多份拷贝，这就引发了Cache一致性问题。
例如下图中的2个处理器和共享内存构成的系统。初始时刻，处理机P1和P2都将变量X从共享内存装入了私有Cache。
这时，两个Cache中和共享内存中的变量X的值是一样的。在程序运行的某一时刻，处理机P1把X的值修改为X'，并更新了私有Cache中 的值。
此时无论P1采用写直达（write-through），还是写回（write-back）策略，都不会修改P2私有Cache中X的值。这时如果P2需要读取X，则它得到的是过时的值。   
{% img  /images/cache.gif %} 
<!--more-->
　　Cache一致性问题是指在含有多个Cache的并行系统中，数据的多个副本（因为没有同步更新）而造成的不一致问题。以上的例子是由于多个处理器共享一个可写变量
造成的Cache不一致。还有其它原因也会造成Cache一致性问题，比如进程迁移和某些I/O操作等。
##2.c64x+与cache一致性问题（http://focus.ti.com.cn/cn/general/docs/gencontent.tsp?contentId=64183）   

在各种数字信号处理系统中，CACHE被广泛用于弥补Core与存储器之间的速度差异。在CACHE的使用过程中，存在不同类型存储器之间数据是否一致的问题。
本文着重分析TI高性能C64x+ DSP系列中各级CACHE之间数据一致性问题以及如何进行一致性维护。CACHE作为Core和低速存储器之间的桥梁，基于代码和
数据的时间和空间相关性，以块为单位由硬件控制器自动加载Core所需要的代码和数据。如果所有程序和数据的存取都由Core完成，基于CACHE的运行机制，
Core始终能够得到存储器中最新的数据。但是当有其它可以更改存储器内容的部件存在时，例如不需要Core干预的直接数据存取（DMA）引擎，就可能出现
由于CACHE的存在而导致Core或者DMA不能够得到最新数据的现象，也就是CACHE一致性的问题。 C64x+ 存储器组织结构：TI对高性能C64x核进行了改进，
使其性能大大提升，称之为C64x+DSP核。基于C64x+核开发的DSP芯片，所有部件都以交换网络（SCR）为核心连接起来。SCR上的部件分为两类：Master和Slave。
Master包括Core、EDMA以及串行高速IO（sRIO），EMAC等外设。Master可以直接通过SCR发起到Slave的数据传输。Slave包括每一个Core的内存，DDR2外存以及
其它不能直接发起数据传输的外设，Slave之间的数据传输，需要通过DMA协助完成。各款基于C64x+DSP的数据手册上详细描述了SCR的配置和Master、Slave的情况。

##3.DMA与cache一致性问题    
　Cache数据与主存数据不一致是指：在采用Cache的系统中，同样一个数据可能既存在于Cache中，也存在于主存中，两者数据相同则具有一致性，
数据不相同就叫做不一致性。如果不能保证数据的一致性，那么，后续程序的运行就要出现问题。假设DMA针对内存的目的地址与Cache缓存的对象
没有重叠区域，DMA和Cache之间将相安无事。但是如果DMA的目的地址与Cache所缓冲的内存地址访问有重叠，经过DMA操作Cache缓冲所对应的内存数据已经被修改，
而CPU本身并不知道，它仍然认为Cache中的数据就是内存中的数据，以后访问Cache映射的内存时，它仍然使用陈旧的Cache数据。这样就发生Cache与内存之间数据“
不一致性”的错误。