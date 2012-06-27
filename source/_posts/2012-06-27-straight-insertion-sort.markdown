---
layout: post
title: "排序算法总结（一）"
date: 2012-06-27 08:00
comments: true
categories: [Software]
tags: [c++,software]
keywords: c++,software,插入排序
description: 排序算法总结（一）插入排序
---
排序算法是在学习数据结构的过程中，必须熟练掌握的。而由于其算法种类比较多，所以总结一下还是有必要的。今天先把插入排序总结下。   
插入排序的基本操作就是将一个数据插入到已经排好序的有序数据中，从而得到一个新的、个数加一的有序数据，算法适用于少量数据的排序，时间复杂度为O(n^2)。是稳定的排序方法。   
##直接插入排序(straight insertion sort)   
每次从无序表中取出第一个元素，把它插入到有序表的合适位置，使有序表仍然有序。   
C/C++代码实现直接插入排序：    
``` c++  插入排序代码(straight insertion sort)
void insert_sort(int a[], int n)
{
	int i, j, temp;
	for (i = 1; i < n; ++i)
	{
		temp = a[i];
		for (j = i; j>0 && temp < a[j - 1]; --j)
		{
			a[j] = a[j - 1];
		}
		a[j] = temp;
	}
} 
```
<!--more-->
##希尔排序 (shell sort)   
概念：先取一个小于n（待排序的数据个数）的整数d1作为第一个增量，把文件的全部记录分成d1个组。把所有距离为d1的倍数的记录放在同一个组中。先在各组内进行直接插入排序，然后，取第二个增量d2<d1重复上述的分组和排序，直至所取的增量dt=1（dt<dt-1<…<d2<d1），即所有记录放在同一组中进行直接插入排序为止。该方法实质上是一种分组直接插入方法。    
``` c++ 希尔排序(shell sort)
//希尔排序
#include <stdio.h>
#define LEN 8
void main (void)
{
	int d=LEN;
	int R[LEN]={76,81,50,22,98,33,12,79};
	int i,j,t=1,temp;
	while(d>0)
	{
	d/=2;
	if(d>0)
	for(int y=0;y<d ;y++)
	{
		for(i=(d+y);i<LEN;i=(i+d))
		{
			if(R[i]<R[i-d])
			{
				temp=R[i];
				j=i-d;
				do{
					printf("%d -> %d,",R[j],R[j+d]);
					R[j+d]=R[j];
					j=j-d;
				}while(j>=0 && temp <R[j]);
				printf("%d -> %d",temp,R[j+d]);
				R[j+d] = temp;
			}
			printf("\n");
			for(int a=0;a<LEN;a++)
			{
				printf("%d",R[a]);
			}
			printf("%d\n",y+1);
			printf("\n");
			}
		printf("\n");
		}
	}
} 
```
本文是查阅书籍和网络资料整理而来，转载请注明出处。并以超链接的形式注明本文地址：`http://tinyxd.me/blog/2012/06/27/straight-insertion-sort/ `  
下一节更新交换排序。
