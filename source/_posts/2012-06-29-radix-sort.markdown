---
layout: post
title: "排序算法总结（四）"
date: 2012-06-29 23:28
comments: true
categories: software
tags: [c++,software,sort]
keywords: c++,software,基数排序
description: 排序算法总结（四）基数排序
---
“基数排序法”属于“分配式排序”（distribution sort），基数排序法又称“桶子法”（bucket sort）或bin sort ，它是通过键值的部分资讯，将要排序的元素分配至某些“桶”中，借以达到排序的作用。基数排序法是属于稳定性的排序，其时间复杂度为O（nlog(r)m），其中r为所采用的基数，而m为堆数。在某些时候，基数排序法的效率高于其他的比较性排序。   
什么是基数排序： 基数排序也称桶排序，是一种当关键字为整数类型时的一种非常高效的排序方法。基数排序算法进出桶中的数据元素序列满足先进先出的原则（桶实际就是队列）。    
<!--more-->
###c语言实现基数排序
``` c c语言实现基数排序
#include <stdio.h>
#include <stdlib.h>
int main()
{
	int data[10]={73,22,93,43,55,14,28,65,39,81};
	int temp[10][10]={0};
	int order[10]={0};
	int i,j,k,n,lsd;
	k=0;n=1;
	printf("\n排序前: ");
	for (i=0;i<10;i++) printf("%d ",data[i]);
	putchar('\n');
	while (n<=10)
	{
		for (i=0;i<10;i++){
		lsd=((data[i]/n)%10);
		temp[lsd][order[lsd]]=data[i];
		order[lsd]++;
		}
		printf("\n重新排列: ");
		for (i=0;i<10;i++){
			if(order[i]!=0)
			for (j=0;j<order[i];j++){
				data[k]=temp[i][j];
				printf("%d ",data[k]);
				k++;
			}
			order[i]=0;
		}
		n*=10;
		k=0;
	}
	putchar('\n');
	printf("\n排序后: ");
	for (i=0;i<10;i++) printf("%d ",data[i]);
	return 0;
}
```   
###c++实现基数排序
``` c++ c++实现基数排序
int maxbit(int data[],int n) //辅助函数，求数据的最大位数
{
	int d = 1; //保存最大的位数
	int p =10;
	for(int i = 0;i < n; ++i)
	{
		while(data[i] >= p)
		{
		p *= 10;
		++d;
		}
	}
	return d;
}

void radixsort(int data[],int n) //基数排序
{
	int d = maxbit(data,n);
	int * tmp = new int[n];
	int * count = new int[10]; //计数器
	int i,j,k;
	int radix = 1;
	for(i = 1; i<= d;i++) //进行d次排序
	{
		for(j = 0;j < 10;j++)
		count[j] = 0; //每次分配前清空计数器
		for(j = 0;j < n; j++)
		{
			k = (data[j]/radix)%10; //统计每个桶中的记录数
			count[k]++;
		}
		for(j = 1;j < 10;j++)
			count[j] = count[j-1] + count[j]; //将tmp中的位置依次分配给每个桶
		for(j = n-1;j >= 0;j--) //将所有桶中记录依次收集到tmp中
		{
		k = (data[j]/radix)%10;
		mp[count[k]] = data[j];
		tcount[k]--;
		} 
		for(j = 0;j < n;j++) //将临时数组的内容复制到data中
			data[j] = tmp[j];
		radix = radix*10;
	}
	delete [] tmp;
	delete [] count;
}
```
实现基数排序算法时，有基于顺序队列和基于链式队列两种不同的实现方法。基于链式队列的实现中可以把桶设计成一个队列数组QueueArray，数组的每个元素中有两个域，一个队首指针（front）和一个队尾指针（rear）。 
本文是查阅书籍和网络资料整理而来，转载请注明出处。并以超链接的形式注明本文地址：   
`http://tinyxd.me/blog/2012/06/28/radix-sort/`   
下一节更新归并排序。