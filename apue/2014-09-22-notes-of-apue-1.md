---
layout: post
title: Notes of APUE 1
---

#{{ page.title }}  
<p class="meta">22 Sep 2014 - Guangzhou</p>   
+++++++++++++++++  

###[返回主目录][]  
<br>

##Chapter 1: UNIX基础知识
1. 引言
2. UNIX体系结构  
    ![img][1.2]
3. 登录
    1. 登录名
    2. shell；**命令解释器**，读取用户输入（终端交互、shell脚本），然后执行命令
4. 文件和目录  
　　4.1 文件系统：**“目录+文件”**组成的层次结构；目录是一个包含n个**“目录项”**，目录项包含文件名+文件属性信息（这是逻辑视图上，实际存储不是这样）；`stat`和`fstat`函数返回包含文件属性的一个信息结构  
　　4.2 文件名  
　　4.3 路径名；  
　　ls命令的简单实现  

       ```c
       struct dirent *dirp = opendir(argv[1]);  
       while((dirp = readdir(dp) != NULL)   
            printf("%s\n", dirp->d_name);   
       ```  
　　4.4 工作目录（current）  
　　4.5 起始目录（登陆时的工作目录）  
5. 输入和输出
    1. 文件描述符（file descriptor）;非负整数，内核用它标识一个特定进程正在访问的文件
    2. 标准输入、输出、出错（这是运行任何程序时shell打开的三个**文件描述符**）
    3. 不同缓冲的I/O；函数`open`,`read`,`write`,`lseek`,`close`；自定义BUFFSIZE，缓存由内核负责（并非没有缓存）
    4. 标准I/O；带缓冲的接口，无需担心最佳缓冲区大小，使用缓冲区进行输入输出；如`<stdio.h>`的`printf`；用标准I/O将`stdin`复制到`stdout`，从而实现文件复制，`c = getc(stdin); putc(c, stdout);`
6. 程序与进程
    1. 程序：存放在磁盘的可执行文件，由内核将程序读入存储器（使用`exec`函数）
    2. 进程（程序的执行实例），进程ID（唯一的数字标识符，非负整数，`getpid()`）
    3. 进程控制（3个函数）：`fork`(创建新进程，向父进程返回新子进程的进程ID，向子进程返回0)、`exec（执行命令）`、`waitpid（可以用来实现父进程等待子进程的种植）`; shell程序的简单实现（从标准输入读命令并执行）；`if(buf[strlen(buf) -1] == '\n')`,`pid_t pid = fork();`,`execlp(buf, buf, (char *)0);`
    4. 线程和线程ID；**一个进程内**的所有线程共享同一地址空间、文件描述符、栈以及与进程相关的属性，能访问同一存储区，访问共享数据时需要采取同步措施
7. 出错处理；errno整型变量；出错恢复（致命性：无法恢复，最多print出错信息；非致命性：例如资源紧缺，可延迟再试）  
　　打印出错信息的两个函数  
    
    ```c
    #include <string.h>  
    char *strerro(int errnum);  /* 返回值：指向消息字符串的指针 */  
    ```  

    ```c
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
　　库函数可替换(malloc,calloc;printf,fprintf)，系统调用不能替换(sbrk;write,read)；malloc**函数**（用户层次）， sbrk**系统调用**（内核层次）  
　　区别：从用户的角度来看，它们都可以通过C来调用；从实现的角度来看，系统调用是操作系统内核提供的服务，库函数则一般基于系统调用实现；系统调用提供**最小接口**，库函数提供比较复杂的功能  
    ![img][1.11]  

<br>


[返回主目录]: /2014/09/22/notes-of-apue.html

[1.2]: /images/apue/1.2.png "unix architecture"
[1.11]: /images/apue/1.11.png "diff between library function and system call"
