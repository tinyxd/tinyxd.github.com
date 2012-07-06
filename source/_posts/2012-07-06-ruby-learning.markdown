---
layout: post
title: "ruby初学"
date: 2012-07-06 23:43
comments: true
categories: ruby
tags: ruby
keywords: ruby,脚本语言
description: ruby初学总结
---
这几天在学习Ruby，面对一个陌生的脚本语言，虽然陌生但是既然是脚本语言，自然也有与shell类似的地方，所以学习起来困难不是很大。   
在感受到脚本语言的方便后，试了个例子，如下计算一个文件中单词的个数，以空格来区分。   
``` ruby 统计单词个数ruby脚本word.rb
#计算单词个数
count = Hash.new(0)

##统计单字
while line = gets
words = line.split
words.each{|word|
count[word] += 1
}
end

##输出结果
count.sort{|a,b|
a[1] <=> b[1]
}.each{|key,value|
print "#{key}: #{value}\n"
}
```
用法：`ruby word.rb your_file`
<!--more-->
还有个问题以后可能会经常遇到，用p方法来输出包括日文或者中文的字符串的时候，会发生一般所谓的“乱码”的输出结果。所以在执行ruby程序时需要加上-Ks、-Ke之类的环境参数，这些参数用来指定文字编码。针对中文字符串，可以制定-Ku参数（UTF-8）来取得正常的显示效果。   
<br />
本站文章如果没有特别说明，均为**原创**，转载请以**链接**方式注明本文地址：`http://tinyxd.me/blog/2012/07/06/ruby-learning/`