---
layout: post
title: "帮您快速入门TI的Codec Engine"
date: 2012-05-26 06:18
comments: true
categories:  davinci
keywords: davinci , codec engine 
description: 帮您快速入门TI的Codec Engine。
---
转自TI官网：    
德州仪器半导体技术（上海）有限公司 通用DSP 技术应用工程师 崔晶   

德州仪器（TI）的第一颗达芬奇（DaVinci）芯片（处理器）DM6446已经问世快三年了。继DM644x之后，TI又陆续推出了DM643x，DM35x，DM6467，OMAP353x等一系列ARM＋DSP或ARM＋视频协处理器的多媒体处理器平台。很多有很强DSP开发经验或ARM开发经验的工程师都转到达芬奇或通用OMAP（OMAP353x）平台上开发视频监控、视频会议及便携式多媒体终端等产品。大家都面临着同一个问题，那就是如何实现ARM和DSP或协处理器的通信和协同工作？TI的数字视频软件开发包（DVSDK）提供了Codec Engine这样一个软件模块来实现ARM和DSP或协处理器的协同工作。有很多工程师反馈这个软件模块非常好用，节省了很多开发时间，也有工程师认为TI提供的资料太多，不知如何快速上手。本文将从一个第一次接触Codec Engine的工程师角度出发，归纳TI提供的相关资源（文档，例程和网络资源）并介绍相关开发调试方法帮您快速入门Codec Engine。   
1．Codec Engine概述   
Codec Engine是连接ARM和DSP或协处理器的桥梁，是介于应用层（ARM侧的应用程序）和信号处理层（DSP侧的算法）之间的软件模块。ARM应用程序调用Codec Engine的VISA （Video, Image, Speech, Audio）API，如图1中VIDENC_process(a, b, c )。Codec Engine的stub （ARM侧）会把参数a, b, c以及要调用DSP侧process这个信息打包，通过消息队列（message queue）传递到DSP。Codec Engine的skeleton（DSP侧）会解开这个参数包，把参数a, b, c转换成DSP侧对应的参数x, y, z（比如ARM侧传递的是虚拟地址，而DSP只能认物理地址），DSP侧的server（优先级较低，负责和ARM通信的任务）会根据process这一信息创建一个DSP侧的process(x, y, x)任务最终实现VIDENC_process(a, b, c)的操作。   
2．Codec Engine入门第一步，从Codec Engine发布说明文档(release notes)开始   
3．Codec Engine入门第二步，了解Codec Engine的运行环境及依赖的软件模块和工具   

点击Codec Engine的发布说明文档 的Validation Info，我们可以知道Codec Engine 1.20需要和以下软件模块和工具配合使用：   

    Framework Components 1.20.02   
    xDAIS 5.21   
    XDC Tools 2.93.01   
    DSP/BIOS Link 1.40.05, configured for the DM6446 EVM   
    C6x Code Generation Tools version 6.0.8   
    DSP/BIOS 5.31.05   
    MontaVista Linux v4.0   
    Red Hat Enterprise Linux 3 (SMP)    

因此，我们需要在该Codec Engine安装的DVSDK文件包下面检查上面提到的软件模块和工具是否安装，版本是否正确。否则，可能会编译不过 Codec Engine的例子。那么，什么是 Framework Components，什么是xDAIS，什么又是XDC Tools呢？你可以分别到它们的根目录下浏览它们各自的发布说明文档，做一个总体的了解。   
<!--more-->
这里我们简单介绍一下，可以帮助大家尽快找到和自己相关的重点及资源。   

1） Framework Components是TI提供的一个软件模块，负责DSP侧的memory 和DMA资源管理。因此，DSP算法工程师需要了解这个软件模块。   
http://tiexpressdsp.com/wiki/index.php?title=Framework_Components_FAQ   
2） xDAIS 是一个标准，它定义了TI DSP算法接口的标准。这样大大提高了DSP算法软件的通用性。DSP算法工程师要写出能被ARM通过Codec Engine调用的算法，必须保证自己的算法接口符合这个标准。因此，DSP算法工程师也必须了解这个软件模块。   

http://tiexpressdsp.com/wiki/index.php?title=Category:XDAIS   

