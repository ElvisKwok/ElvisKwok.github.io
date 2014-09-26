---
layout: post
title: Notes of APUE 0
---

#{{ page.title }}  
<p class="meta">22 Sep 2014 - Guangzhou</p>   
+++++++++++++++++  
<br>


*ps: apue.h设置，在[apue官网][]下载所有实例代码，并将`apue.2e/include/apue.h`和`apue/lib/error.c`复制到`/usr/lib/`,然后在`/usr/lib/apue.h`末尾添加`#include "error.c"`*  

#outline
* UNIX基本概念(1)，各种UNIX标准化工作(2)
* I/O
    * 不带缓冲的I/O(3)
    * 文件和目录(4)
    * 标准I/O库(5)
    * 标准系统数据文件(6)
* 进程
    * 进程的环境(7)
    * 进程控制(8)
    * 进程之间的关系(9)
    * 信号(10)
    * 线程(11, 12)
* 更多的I/O
    * 终端I/O(18)
    * 高级I/O(14)
    * 守护进程(13)
* IPC
    * 进程间通信(15)
    * 网络IPC: 套接字(16)
    * 高级进程间通信(17)
* 实例
    * 数据库的函数库(20)
    * 打印机通信(21)
    * 伪终端(19)  
<br>  

[apue官网]: http://www.apuebook.com

[1.2]: /images/apue/1.2.png "unix architecture"
[1.11]: /images/apue/1.11.png "diff between library function and system call"
[2.2.1]: /images/apue/2.2.1.png "iso c"
[2.2.2.1]: /images/apue/2.2.2.1.png
[2.2.2.2]: /images/apue/2.2.2.2.png
[2.2.2.3]: /images/apue/2.2.2.3.png
[2.2.2.4]: /images/apue/2.2.2.4.png
[2.8]: /images/apue/2.8.png "primitive system data type"
[3.9]: /images/apue/3.9.png "BUFFSIZE influence efficiency"
[3.10.1]: /images/apue/3.10.1.png "file sharing"
[3.10.2]: /images/apue/3.10.2.png "file sharing"
[3.12]: /images/apue/3.12.png "dup"
[4.2]: /images/apue/4.2.png "struct stat"
