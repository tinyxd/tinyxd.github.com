---
layout: post
title: "linux工作队列"
date: 2012-07-11 23:08
comments: true
categories: linux
tags: [linux,kernel]
keywords: linux,工作队列,内核,kernel
description: Linux中的Workqueue机制就是为了简化内核线程的创建。 
---
##工作队列(workqueue) 

Linux中的Workqueue机制就是为了简化内核线程的创建。通过调用workqueue的接口就能创建内核线程。并且可以根据当前系统CPU的个数创建线程的数量，使得线程处理的事务能够并行化。 

workqueue是内核中实现简单而有效的机制，他显然简化了内核daemon的创建，方便了用户的编程， 

尽管可延迟函数和工作队列非常相似，但是它们的区别还是很大的。主要区别在于：可延迟函数运行在中断上下文中，而工作队列中的函数运行在进程上下文中。执行可阻塞函数（例如：需要访问磁盘数据块的函数）的唯一方式是在进程上下文中运行。因为在中断上下文中不可能发生进程切换。可延迟函数和工作队列中的函数都不能访问进程的用户态地址空间。事实上，可延迟函数被执行时不可能有任何正在运行的进程。另一方面，工作队列中的函数是由内核线程来执行的，因此，根本不存在它要访问的用户态地址空间。 

##工作队列的数据结构 

<p style="text-indent:2em">与工作队列相关的主要数据结构有两个：cpu_workqueue_struct和work_struct。名为workqueue_struct的描述符，包括一个有NR_CPUS个元素的数组，NR_CPUS是系统中CPU的最大数量（双核是有两个工作队列）。每个元素都是cpu_workqueue_struct类型的描述符。 

</p> 
<!--more-->

work_struct结构是对任务的抽象。在该结构中需要维护具体的任务方法，需要处理的数据，以及任务处理的时间。该结构定义如下： 

``` c
struct work_struct { 
	unsigned long pending;                /*如果函数已经在工作队列链表中，该字段值设为1，否则设为0*/ 
        struct list_head entry;                  /* 将任务挂载到queue的挂载点 */ 
        void (*func)(void *);                   /* 任务方法 */ 
        void *data;                                  /* 任务处理的数据*/ 
       void *wq_data;                           /* work的属主（通常是指向cpu_workqueue_struct描述符的父结点的指针） */ 
       strut timer_list timer;                   /* 任务延时处理定时器 */ 
}; 
```

##工作队列函数 

当用户调用workqueue的初始化接口create_workqueue或者create_singlethread_workqueue对workqueue队列进行初始化时，内核就开始为用户分配一个workqueue对象，并且将其链到一个全局的workqueue队列中。然后Linux根据当前CPU的情况，为workqueue对象分配与CPU个数相同的cpu_workqueue_struct对象，每个cpu_workqueue_struct对象都会存在一条任务队列。紧接着，Linux为每个cpu_workqueue_struct对象分配一个内核thread，即内核daemon去处理每个队列中的任务。至此，用户调用初始化接口将workqueue初始化完毕，返回workqueue的指针。    

在初始化workqueue过程中，内核需要初始化内核线程，注册的内核线程工作比较简单，就是不断的扫描对应cpu_workqueue_struct中的任务队列，从中获取一个有效任务，然后执行该任务。所以如果任务队列为空，那么内核daemon就在cpu_workqueue_struct中的等待队列上睡眠，直到有人唤醒daemon去处理任务队列.    

Workqueue初始化完毕之后，将任务运行的上下文环境构建起来了，但是具体还没有可执行的任务，所以，需要定义具体的work_struct对象。然后将work_struct加入到任务队列中，Linux会唤醒daemon去处理任务。    

queue_work()（封装在work_struct描述符中）把函数插入工作队列，它接收wq和work两个指针。wq指向workqueue_struct描述符，work指向work_struct描述符。queue_work（）主要执行下面的步骤：    

1.检查要插入的函数是否已经在工作队列中（work->pending字段等于1），如果是就结束。 

2.把work_struct描述符加到工作队列链表中，然后把work->pending置为1。 

3.如果工作者线程在本地CPU的cpu_workqueue_struct描述符的more_work等待队列上睡眠，该函数唤醒这个线程。 

##预定义工作队列 

在绝大多数情况下，为了运行一个函数而创建整个工作者线程开销太大了。因此，内核引入叫做events的预定义工作队列，所有的内核开发者都可以随便使用它。预定义工作队列只是一个包含不同内核层函数和IO驱动程序的标准工作队列，它的workququq_struct描述符存放在keventd_wq数组中。 

工作队列编程接口：   

<table border="1"> 
<tr> 
    <th>序号</th> 
    <th>接口函数</th>  
    <th>函数说明</th> 
</tr>  
<tr>  
    <td>1</td>  
    <td>create_workqueue</td> 
    <td>用于创建一个workqueue队列，为系统中的每个CPU都创建一个内核线程。输入参数：@name：workqueue的名称</td> 
</tr>  
<tr>  
    <td>2</td>  
    <td>create_singlethread_workqueue</td>  
    <td>用于创建一个workqueue队列，为系统中的每个CPU都创建一个内核线程。输入参数：@name：workqueue的名称</td> 
</tr> 
<tr> 
    <td>3</td> 
    <td>destroy_workqueue</td> 
    <td>释放workqueue队列。输入参数：@ workqueue_struct：需要释放的workqueue队列指针</td> 
</tr>  
<tr> 
    <td>4</td> 
    <td>schedule_work</td> 
    <td>调度执行一个具体的任务，执行的任务将会被挂入Linux系统提供的workqueue——keventd_wq输入参数：@ work_struct：具体任务对象指针 
</td> 
</tr>  
<tr> 
    <td>5</td> 
    <td>schedule_delayed_work</td> 
    <td>延迟一定时间去执行一个具体的任务，功能与schedule_work类似，多了一个延迟时间，输入参数：@work_struct：具体任务对象指针@delay：延迟时间</td> 
</tr>  
<tr> 
    <td>6</td> 
    <td>queue_work</td> 
    <td>调度执行一个指定workqueue中的任务。输入参数：@ workqueue_struct：指定的workqueue指针@work_struct：具体任务对象指针</td> 
</tr>  
<tr> 
    <td>7</td> 
    <td>queue_delayed_work</td> 
    <td>延迟调度执行一个指定workqueue中的任务，功能与queue_work类似，输入参数多了一个delay</td> 
</tr>  
</table> 

预定义工作队列支持函数:    

<table > 
<tr> 
    <td>预定义工作队列函数</td> 
    <td>等价的标准工作队列函数</td> 
</tr> 
<tr> 
    <td>schedule_work(w)</td>     
    <td>queue_work( keventd_wq,w)</td> 
</tr> 
<tr> 
    <td>schedule_delayed_work(w,d)</td>     
    <td>queue_delayed_work(keventd_wq,w,d)在任何CPU上</td> 
</tr> 
<tr> 
    <td>schedule_delayed_work_on(cpu,w,d)</td>     
    <td>queue_delayed_work(keventd_wq,w,d)（在某个指定的CPU上）</td> 
</tr> 
<tr> 
    <td>flush_scheduled_work</td>     
    <td>flush_workqueue(keventd_wq)</td> 
</tr> 
</table>  

除了一般的events队列，在linux2.6中你还会发现一些专用的工作队列。其中最重要的是快设备层使用的kblockd工作队列。 

本文章整理自网络和《深入理解linux内核》。    

 
