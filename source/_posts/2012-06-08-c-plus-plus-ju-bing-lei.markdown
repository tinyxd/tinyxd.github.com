---
layout: post
title: "读C++ Primer 之句柄类"
date: 2012-06-08 20:28
comments: true
categories: software
tags: [c++ , 句柄]
keywords: c++ primer,句柄
description: C++ Primer 的句柄类总结
---

转自Linux社区 作者：xizero00：http://www.linuxidc.com/Linux/2011-08/40175.htm

我们知道C++中最令人头疼的当属指针，如果您申请了对象却没有释放它，时间一长就会造成系统崩溃，大量的内存溢出使得您的程序的健壮性出现问题

而句柄类就是为了能够解决这一问题而出现的，句柄类有点类似于智能指针。

好了，废话不多说，我们来看代码
<!--more-->
首先我们来看 sample.h文件的代码：
``` c++
/*
* author:xizero00
* mail:xizero00@163.com
* date:2011-08-07 20:11:24
* Handle Class Sample  句柄类示例
*/  

#ifndef SAMPLE_H
#define SAMPLE_H   

#include <iostream>
#include <stdexcept>
using namespace std;  

//基类
class Item_base
{
public:
    //基类的虚函数,用于智能地复制对象
    virtual Item_base* clone() const
    {
        return new Item_base( *this );
    }
};  

//子类
class Bulk_item: public Item_base
{
    //子类的虚函数的重载,用于智能地复制对象
    virtual Bulk_item* clone() const
    {
        return new Bulk_item( *this );
    }
};  

//子类的子类
class Sales_item: public Bulk_item
{
public:
    //默认构造函数,用来初始化一个引用计数器
    Sales_item(): p( 0 ) , use( new size_t( 1 ) ) { cout << "Sales_item的引用计数器初始化为1" << endl; }  

    //带有一个参数的,且该参数为基类引用的构造函数
    Sales_item( const Item_base& );  

    //复制构造函数,需要注意的是，每复制一次就需要增加引用计数一次
    Sales_item( const Sales_item &i ): p( i.p ) , use( i.use ) { ++*use; cout << "由于采用了复制构造函数,Sales_item类型的对象引用计数为:" << *use << endl;} //也可以这样写
    //Sales_item( const Sales_item &i ): p( i.clone() ) , use( new size_t( 1 ) ) { ++*use; }   

    //析构函数,析构的时候会判断是否能够释放指针所指向的数据
    ~Sales_item() { cout << "在析构函数中:"; decr_use(); }  

    //赋值操作符重载
    Sales_item& operator= ( const Sales_item& );  

    //访问操作符重载
    const Item_base* operator-> () const
    {
        if( p )
        {
            return p;
        }
        else
        {
            throw logic_error( "p指针错误" );
        }
    }  

    //解引用操作符重载
    const Item_base& operator* () const
    {
        if( p )
        {
            return *p;
        }
        else
        {//重载虚函数,用于智能地复制对象
            throw logic_error( "p指针错误" );
        }
    }  

    //重载虚函数,用于智能地复制对象
    /*
    virtual Sales_item* clone() const
    {
        return new Sales_item( *this );
    }
    */  

private:
    //两个指针存储着引用计数器以及数据的指针
    Item_base *p;
    size_t *use;  

    //减少引用
    void decr_use()
    {
        cout << "在 dec_use函数中引用计数减少了,当前计数值为:" << *use - 1 << endl;
        if( --*use == 0 )
        {
            delete p;
            delete use;
            cout << "在 dec_use函数中计数器减为0,释放对象" << endl;
        }  

    }
};  

//赋值操作符重载,每次复制都会增加引用计数
Sales_item& Sales_item::operator= ( const Sales_item &si )
{
    cout << "由于采用类赋值操作,";
    cout << "被赋值的对象的引用计数为:" << *si.use ;
    cout << "即将被赋值的对象的引用计数为:" << *use << endl;
    //这里需要特别注意的就是待复制的对象的计数器需要加1而被赋值的对象需要减1     

    //增加被复制对象的引用计数
    ++*si.use;
    cout << "被赋值的对象的赋值之后的引用计数为:" << *si.use << endl;
    //将即将被赋值的对象的引用计数减1
    decr_use();
    cout << " 即将被赋值的对象赋值之后的引用计数为:" << *use << endl;  

    //复制指针
    p = si.p;
    use = si.use;  

    //返回
    return *this;
}  

#endif //SAMPLE_H

接下来我们来看sample.cc的代码：

/*
* author:xizero00
* mail:xizero00@163.com
* date:2011-08-07 20:11:24
*/
#include "sample.h"
int main( int argc , char **argv )
{
    //重点关注i1和i2的引用计数
    Sales_item i1 , i2;//i1和i2的引用计数分别为1
    Sales_item i3( i1 );//i1的引用计数变为2
    Sales_item i4 = i1;//i1的引用计数变为3,因为这样还是调用的复制构造函数
    i4 = i2; // i2的引用计数变为2   

    return 0;
}
```
下面给出编译所需的Makefile
```
# author:xizero00
# mail:xizero00@163.com
# date:2011-08-08 00:51:25
install:
    g++ sample.cc -g -o sample
    ls -al sample*
    ./sample
clean:
    rm -f sample
    ls -al sample*
```
注意：代码是在linux下编译，您只需要将三个文件放在同一个目录，然后在当前目录打开终端，输入make，就可以查看到结果。

如果您想清理生成的文件 输入make clean即可

下面是我执行的结果：

    Sales_item的引用计数器初始化为1
    Sales_item的引用计数器初始化为1
    由于采用了复制构造函数,Sales_item类型的对象引用计数为:2
    由于采用了复制构造函数,Sales_item类型的对象引用计数为:3
    由于采用类赋值操作,被赋值的对象的引用计数为:1即将被赋值的对象的引用计数为:3
    被赋值的对象的赋值之后的引用计数为:2
    在 dec_use函数中引用计数减少了,当前计数值为:2
     即将被赋值的对象赋值之后的引用计数为:2
    在析构函数中:在 dec_use函数中引用计数减少了,当前计数值为:1
    在析构函数中:在 dec_use函数中引用计数减少了,当前计数值为:1
    在析构函数中:在 dec_use函数中引用计数减少了,当前计数值为:0
    在 dec_use函数中计数器减为0,释放对象
    在析构函数中:在 dec_use函数中引用计数减少了,当前计数值为:0
    在 dec_use函数中计数器减为0,释放对象

 

结论：我们可以看到，句柄类能够很方便并且能够很安全地释放内存，不会导致内存的泄露。