3） XDC Tools和gmake类似，是一个工具。XDC根据用户定义的一套build指令，通过调用用户指定的ARM 工具链（Tool Chain）和DSP编译器（C6x Code Generation Tools ）build出ARM侧和DSP侧的可执行文件。可以先不必细究这个工具，只需通过编Codec Engine的例子，知道如何设置build指令就可以了。   

4） DSP/BIOS Link是实现ARM和DSP之间通信的底层软件，Codec Engine就是建立在这个底层软件之上。在修改系统内存分配（缺省是256MB的DDR2）时，DSP/BIOS Link 1.38版本的用户需要修改DSP/BIOS Link的配置文件，并重新build DSP/BIOS Link。而DSP/BIOS Link 1.40版本以后的用户就无需此操作。   

http://tiexpressdsp.com/wiki/index.php?title=DSPLink_Overview   
http://wiki.davincidsp.com/index.php?title=Changing_the_DVEVM_memory_map   

5） C6x Code Generation Tools是Linux环境下C6000系列DSP的编译器。我们用CCS开发DSP时都是用的Windows环境下的DSP编译器。   

6） DSP/BIOS是TI 免费提供的DSP实时操作系统。和上面C6x Code Generation Tools一样，这里的DSP/BIOS也是Linux环境下的版本。DSP系统工程师需要了解这个操作系统。   

http://tiexpressdsp.com/wiki/index.php?title=Category:DSPBIOS   

4．Codec Engine入门第三步，根据自己的角色参考相关的文档和例子进行开发   

开发ARM＋DSP平台需要三类工程师：ARM应用程序工程师、DSP算法工程师和DSP系统工程师。而开发ARM＋协处理器平台只需要ARM应用程序工程师。下面就让我们针对这三类工程师做分别介绍。如果您使用的是TI或TI第三方的编解码算法，就不需要关注DSP算法工程师的部分。如果使用ARM＋协处理器平台，就只需关心ARM应用工程师的部分。   

4．1 DSP算法工程师应该如何着手？   
这里我们不讨论如何开发DSP算法，只讨论DSP算法工程师怎样让自己的算法可以被ARM通过Codec Engine调用。（参考http://www.ti.com/litv/pdf/sprued6c，这个文档会讲到codec package及相关的.xs和.xdc文件，Codec Engine1.20及以上版本的用户可以先不细究这些内容，后面会介绍工具帮您自动生成这些文件。）   

1） 熟悉xDAIS和xDM标准。   
xDM只是xDAIS的扩展，因此，需要先了解xDAIS。在xDAIS 软件包根目录下的发布说明文档里，可以很快找到关于xDAIS和xDM的文档链接。   
http://focus.ti.com/lit/ug/spruec8b/spruec8b.pdf   
在xDAIS安装路径下的examples/ti/xdais/dm/examples/g711有一个g711_sun_internal.c，这个算法不符合xDAIS标准。在同一个路径下的g711dec_sun_ialg.c (decoder)和g711enc_sun_ialg.c (encoder)是封装成符合xDM标准之后的编解码算法。可以通过这个例子学习和了解如何把自己算法封装成符合xDM标准的算法。   
xDAIS 6.10及其以后的版本，包含了一个工具QualiTI，可以检查您的DSP算法是否满足xDAIS标准（但不会检查是否满足xDM）。具体请参考：
http://tiexpressdsp.com/wiki/index.php?title=QualiTI_XDAIS_Compliance_Tool   

2） 熟悉Framework Components。 Framework Components主要包括两个模块DSKT2和DMAN3，它们分别负责DSP侧的memory 和EDMA资源管理。DSP算法使用的memory必须是先向DSKT2提出申请并由DSKT2分配得到的。同样DSP算法使用的EDMA通道也是向DMAN3申请并由DMAN3分配得到的。而关于QDMA的操作，是通过ACPY3这个模块实现的。这样的好处是很容易对DSP侧不同的算法做整合，不同的算法之间不用担心资源（Memory和EDMA）的冲突问题。   
在Framework Components 软件包根目录下的发布说明文档里，可以很快找到相关文档的链接。在Framework Components安装路径下packages\ti\sdo\fc\dman3\examples有一个Fast Copy的例子，可以帮您理解如何基于Framework Components的ACPY3模块实现QDMA的操作。
另外，有些用户DSP侧的算法比较简单，在确保不和ARM侧EDMA资源冲突的前提下在算法里直接操作EDMA不使用DMAN3也是可以的。这样做的弊端是和其它算法做整合时会遇到资源使用冲突的问题。

