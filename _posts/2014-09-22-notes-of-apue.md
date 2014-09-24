---
layout: post
title: Notes of APUE
---

#{{ page.title }}  
<p class="meta">22 Sep 2014 - Guangzhou</p>   

========================================================  
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

#chapter 1: UNIX基础知识
1. 引言
2. UNIX体系结构  
    ![img][1.2]
3. 登录
    1. 登录名
    2. shell；**命令解释器**，读取用户输入（终端交互、shell脚本），然后执行命令
4. 文件和目录
    1. 文件系统：**“目录+文件”**组成的层次结构；目录是一个包含n个**“目录项”**，目录项包含文件名+文件属性信息（这是逻辑视图上，实际存储不是这样）；`stat`和`fstat`函数返回包含文件属性的一个信息结构
    2. 文件名
    3. 路径名；  
       ls命令的简单实现

       ```
       struct dirent *dirp = opendir(argv[1]);  
       while((dirp = readdir(dp) != NULL)   
            printf("%s\n", dirp->d_name);   
       ```
    4. 工作目录（current）
    5. 起始目录（登陆时的工作目录）
5. 输入和输出
    1. 文件描述符（file descriptor）;非负整数，内核用它标识一个特定进程正在访问的文件
    2. 标准输入、输出、出错（这是运行任何程序时shell打开的三个**文件描述符**）
    3. 不同缓冲的I/O；函数`open`,`read`,`write`,`lseek`,`close`；自定义BUFFSIZE，缓存由内核负责（并非没有缓存）
    4. 标准I/O；带缓冲的接口，无需担心最佳缓冲区大小，使用缓冲区进行输入输出；如`<stdio.h>`的`printf`；用标准I/O将`stdin`复制到`stdout`，从而实现文件复制，`c = getc(stdin); putc(c, stdout);`
6. 程序与进程
    1. 程序：存放在磁盘的可执行文件，由内核将程序读入存储器（使用`exec`函数）
    2. 进程（程序的执行实例），进程ID（唯一的数字标识符，非负整数，`getpid()`）
    3. 进程控制（3个函数）：`fork`(创建新进程，向父进程返回新子进程的进程ID，向子进程返回0)、`exec（执行命令）`、`waitpid（可以用来实现父进程等待子进程的种植）`; shell程序的简单实现（从标准输入读命令并执行）；`if(buf[strlen(buf) -1] == '\n')`,`pid_t pid = fork();`,`execlp(buf, buf, (char *)0);`
    4. 线程和线程ID；**一个进程内**的所有线程共享同一地址空间、文件描述符、栈以及与进程相关的属性，能访问同意存储区，访问共享数据时需要采取同步措施
7. 出错处理；errno整型变量；出错恢复（致命性：无法恢复，最多print出错信息；非致命性：例如资源紧缺，可延迟再试）
    打印出错信息的两个函数  
    
    ```
    #include <string.h>  
    char *strerro(int errnum);  /* 返回值：指向消息字符串的指针 */  
    ```  

    ```
    #include <stdio.h>  
    void perro(const char *msg);    /* 输出msg字符串： errno值对应的出错信息 */  
    ```
8. 用户标识  
    1. 用户ID；`getuid()`
    2. 组ID；`getgid()`
    3. 附加组ID
9. 信号；通知进程已经发生某种情况的一种技术；编写sign_int函数
10. 时间值；   
    日历时间（国际标准时间UTC）
    进程时间（CPU时间）：时钟时间（进程运行时间总量，与同时运行的进程数有关）、用户CPU时间（用户指令）、系统CPU时间（内核程序）
11. 系统调用和库函数  
    系统调用：程序向内核请求服务，OS所提供的进入内核的**入口点**　　
    库函数可替换，系统调用不能替换；malloc**函数**（用户层次）， sbrk**系统调用**（内核层次）  
    区别：从用户的角度来看，它们都可以通过C来调用；从实现的角度来看，系统调用是操作系统内核提供的服务，库函数则一般基于系统调用实现；系统调用提供**最小接口**，库函数提供比较复杂的功能  
    ![img][1.11]  

<br>

#chapter 2: UNIX标准化及实现
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
   AT&T分支，导出了系统Ⅲ和系统Ⅴ（被称为UNIX的商用版本）  
   加州大学伯克利分校分支，导出了4.xBSD实现。  
   AT&T贝尔实验室的UNIX研究版  
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
    编译时限制（例如：短整型最大值是多少？）  
    运行时限制（例如：文件名可以有多少个字符？）  
    对于上面的2种限制具体是怎么实现的呢：  
    编译时限制（使用头文件）  
    不与文件或目录相关联的运行时限制（使用sysconf函数）  
    与文件或目录相关联的运行时限制（使用pathconf函数和fpathconf函数）  
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
10. 小结；本章对ISO C, POSIX和Single UNIX Specification三个标准进行说明，以及这些标准对各种UNIX OS的印象。标准化工作的重要部分是说明“各种实现定义的各种**限制**”

