---
layout: post
title: "linux堆的管理"
date: 2012-08-09 18:32
comments: true
categories: linux
tags: [linux,kernel]
keywords: heap,堆管理,内核
description: 每个Unix进程都拥有一个特殊的线性区，这个线性区就是所谓的堆，堆用于满足进程的动态内存请求。
---
每个Unix进程都拥有一个特殊的线性区，这个线性区就是所谓的堆（heap），堆用于满足进程的动态内存请求。内存描述符的start_brk与brk字段分别限定了这个区的开始地址和结束地址。 
<!--more-->
进程可以使用下面的API来请求和释放动态内存： 

 

malloc（size） 

    请求size个字节的动态内存。如果分配成功，就返回所分配内存单元第一个字节的线性地址。 

 

calloc（n，size） 

    请求含有n个大小为size的元素的一个数组。如果分配成功，就把数组元素初始化为0，并返回第一个元素的线性地址。 

 

realloc（ptr，size） 

    改变由前面的malloc()或calloc()分配的内存区字段的大小。 

 

free（addr） 

    释放由malloc()或calloc()分配的起始地址为addr的线性区。 

 

brk(addr) 

    直接修改堆的大小。addr参数指定current->mm->brk的新值，返回值是线性区新的结束地址（进程必须检查这个地址和所请求的地址值addr是否一致）。  

 

sbrk(incr) 

    类似于brk()，不过其中的incr参数指定是增加还是减少以字节为单位的堆大小。 

 

brk()函数和以上列出的函数有所不同，因为它是唯一以系统调用的方式实现的函数，而其他所有的函数都是使用brk()和mmap()系统调用实现的C语言库函数。  

 

当用户态的进程调用brk()系统调用时，内核执行sys_brk(addr)函数。该函数首先验证addr参数是否位干进程代码所在的线性区。如 果 是，则立即返回，因为堆不能与进程代码所在的线性区重叠：  
``` c
    mm = current->mm; 

    down_write(&mm->mmap_sem); 

    if (addr < mm->end_code) { 

    out: 

        up_write(&mm->mmap_sem); 

        return mm->brk; 

    } 
```
 

由于brk()系统调用作用于某一个非代码的线性区，它分配和释放完整的页 。因此，该函数把addr的值调整为PAGE_SIZE的倍数，然后把调整的结果与内存描述符的brk字段的值进行比较： 
``` c
    newbrk = (addr + 0xfff) & 0xfffff000; 

    oldbrk = (mm->brk + 0xfff) & 0xfffff000; 

    if (oldbrk == newbrk) { 

        mm->brk = addr; 

        goto out; 

    } 
```
 

如果进程请求缩小堆，则sys_brk()调用do_munmap()函数完成这项任务，然后返回： 
``` c
    if (addr <= mm->brk) { 

        if (!do_munmap(mm, newbrk, oldbrk-newbrk)) 

            mm->brk = addr; 

        goto out; 

    } 
```
 

如果进程请求扩大堆，则sys_brk()首先检查是否允许进程这样做。如果进程企图分配在其跟制范围之外的内存，函数并不多分配内存，只简单地返回mm->brk的原有值： 
``` c
    rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur; 

    if (rlim < RLIM_INFINITY && addr - mm->start_data > rlim) 

        goto out; 
```
 

然后，函数检查扩大后的堆是否和进程的其他线性区相重叠，如果是，不做任何事情就返回： 
``` c
    if (find_vma_intersection(mm, oldbrk, newbrk+PAGE_SIZE)) 

        goto out; 
```
 

如果一切都顺利，则调用do_brk()函数。如果它返回oldbrk,则分配成功且sys_brt()函数返回addr的值；否则，返回旧的mm->brk值： 
``` c
    if (do_brk(oldbrk, newbrk-oldbrk) == oldbrk) 

        mm->brk = addr; 

    goto out; 
```
 

do_brk()函数实际上是仅处理匿名线性区的do_mmap()的简化版。可以认为它的调用等价于： 
``` c
    do_mmap(NULL, oldbrk, newbrk-oldbrk, PROT_READ|PROT_WRITE|PROT_EXEC, 

            MAP_FIXED|MAP_PRIVATE, 0) 
```
 

当然，do_brk()比do_mmap()稍快，因为前者假定线性区不映射磁盘上的文件，从而避免了检查线性区对象的几个字段。 

 
本文参考《深入理解linux内核》。   
本文地址：<http://tinyxd.me/blog/2012/08/09/linux-heap-management/>   