4．2 DSP系统工程师应该如何着手？   
通常DSP算法工程师都会把自己的符合xDM标准算法编成一个.lib文件（或 .a64P），供DSP系统工程师调用。DSP系统工程师最终build出一个DSP Server（也就是DSP的可执行程序.x64P，和CCS下编译生成的.out类似）。（参考http://focus.ti.com/lit/ug/sprued5b/sprued5b.pdf，这个文档会讲到.xdc和.bld等文件，Codec Engine1.20及以上版本的用户可以先不细究，后面介绍工具帮您自动生成这些文件。）   

1） 如果现在有一个.lib文件（或 .a64P）（算法必须符合xDM标准），如何生成自己的DSP Server呢？下面URL有详细的关于RTSC Codec and Server Package Wizard工具介绍，教您如何把一个.lib文件封装成RTSC Codec 包和RTSC DSP Server包，并最终build出DSP的可执行程序.x64P。   
http://wiki.davincidsp.com/index.php?title=RTSC_Codec_And_Server_Package_Wizards
http://wiki.davincidsp.com/index.php?title=I_just_want_my_video_codec_to_work_with_the_DVSDK   

2） 如果您使用的是Codec Engine 1.20以前的版本，请参考Codec Engine安装路径下examples/servers/video_copy这个例子。这时就需要搞清楚sprued6c.pdf和sprued5b.pdf中提到的.xdc和.xs等文件的功能，也可以在video_copy中的相关文件的基础上修改手动创建出自己的RTSC Codec包和RTSC DSP server包。   

3） 创建好RTSC Codec 和RTSC DSP Server包之后，就是如何build出.x64P的问题了。点击图2所示的Examples，就可以找到build Codec Engine例子的说明文档的链接。按照这个文档做一遍后，就可以对如何build Codec Server有一个清楚的了解。其中关键是修改user.bld和xdcpaths.mak文件，设置Codec Engine依赖的其它软件模块和工具的正确路径。   

4） 如果自己的硬件DDR2大小和例子中的256Mbytes不一致，需要修改DSP的.tcf文件和其他配置。还有些工程师不清楚如何分配memory及如何决定具体段，如：DDRALGHEAP和DDR的大小，以及如何配置./loadmodules里的参数都请参考： http://wiki.davincidsp.com/index.php?title=Changing_the_DVEVM_memory_map。   

4．3 ARM应用程序工程师应该如何着手？   
ARM应用工程师需要调用Codec Engine的VISA API，最终编出ARM侧的可执行程序，因此，必须根据自己的应用学习相关的VISA API、如何创建应用侧Codec Engine的package及配置文件。（参考http://focus.ti.com/lit/ug/sprue67d/sprue67d.pdf，这个文档也涉及到如何调试Codec Engine的内容）。

1）了解ARM应用程序调用Codec Engine的流程、VISA API和其他Codec Engine API。可以参考Codec Engine安装路径下examples/apps/video_copy的例子（较简单）或者DVSDK安装路径下demos里的encode/decode/encodedecode例子（较复杂）。
http://wiki.davincidsp.com/index.php?title=Configuring_Codec_Engine_in_Arm_apps_with_createFromServer
2） 了解ceapp.cfg文件。sprue67d.pdf有相关介绍，可以先读懂   
examples/apps/video_copy/ceapp.cfg。   

3） 用4.2 3)中提到的方法学习如何build ARM侧的可执行程序。   

4） 如何在多线程中调用codec engine，参考：   
http://wiki.davincidsp.com/index.php?title=Multiple_Threads_using_Codec_Engine_Handle   

5）还可以参考以下三个文档了解更多TI demo的ARM应用程序的结构、线程调度等具体的问题。   

EncodeDecode Demo for the DaVinci DVEVM/DVSDK 1.2 (Rev. A) (spraah0a.htm, 8 KB)  
27 Jun 2007 Abstract  

Encode Demo for the DaVinci DVEVM/DVSDK 1.2 (Rev. A) (spraa96a.htm, 8 KB)  
27 Jun 2007 Abstract  

