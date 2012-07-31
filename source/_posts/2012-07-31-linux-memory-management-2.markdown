---
layout: post
title: "linux内存管理（中）"
date: 2012-07-31 23:16
comments: true
categories: linux
tags: [linux,kernel,内核]
keywords: linux,kernel,内核,内存管理,slab,buddy,伙伴算法
description: 本文介绍了slab分配器。slab分配器是Linux内存管理中非常重要和复杂的一部分。
---


***摘要***：slab分配器是Linux内存管理中非常重要和复杂的一部分，其工作是针对一些经常分配并释放的对象，如进程描述符等，这些对象的大小一般比较小，如果直接采用伙伴系统来进行分配和释放，不仅会造成大量的内碎片，而且处理速度也太慢。而slab分配器是基于对象进行管理的，相同类型的对象归为一类(如进程描述符就是一类)，每当要申请这样一个对象，slab分配器就从一个slab列表中分配一个这样大小的单元出去，而当要释放时，将其重新保存在该列表中，而不是直接返回给伙伴系统。slab分配对象时，会使用最近释放的对象内存块，因此其驻留在CPU高速缓存的概率较高。 

 
简介
--- 
<!--more-->
内存管理的目标是提供一种方法，为实现各种目的而在各个用户之间实现内存共享。内存管理方法应该实现以下两个功能： 

* 最小化管理内存所需的时间 

* 最大化用于一般应用的可用内存（最小化管理开销） 

内存管理实际上是一种关于权衡的零和游戏。您可以开发一种使用少量内存进行管理的算法，但是要花费更多时间来管理可用内存。也可以开发一个算法来有效地管理内存，但却要使用更多的内存。最终，特定应用程序的需求将促使对这种权衡作出选择。 

每个内存管理器都使用了一种基于堆的分配策略。在这种方法中，大块内存（称为 堆）用来为用户定义的目的提供内存。当用户需要一块内存时，就请求给自己分配一定大小的内存。堆管理器会查看可用内存的情况（使用特定算法）并返回一块内存。搜索过程中使用的一些算法有 first-fit（在堆中搜索到的第一个满足请求的内存块 ）和 best-fit（使用堆中满足请求的最合适的内存块）。当用户使用完内存后，就将内存返回给堆。 

这种基于堆的分配策略的根本问题是碎片（fragmentation）。当内存块被分配后，它们会以不同的顺序在不同的时间返回。这样会在堆中留下一些洞，需要花一些时间才能有效地管理空闲内存。这种算法通常具有较高的内存使用效率（分配需要的内存），但是却需要花费更多时间来对堆进行管理。 

另外一种方法称为 buddy memory allocation，是一种更快的内存分配技术，它将内存划分为 2 的幂次方个分区，并使用 best-fit 方法来分配内存请求。当用户释放内存时，就会检查 buddy 块，查看其相邻的内存块是否也已经被释放。如果是的话，将合并内存块以最小化内存碎片。这个算法的时间效率更高，但是由于使用 best-fit 方法的缘故，会产生内存浪费。 

 

 

伙伴系统算法采用页框作为基本内存区，适合对大块内存的请求，为了解决外碎片的问题。而小内存的分配，会产生内碎片（internal fragmentation），这需要新的数据结构来描述在同一页框中 如何分配小内存区。 

为了满足内核对这种小内存块的需要，Linux系统采用了一种被称为slab分配器的技术。Slab分配器的实现相当复杂，但原理不难，其核心思想就是“存储池[2]”的运用。内存片段（小块内存）被看作对象，当被使用完后，并不直接释放而是被缓存到“存储池”里，留做下次使用，这无疑避免了频繁创建与销毁对象所带来的额外负载。 

Slab技术不但避免了内存内部分片（下文将解释）带来的不便（引入Slab分配器的主要目的是为了减少对伙伴系统分配算法的调用次数——频繁分配和回收必然会导致内存碎片——难以找到大块连续的可用内存），而且可以很好利用硬件缓存提高访问速度。 

Slab并非是脱离伙伴关系而独立存在的一种内存分配方式，slab仍然是建立在页面基础之上，换句话说，Slab将页面（来自于伙伴关系管理的空闲页框链）撕碎成众多小内存块以供分配，slab中的对象分配和销毁使用kmem_cache_alloc与kmem_cache_free。每个高速缓存都是由kmem_cache_t(等价于struct kmem_cache) 

slab分配器把对象分组放进高速缓存。包含高速缓存的主内存区被划分为多个slab，每个slab由一个或多个连续的页框组成，这些页框既包含已分配的对象，也包含空闲的对象。内核周期性地扫描高速缓存并释放空slab对应的页框。 

普通高速缓存在系统初始化期间调用kmem_cache_init()和kmem_cache_sizes_init()来建立普通高速缓存。专用高速缓存由kmem_cache_create()函数创建。所有普通和专用高速缓存的名字都可以在运行期间通过读取/proc/slabinfo文件得到。这个文件也指明每个高速缓存中空闲对象的个数和已分配对象的个数。 

slab的对象描述符与slab描述符本身类似，也可以用两种可能的方式来存放：外部对象描述符（存放在slab的外部）、内部对象描述符（存放在slab的内部）。每个对象都有类型为kmem_bufctl_t的一个描述符。 

API 函数 
---
现在来看一下能够创建新 slab 缓存、向缓存中增加内存、销毁缓存的应用程序接口（API）以及 slab 中对对象进行分配和释放操作的函数。 

第一个步骤是创建 slab 缓存结构，您可以将其静态创建为： 

struct struct kmem_cache *my_cachep;  

 

