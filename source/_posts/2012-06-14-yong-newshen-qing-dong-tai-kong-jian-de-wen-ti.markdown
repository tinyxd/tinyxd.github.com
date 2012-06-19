---
layout: post
title: "用new申请动态空间的问题"
date: 2012-06-14 07:27
comments: true
categories: [Software programming]
keywords: software , new ,Dynamic space, 动态空间
description: 用new申请动态空间的问题.Apply for dynamic space using "new".
---
先分析一下new的分配：

1.T\*   p   =   new   T;  ···   delete   p;
等价于
T\*   p   =   new   T[1]; ··· delete[]   p;

2.int   (*p)[n]   =   new   int[m][n];这种方式是可行的

3.所以new一个3x3的数组，也就是T   =   int[3][3] ，  那么可以这样写：
int   (*p)[3][3]   =   new   int[1][3][3];     删除时请调用delete[]   p;   
<!--more-->
4.int** a；很容易造成内存泄漏最好不要用。

下面是自己写的一个test：
``` c++
#include <iostream>

using namespace std;
int main()

{
	size_t m=10;
	int (*p)[10]=new int[m][10]();
	for(size_t i=0;i!=10;++i)
		for(size_t j=0;j!=10;++j)
		{
			cout<< p[i]+j <<endl;

		}
	cout<<sizeof(p)<<endl;
	delete  [] p;
	return 0;

}
```

还有一个问题是 ，c++中new的空间地址是连续的么？？

由于学习过linux内核，经过分析，有些时候是虚拟地址是连续的，而物理地址是不连续的。由于在内核中需要申请连续的物理地址空间的时候，使用类似kmalloc（）的函数，这样的话，如果size比较小的话，申请成功的概率还算高（尤其是刚开机不久），而申请大内存的话就有可能申请失败。申请虚拟地址的时候用vmalloc（），这个只能确保在虚拟地址上是连续的，而不能保证在物理地址是连续的，但是这个可以申请比较大的空间。

而看到网上说不同的操作系统会有不同的内存管理机制，而至于windows是咋样的，还需要进一步查找资料。

下面是转载的如何申请连续的地址空间（c++）（http://blog.csdn.net/zhongshengjun/article/details/4632156）：
>    地址连续的二维数组在C语言数值计算中有重要意义，很多二维数组的算法是基于一维数组写的。另外，在序列化时或内存复制时，连续空间易于进行整块内存的操作。

>    子程序说明：

>    1- Array2D和FreeArray2D可实现地址连续的动态二维数组的地址分配和释放。

 >   2- 作为对照，下面给出了地址不连续的二维数组地址分配与释放的子程序。
>    
``` c++
    // 创建 n X m 的动态数组，该数组的元素地址在内存中是连续的
    // n - 输入参数，数组的行数
    // m - 输入参数，数组的列数
    // 返回，double **，指向指针的指针，用于以二维数组的方式访问一段内存。
    double **Array2D(int n,int m)
    {
     // 建立数组的存储区，即在内存中分配一片连续的空间，元素个数为 n*m，
     // 返回指向double的指针。
        double *Array1D=new double[n*m];
     // 建立数组的索引区，返回指向 double *的指针（指向指针的指针），长度为 n。
        double **Array2D=new double* [n];
     // 将索引区的每个元素指向数据存储区对应元素的地址，Array2D[0] 指向 Array1D[0]，
     // Array2D[1] 指向 Array1D[m]，其余类推。
        for(int i=0;i<n;i++)
        {
         Array2D[i]=&Array1D[i*m];
        }
        return Array2D;
    }

    // 释放数组的空间，首先释放一维数组占用的n*m个double空间
    // 再释放索引数组（指针数组）占用的n个double*空间
     void FreeArray2D(double **Array2D)
    {
      delete[] Array2D[0];
      delete[] Array2D;
    }

    // 二维数组空间分配，地址一般不连续，不是推荐的方法
     double **Array2D_A(int n,int m)
    {
     // 建立数组的索引区，返回指向 double *的指针（指向指针的指针），长度为 n。
        double **Array2D=new double* [n];

     // 建立数组的存储区，对于Array2D的每一个指针元素，分配m个double空间
        for(int i=0;i<n;i++)
         Array2D[i]=new double[m];

        return Array2D;
    }

    // 释放数组的空间，与Array2D_A配套使用

    // 首先释放n个一维数组（每个占用m个double空间）
    // 再释放索引数组（指针数组）占用的n个double*空间
     void FreeArray2D_A(double **Array2D,int n)
    {
        for(int i=0;i<n;i++)
        delete[] Array2D[i];
      delete[] Array2D;
    }
```
>
