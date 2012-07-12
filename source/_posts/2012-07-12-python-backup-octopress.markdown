---
layout: post
title: "本地备份octopress"
date: 2012-07-12 22:42
comments: true
categories: python
tags: [python,linux,octopress]
keywords: python,linux,octopress,脚本,备份
description: 本地备份octopress，用python编写
---
用python脚本备份octopress，当然也可以备份其他的目录。只要修改对应路径就可以了。
``` python octopress_backup.py
#!/usr/bin/python2
# Filename: octopress_backup.py

import os
import time

# 1. 需要备份的目录(也可以将其他的文件夹一起打包)
source = ['/home/tiny/octopress', '/home/tiny/mytest']

# 2. 备份的目标位置
target_dir = '/home/tiny/backup/' # Remember to change this to what you will be using

# 3. 本脚本备份成tar，当然也可以压缩gzip。
# 4. 日期是目录名
today = target_dir + time.strftime('%Y%m%d')
# 当前时间是备份文件的名称
now = time.strftime('%H%M%S')

# 可以对备份的文件进行一些说明
comment = raw_input('Enter a comment --> ')
if len(comment) == 0: # check if a comment was entered
    target = today + os.sep + now + '.tar'
else:
    target = today + os.sep + now + '_' +\
        comment.replace(' ', '_') + '.tar'

# 创建子文件夹
if not os.path.exists(today):
    os.mkdir(today) # make directory
    print 'Successfully created directory', today

# 5. tar压缩命令（unix/linux）
tar_command = "tar -cvf '%s' %s" % (target, ' '.join(source))

# 运行备份命令
if os.system(tar_command) == 0:
    print 'Successful backup to', target
else:
    print 'Backup FAILED'

```
<br />
本站文章如果没有特别说明，均为**原创**，转载请以**链接**方式注明本文地址：<http://tinyxd.me/blog/2012/07/12/python-backup-octopress/>