<br>

#chapter 3: 文件I/O
1. 引言  
    5个文件I/O函数：`open`，`read`，`write`，`lseek`，`close`，不同缓冲区长度对read和write的影响  
    本章所说明的函数被称为**不带缓冲的I/O**（unbuffered I/O），**不带缓冲**指的是每个read和write都调用内核的一个系统调用。不带缓冲的I/O函数不是ISO C的组成成分，是POSIX.1和Single UNIX Specification的组成部分  
    原子操作，通过文件I/O和open函数的参数来讨论；多进程共享文件，涉及的内核数据结构；`dup`，`fcntl`，`sync`，`fsync`和`ioctl`函数  
2. 文件描述符  
    使用open或creat时，内核向进程返回fd，作为参数传给read或write
    0、1、2分别与stdin、stdout、stderr关联,头文件`<unistd.h>`分别定义为常量`STDIN_FILENO`, `STDOUT_FILENO`和`STDERR_FILENO`  
3. open函数  

    ```
    #include <fcntl.h>  
    int open(const char *pathname, int oflag, ...);  
    ```   
    oflag可为O_RDONLY,O_WRONLY,O_RDWR，还有其他可选参数，这些常量在`<fcntl.h>`定义  
    返回最小的未用描述符数值  
4. creat函数  

    ```
    #include <fcntl.h>  
    int creat(const char *pathname, mode_t mode);  
    ```  
    等效于`open(pathname, O_WRONLY | O_CREAT | O_TRUNC, mode)`  
    creat缺点：只能以*只写方式*打开创建的文件，如果要先写后读，只能调用creat,再close,再调用open。现在可以这样`open(pathname, O_RDWR | O_CREAT |O_TRUNC, mode)`  
5. close函数  

    ```
    #include <unistd.h>  
    int close(int fd);  
    ```   
    关闭文件还会释放*加在文件上的所有记录锁*  
    进程终止，内核自动关闭该进程打开的文件
6. lseek函数  
    **当前文件偏移量**  

    ```
    #include <unistd.h>  
    off_t lseek(int fd, off_t offset, int whence);  
    /* 返回值： 成功则返回新的文件偏移量，否则返回-1 */  
    ```   
    whence可为: 
    * `SEEK_SET`(0, 最终偏移量=文件开始+offset)   
    * `SEEK_CUR`(1, 最终偏移量=当前位置+offset)  
    * `SEEK_END`(2, 最终偏移量=文件末尾+offset)  
    文件**空洞**：文件偏移量大于文件当前长度，导致下一次写文件将加长该文件，并在文件中构成一个空洞（**原文件末端与新开始写的部分**），（位于文件中但没写过的字节被读为0，用od -c 该文件显示为'\0'），空洞不分配磁盘块，但是空洞后新写入的数据需要分配磁盘块
7. read函数  

    ```
    #include <unistd.h>
    ssize_t read(int fd, void *buf, size_t nbytes);
    /* 返回值：成功返回读到的字节数,到达文件末尾返回0，出错返回-1 */
    ```  
    e.g.: 离文件末尾剩余30字节，要求读100字节，则read返回30，下一次调用read时返回0
8. write函数  
    
    ```
    #include <unistd.h>
    ssize_t write(int fd, const void *buf, size_t nbytes);
    /* 返回值：成功返回已写字节数，出错返回-1 */
    ```  
    返回值通常与nbytes相等，否则表示出错  
    write出错常见原因：磁盘已写满，或者超过一个给定进程的文件长度限制   
    read和write都是从**打开的文件**的**当前**偏移量开始read/write，结束后文件偏移量增加**实际**read/write的字节数  
9. I/O的效率  
    选取不同的BUFFSIZE产生CPU时间不同，如下表所示，其中系统CPU时间最小值出现在BUFFSIZE=4096处  
    ![img][3.9]
10. 文件共享  
    内核使用三种**数据结构**表示打开的文件：  
    * 文件描述符表（进程表项）：每个fd关联fd标志和指向一个文件表项的指针
    * 文件表(其中文件状态标志可为read，write，append，同步和非阻塞等)
    * v节点表  
    下图为一个进程打开两个**不同**的文件（fd分别为0、1），同一个进程表项的两个fd、两个文件表项、两个v节点表项  
    ![img][3.10.1]  
    下图为两个独立进程各自打开**同一个**文件，两个进程表项的两个fd（3，4）、两个文件表项(使得每个进程都有它自己的该文件当前偏移量)、同一个v节点表项  
    ![img][3.10.2]  
    多个文件描述符可能指向同一个文件表项，e.g.: dup函数、fork的父子进程对于每一个打开的文件描述符共享一个文件表项  
11. 原子操作






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