Decode Demo for the DaVinci DVEVM/DVSDK 1.2 (Rev. A) (spraag9a.htm, 8 KB)  
27 Jun 2007 Abstract  

5．使用中常碰到的问题  

1）如果遇到问题可以先访问 http://wiki.davincidsp.com/index.php?title=Codec_Engine_FAQ。  
2）有些工程师没有DSP开发经验，或者暂时没有仿真器通过JTAG调试DSP。可以参考下面网页的内容，先做一个“Hello World”的例程对ARM和DSP如何协同工作有个感性认识。   

http://wiki.davincidsp.com/index.php?title=How_to_build_an_ARM/DSP_Hello_World_program_on_the_DaVinci_EVM   

3） 很多工程师都是参考video_copy的例子，在它的基础上把自己的算法加进去。因为有源代码，这样比较容易。但肯定要根据自己算法的需要修改ARM和DSP之间传递的buffer和参数，重要的是先保证ARM侧的应用程序可以把buffer和参数正确传递到DSP，DSP可以把处理之后的buffer正确的传到ARM侧的应用程序。把这个通路打通之后，就比较容易定位问题是出在ARM应用程序还是DSP侧的算法。另外，参考video_copy例子时注意代码的注释，以便清楚哪一句代码可以删掉哪一句必须要修改或保留。   


如果要扩展xDM的数据结构请参考：   

http://wiki.davincidsp.com/index.php?title=Extending_data_structures_in_xDM。   

4） Codec Engine DSP侧会涉及到Cache一致性的问题。请参考：   
http://wiki.davincidsp.com/index.php?title=Cache_Management   
 
5） 关于Codec Engine系统调试，有以下几种方法：   

        A. 打开Codec Engine trace，通过打印信息看问题出在什么地方。比如engine_open失败，DSP侧不能创建codec 等等。   

            a) Codec Engine 2.0及以上版本，请参考： http://wiki.davincidsp.com/index.php?title=Easy_CE_Debugging_Feature_in_CE_2.0   

            b) Codec Engine 1.x版本，请参考： http://wiki.davincidsp.com/index.php?title=TraceUtil   

        B. ARM应用程序跑起来后，用仿真器连上CCS调试DSP侧程序，参考： http://wiki.davincidsp.com/index.php?title=Debugging_the_DSP_side_of_a_CE_application_on_DaVinci_using_CCS   

        C. 用Soc Analyzer可以做系统调试之外，还可以统计具体函数运行（ARM和DSP侧）时间（benchmark）。请参考： http://tiexpressdsp.com/wiki/index.php?title=SoC_Analyzer    

6） 因为Codec Engine是介于ARM 应用程序和编解码算法中间的软件模块，很多工程师非常想知道它的开销(overhead)，请参考：   
http://wiki.davincidsp.com/index.php?title=Codec_Engine_Overhead   

7）如何在Linux环境下编DSP的汇编或线性汇编程序？   
在Codec Engine安装路径下/packages/config.bld文件里   
var C64P = xdc.useModule(‘ti.targets.C64P’);   
之后添加：   
	C64P.extensions[“.sa”] = {
	suf: “.sa”, typ: “asm:-fl”
	}
或
	C64P.extensions[“.asm”] = {
	suf: “.asm”, typ: “asm:-fa”
	}
8）DSP侧如何统计具体函数运行时间？   
TI DSPC64x+内核有一个64位的硬件定时器（Time Stamp Counter），它的频率和CPU频率一致。   
最简单的办法是使用TSC的低32位TSCL。注意在DM644x中，TSCH用于ARM。   
	#include void main (){
	…
	TSCL=0;
	…
	t1=TSCL;
	my_code_to_benchmark();
	t2=TSCL;
	printf(“# cycles == %d\n”, (t2-t1));
	}

6．结语   

以上针对如何上手TI的Codec Engine做了简单的归纳，还有很多具体细节的问题没有涉及到。还请各位工程师从自己要用的软件模块发布说明文档开始找到相关的文档并研究。经常访问TI的网页，http://wiki.davincidsp.com和http://tiexpressdsp.com/wiki找到最新的信息和资料。也非常欢迎您在wiki上提问。   