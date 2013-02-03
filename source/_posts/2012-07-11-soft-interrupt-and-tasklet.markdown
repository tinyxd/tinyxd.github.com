---
layout: post
title: "软中断和tasklet"
date: 2012-07-11 22:57
comments: true
categories: linux
tags: [linux,内核]
keywords: soft interrupt,tasklet,软中断,内核,linux
description: 介绍了linux内核中软中断和tasklet机制。
---
##软中断：

Linux中的软中断机制用于系统中对时间要求最严格以及最重要的中断下半部进行使用。在系统设计过程中，大家都清楚中断上下文不能处理太多的事情，需要快速的返回，否则很容易导致中断事件的丢失，所以这就产生了一个问题：中断发生之后的事务处理由谁来完成？在前后台程序中，由于只有中断上下文和一个任务上下文，所以中断上下文触发事件，设置标记位，任务上下文循环扫描标记位，执行相应的动作，也就是中断发生之后的事情由任务来完成了，只不过任务上下文采用扫描的方式，实时性不能得到保证。在Linux系统和Windows系统中，这个不断循环的任务就是本文所要讲述的软中断daemon。在Windows中处理耗时的中断事务称之为中断延迟处理，在Linux中称之为中断下半部，显然中断上半部处理清中断之类十分清闲的动作，然后在退出中断服务程序时触发中断下半部，完成具体的功能。

在Linux中，中断下半部的实现基于软中断机制。所以理清楚软中断机制的原理，那么中断下半部的实现也就非常简单了。通过上述的描述，大家也应该清楚为什么要定义软中断机制了，一句话就是为了要处理对时间要求苛刻的任务，恰好中断下半部就有这样的需求，所以其实现采用了软中断机制。

linux2.6中使用的软中断：

``` c interrupt.h
enum
{
	HI_SOFTIRQ=0, /*用于高优先级的tasklet(下标(优先级0))*/
	TIMER_SOFTIRQ, /*用于定时器的下半部(下标(优先级1))*/
	NET_TX_SOFTIRQ,/*用于网络层发包(下标(优先级2))*/
	NET_RX_SOFTIRQ, /*用于网络层收报(下标(优先级3))*/
	SCSI_SOFTIRQ, /*用于scsi设备(下标(优先级4))*/
	TASKLET_SOFTIRQ /*用于低优先级的tasklet(下标(优先级5))*/
};
```
<!--more-->

一个软中断的下标决定了它的优先级；低下标意味着高优先级，因为软中断函数将从下标0开始执行。

##tasklet:

Tasklet为一个软中断，考虑到优先级问题，分别占用了向量表中的0号和5号软中断。

tasklet是IO驱动程序中实现可延迟函数的首选方法。其建立在两个叫HI_SOFTIRQ和TASKLET_SOFTIRQ的软中断之上。 
##软中断和tasklet

软中断和tasklet有密切的关系，tasklet是在软中断之上实现。事实上，出现在内核代码中的术语“软中断（softirq）” 常常表示可延迟函数的所有种类。另外一种被广泛使用的术语是“中断上下文”：表示内核当前正在执行一个中断处理程序或一个可延迟的函数。

软中断的分配是静态的（即在编译时定义），而tasklet的分配和初始化可以在运行时进行（例如：安装一个内核模块时）。软中断（即便是同一种类型的软中断）可以并发地运行在多个CPU上。因此，软中断是可重入函数而且必须明确地使用自旋锁保护其数据结构。tasklet不必担心这些问题，因为内核对tasklet的执行进行了更加严格的控制。相同类型的tasklet总是被串行地执行，换句话说就是：不能在两个CPU上同时运行相同类型的tasklet。但是，类型不同的tasklet可以在几个CPU上并发执行。tasklet的串行化使tasklet函数不必是可重入的，因此简化了设备驱动程序开发者的工作。

一般而言，可延迟函数上可以执行四种函数：初始化、激活、屏蔽和执行。

##软中断的主要数据结构

软中断的主要数据结构是softirq_vec数组，该数组包含类型为softirq_action的32个元素。一个软中断的优先级是相应的softirq_action元素在数组内的下标，只有前六个被有效使用。