然后其他 slab 缓存函数将使用该引用进行创建、删除、分配等操作。kmem_cache 结构包含了每个中央处理器单元（CPU）的数据、一组可调整的（可以通过 proc 文件系统访问）参数、统计信息和管理 slab 缓存所必须的元素。 

kmem_cache_create 

内核函数 kmem_cache_create 用来创建一个新缓存。这通常是在内核初始化时执行的，或者在首次加载内核模块时执行。其原型定义如下： 

struct kmem_cache * kmem_cache_create( const char *name, size_t size, size_t align,                        unsigned long flags;                        void (*ctor)(void*, struct kmem_cache *, unsigned long),                        void (*dtor)(void*, struct kmem_cache *, unsigned long));  

 

name 参数定义了缓存名称，proc 文件系统（在 /proc/slabinfo 中）使用它标识这个缓存。 size 参数指定了为这个缓存创建的对象的大小， align 参数定义了每个对象必需的对齐。 flags 参数指定了为缓存启用的选项。这些标志如表 1 所示。 

 

表 1. kmem_cache_create 的部分选项（在 flags 参数中指定） 

选项                  说明 

SLAB_RED_ZONE      在对象头、尾插入标志，用来支持对缓冲区溢出的检查。 

SLAB_POISON            使用一种己知模式填充 slab，允许对缓存中的对象进行监视（对象属对象所有，不过可以在外部进行修改）。 

SLAB_HWCACHE_ALIGN             指定缓存对象必须与硬件缓存行对齐。 

 

ctor 和 dtor 参数定义了一个可选的对象构造器和析构器。构造器和析构器是用户提供的回调函数。当从缓存中分配新对象时，可以通过构造器进行初始化。 

在创建缓存之后， kmem_cache_create 函数会返回对它的引用。注意这个函数并没有向缓存分配任何内存。相反，在试图从缓存（最初为空）分配对象时，refill 操作将内存分配给它。当所有对象都被使用掉时，也可以通过相同的操作向缓存添加内存。 

kmem_cache_destroy 

内核函数 kmem_cache_destroy 用来销毁缓存。这个调用是由内核模块在被卸载时执行的。在调用这个函数时，缓存必须为空。 

void kmem_cache_destroy( struct kmem_cache *cachep );  

 

kmem_cache_alloc 

要从一个命名的缓存中分配一个对象，可以使用 kmem_cache_alloc 函数。调用者提供了从中分配对象的缓存以及一组标志： 

void kmem_cache_alloc( struct kmem_cache *cachep, gfp_t flags );  

 

这个函数从缓存中返回一个对象。注意如果缓存目前为空，那么这个函数就会调用 cache_alloc_refill 向缓存中增加内存。kmem_cache_alloc 的 flags 选项与 kmalloc 的 flags 选项相同。表 2 给出了标志选项的部分列表。 

 

表 2. kmem_cache_alloc 和 kmalloc 内核函数的标志选项 

标志    说明 

GFP_USER 为用户分配内存（这个调用可能会睡眠）。 

GFP_KERNEL       从内核 RAM 中分配内存（这个调用可能会睡眠）。 

GFP_ATOMIC         使该调用强制处于非睡眠状态（对中断处理程序非常有用）。 

GFP_HIGHUSER       从高端内存中分配内存。 

 

kmem_cache_zalloc 

内核函数 kmem_cache_zalloc 与 kmem_cache_alloc 类似，只不过它对对象执行 memset 操作，用来在将对象返回调用者之前对其进行清除操作。 

kmem_cache_free 

要将一个对象释放回 slab，可以使用 kmem_cache_free。调用者提供了缓存引用和要释放的对象。 

void kmem_cache_free( struct kmem_cache *cachep, void *objp );  

 

kmalloc 和 kfree 

内核中最常用的内存管理函数是 kmalloc 和 kfree 函数。这两个函数的原型如下： 

void *kmalloc( size_t size, int flags ); void kfree( const void *objp );  

 

注意在 kmalloc 中，惟一两个参数是要分配的对象的大小和一组标志（请参看 表 2 中的部分列表）。但是 kmalloc 和 kfree 使用了类似于前面定义的函数的 slab 缓存。kmalloc 没有为要从中分配对象的某个 slab 缓存命名，而是循环遍历可用缓存来查找可以满足大小限制的缓存。找到之后，就（使用 `__kmem_cache_alloc`）分配一个对象。要使用 kfree 释放对象，从中分配对象的缓存可以通过调用 virt_to_cache 确定。这个函数会返回一个缓存引用，然后在 __cache_free 调用中使用该引用释放对象。 

其他函数 
---
slab 缓存 API 还提供了其他一些非常有用的函数。 kmem_cache_size 函数会返回这个缓存所管理的对象的大小。您也可以通过调用kmem_cache_name 来检索给定缓存的名称（在创建缓存时定义）。缓存可以通过释放其中的空闲 slab 进行收缩。这可以通过调用kmem_cache_shrink 实现。注意这个操作（称为回收）是由内核定期自动执行的（通过 kswapd）。 

unsigned int kmem_cache_size( struct kmem_cache *cachep ); const char *kmem_cache_name( struct kmem_cache *cachep ); int kmem_cache_shrink( struct kmem_cache *cachep ); 

 

补充： 
---
如果对存储区的请求不频繁，就用一组普通高速缓存来处理，普通高速缓存中的对象具有几何分布的大小，范围为32~131072字节。 

使用kmalloc()函数申请，kfree()释放。   


<br />
本文章参考自《深入理解linux内核》及 [动态内存管理](https://www.ibm.com/developerworks/cn/linux/l-linux-slab-allocator/)。   
本站文章如果没有特别说明，均为**原创**，转载请以**链接**方式注明本文地址：<http://tinyxd.me/blog/2012/07/31/linux-memory-management-2/>