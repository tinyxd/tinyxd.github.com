---
layout: post
title: "排序算法总结（五）"
date: 2012-07-01 23:45
comments: true
categories: software
tags: [c++,software,sort]
keywords: c++,software,归并排序
description: 排序算法总结（五）归并排序
---
归并（Merge）排序法是将两个（或两个以上）有序表合并成一个新的有序表，即把待排序序列分为若干个子序列，每个子序列是有序的。然后再把有序子序列合并为整体有序序列。   
归并排序是建立在归并操作上的一种有效的排序算法。该算法是采用分治法（Divide and Conquer）的一个非常典型的应用。   
将已有序的子序列合并，得到完全有序的序列；即先使每个子序列有序，再使子序列段间有序。若将两个有序表合并成一个有序表，称为2-路归并。   
与快速排序比较：归并排序是稳定的排序.即相等的元素的顺序不会改变。如输入记录 1(1) 3(2) 2(3) 2(4) 5(5) (括号中是记录的关键字)时输出的 1(1) 2(3) 2(4) 3(2) 5(5) 中的2 和 2 是按输入的顺序。这对要排序数据包含多个信息而要按其中的某一个信息排序，要求其它信息尽量按输入的顺序排列时很重要。这也是它比快速排序优势的地方.。   
<!--more-->
用途：   
1、排序   
速度仅次于快速排序，但较稳定。   
2、求逆序对数   
具体思路是，在归并的过程中计算每个小区间的逆序对数，进而计算出大区间的逆序对数（也可以用树状数组来求解）。   
c语言实现    
输入参数中，需要排序的数组为array[],起始索引为first，终止索引为last。调用完成后，array[]中从first到last处于升序排列。    
``` c 归并算法（Merge sort）
void MergeSort(int array[], int first, int last)
{
	int mid = 0;
	if(first<last)
	{
		mid = (first+last)/2;
		MergeSort(array, first, mid);
		MergeSort(array, mid+1,last);
		Merge(array,first,mid,last);
	}
} 
```
本文是查阅书籍和网络资料整理而来，转载请注明出处。并以超链接的形式注明本文地址：   
`http://tinyxd.me/blog/2012/07/01/merge-sort/`   

