---
layout: post
title: Notes of APUE 2
---

#{{ page.title }}  
<p class="meta">22 Sep 2014 - Guangzhou</p>   
+++++++++++++++++  

###[返回主目录][]  
<br>

##Chapter 2: UNIX标准化及实现
1. 引言
2. UNIX标准化
    1. ISO C  
　　1989年，C程序设计语言的ANSI（American National Standards Institute）标准X3.159-1989得到批准(ANSI 1989)。此标准已被采用为国际标准ISO/IEC 9899:1990。1999年，ISO C被更新为ISO/IEC 9899:1999，改善了对数值处理的支持。  
　　ISO C标准的意图是提供C程序在不同OS的可移植性。  
　　按照ISO C标准定义的各个头文件（header），可将ISO C库分成24个区。下表列出了C标准定义的各个头文件。  
    ![img][2.2.1]
    2. IEEE POSIX   
　　POSIX是一系列由IEEE（Institute of Electrical and Electronics Engineers）制定的标准，POSIX（Portable Operating System Interface）是指可移植的操作系统接口。  
　　本书使用POSIX.1，下面4个表总结了POSIX.1指定的必需和可选的头文件。因为POSIX.1包含ISO C标准库函数，所以还需要ISO C中列出的头文件。  
　　下表为POSIX标准定义的必需的头文件  
    ![img][2.2.2.1]  
　　下表为POSIX标准定义的XSI扩展头文件  
    ![img][2.2.2.2]  
　　下表为POSIX标准定义的可选头文件  
    ![img][2.2.2.3]  
　　POSIX接口可以分为必需接口和可选接口，可选接口按功能又进一步分成50个区，下表总结了没有被弃用的编程接口  
    ![img][2.2.2.4]  
    3. Single UNIX Specification  
　　Single UNIX Specification（单一UNIX规范）是POSIX.1标准的一个超集，它定义了一些附加的接口，这些接口扩展了POSIX.1规范所提供的功能。相应的系统接口全集被称为X/open系统接口（XSI，X/Open System Interface）。XSI还定义了必须支持POSIX.1中的哪些可选部分才能认为是遵循XSI的（上表中的SUS强制要求），只有遵循XSI的实现才能成为UNIX系统。  
    4. FIPS  
　　FIPS的含义是联邦信息处理标准（Federal Information Processing Standard），它是由美国政府出版，用于计算机系统的采购
3. UNIX系统实现  
　　UNIX主要有三个分支：  
　　@ AT&T分支，导出了系统Ⅲ和系统Ⅴ（被称为UNIX的商用版本）  
　　@ 加州大学伯克利分校分支，导出了4.xBSD实现。  
　　@ AT&T贝尔实验室的UNIX研究版  
    1. SVR4（UNIX System V Release 4）, AT&T的UNIX系统实验室产品
    2. 4.4BSD（Berkeley Software Distribution）加州大学伯克利分校的计算机系统研究组研究开发和分发
    3. FreeBSD  
　　加州大学伯克利分校的计算机系统研究组决定终止其在UNIX操作系统的BSD版本上的研发中作后，设立了FreeBSD项目。
    4. Linux
　　其实不是UNIX，Linus Torvalds在1991年为替代MINIX而研发的
    5. Mac OS X，核心操作系统为Darwin，基于Mach内核和FreeBSD OS的组合
    6. Solaris，Sun公司开发的UNIX版本
    7. 其他UNIX系统
        * AIX， IBM版的UNIX系统
        * HP-UX， HP版
        * IRIX， Silicon Graphics版的UNIX
        * Unix Ware, SVR4衍生的UNIX系统  
4. 标准和实现的关系
5. 限制  
　　UNIX使用以下两种类型的限制：  
　　@ 编译时限制（例如：短整型最大值是多少？）  
　　@ 运行时限制（例如：文件名可以有多少个字符？）  
　　对于上面的2种限制具体是怎么实现的呢：  
　　@ 编译时限制（使用头文件）  
　　@ 不与文件或目录相关联的运行时限制（使用sysconf函数）  
　　@ 与文件或目录相关联的运行时限制（使用pathconf函数和fpathconf函数）  
    1. ISO C限制
    2. POSIX限制
    3. XSI限制
    4. sysconf、pathconf和fpathconf函数
    5. 不确定的运行时限制
        1. 路径名
        2. 最大打开文件数
6. 选项
7. 功能测试宏
8. 基本系统数据类型，头文件`<sys/type.h>`定义，大多数以`_t`结尾，如`dev_t`,`pid_t`,`size_t`,`time_t`等等，具体含义如下表所示  
    ![img][2.8]
9. 标准之间的冲突
10. 小结；本章对ISO C, POSIX和Single UNIX Specification三个标准进行说明，以及这些标准对各种UNIX OS的影响。标准化工作的重要部分是说明“各种实现定义的各种**限制**”

<br>

[返回主目录]: /2014/09/22/notes-of-apue.html

[2.2.1]: /images/apue/2.2.1.png "iso c"
[2.2.2.1]: /images/apue/2.2.2.1.png
[2.2.2.2]: /images/apue/2.2.2.2.png
[2.2.2.3]: /images/apue/2.2.2.3.png
[2.2.2.4]: /images/apue/2.2.2.4.png
[2.8]: /images/apue/2.8.png "primitive system data type"