/\*表示softirq最多可以有32种类型，实际上linux只使用了六种，见文件interrupt.h\*/

static struct softirq_action softirq_vec[32] __cacheline_aligned_in_smp;

softirq_action数据结构包括两个字段：指向软中断函数的一个action指针和指向软中断函数需要的通用数据结构的data指针。

还有一个关键的字段是32位的preempt_cout字段，用它来跟踪内核抢占和内核控制路径的嵌套，该字段存放在每个进程描述符的thread_info字段中。

对于softirq，linux kernel中是在中断处理程序执行的，具体的路径为： 
	do_IRQ() --> irq_exit() --> invoke_softirq() --> do_softirq() --> __do_softirq() 
在__do_softirq()中有这么一段代码：    
``` c
        do { 

                if (pending & 1) { 

                        h->action(h); 

                        rcu_bh_qsctr_inc(cpu); 

                } 

                h++; 

                pending >>= 1; 

        } while (pending); 
``` 

你看，这里就是对softirq进行处理了，因为pengding是一个__u32的类型，所以每一位都对应了一种softirq，正好是32种（linux kernel中实际上只使用了前6种 ）. h->action(h),就是运行softirq的处理函数。 

对于tasklet，前面已经说了，是一种特殊的softirq，具体就是第0和第5种softirq，所以说tasklet是基于softirq来实现的。 

tasklet既然对应第0和第5种softirq，那么就应该有对应的处理函数，以便h->action()会运行tasklet的处理函数。 

我们看代码： 
``` c softirq.c 


void __init softirq_init(void)   

{ 

        open_softirq(TASKLET_SOFTIRQ, tasklet_action, NULL); 

        open_softirq(HI_SOFTIRQ, tasklet_hi_action, NULL); 

} 
```
 
这里注册了两种tasklet所在的softirq的处理函数，分别对应高优先级的tasklet和低优先级的tasklet。 

我们看低优先级的吧（高优先级的也一样）。 
``` c tasklet_action
static void tasklet_action(struct softirq_action *a) 

{ 

        struct tasklet_struct *list; 

        local_irq_disable(); 

        list = __get_cpu_var(tasklet_vec).list; 

        __get_cpu_var(tasklet_vec).list = NULL; 

        local_irq_enable(); 

        while (list) { 

                struct tasklet_struct *t = list; 

                list = list->next; 

                if (tasklet_trylock(t)) { 

                        if (!atomic_read(&t->count)) { 

                                if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state)) 

                                        BUG(); 

                                t->func(t->data); 

                                tasklet_unlock(t); 

                                continue; 

                        } 

                        tasklet_unlock(t); 

                } 

                local_irq_disable(); 

                t->next = __get_cpu_var(tasklet_vec).list; 

                __get_cpu_var(tasklet_vec).list = t; 

                __raise_softirq_irqoff(TASKLET_SOFTIRQ);   

                local_irq_enable(); 

        } 

} 
```
你看，在运行softirq的处理时（__do_softirq），对于 
``` c
        do { 

                if (pending & 1) { 

                        h->action(h); 

                        rcu_bh_qsctr_inc(cpu); 

                } 

                h++; 

                pending >>= 1; 

        } while (pending); 
```
如果tasklet有任务需要处理，会运行到h->action()，这个函数指针就会指向tasklet_action()，然后在tasklet_action()里再去执行tasklet对应的各个任务，这些任务都是挂在一个全局链表里面的，具体的代码这里就不分析了。 

另外， softirq在smp中是可能被同时运行的，所以softirq的处理函数必须被编写成可重入的函数。 

但tasklet是不会在多个cpu之中同时运行的，所以tasklet的处理函数可以编写成不可重入的函数，这样就减轻了编程人员的负担。 

##ksoftirqd内核线程  

在最近的内核版本中，每个CPU都有自己的ksoftirqd/n内核线程（这里，n为CPU的逻辑号）。每个ksoftirqd/n内核线程都运行ksoftirqd()函数。在预期的时间内处理挂起的软中断。 


<br />


 