---
layout: post
title: Notes of APUE 7
---

#{{ page.title }}  
<p class="meta">16 Oct 2014 - Guangzhou</p>   
+++++++++++++++++  

###[返回主目录][]  
<br>

##Chapter 7: 进程环境
1. 引言  
    本章将学习：  
    * 执行程序时，main函数如何被调用
    * 命令行参数如何传给执行程序
    * 典型的存储器布局
    * 如何分配另外的存储空间
    * 进程如何使用环境变量
    * 不同的进程终止方式
    * longjmp()和setjmp()，以及它们与栈的交互作用
    * 进程的资源限制

2. main函数  
    main函数的原型是`int main(int argc, char *argv[]);`  
    * **内核**执行C程序时（使用一个exec函数），从main开始执行。
    * 调用main前先调用一个特殊的**“启动例程”**，同时，**“启动例程”**从内核获得“命令行参数”和“环境变量值”。“可执行程序文件”将此**“启动例程”**指定为**“程序的起始地址”**。
    * **“连接编辑器”**设置**“程序的起始地址”**。
    * **“C编译器”**（如gcc）调用**“连接编辑器”**。

3. 进程终止  
    8种方式进程终止(termination)，前5种正常+后3种异常  
    ① 从main返回  
    ② 调用exit  
    ③ 调用_exit或_Exit  
    ④ 最后一个线程从其**“启动例程”**返回(11.5)  
    ⑤ 最后一个线程调用pthread_exit(11.5)  
    ⑥ 调用abort(10.17)  
    ⑦ 接到一个信号并终止(10.2)  
    ⑧ 最后一个线程对“取消请求”做出响应(11.5和12.7)  
    7.2节的**“启动例程”**是这样编写的：`exit(main(argc, argv));`，这样，使得从main返回后立即调用exit函数。  
    1. exit函数  
    正常终止一个程序：_exit和_Exit立即进入内核；exit先执行一些清理（调用执行各个**"终止处理程序""**，关闭所有标准I/O(即fclose()，会造成所有缓冲的输出数据被flush)），然后才进入内核。  
    
    ```c
    #include <stdlib.h>

    void exit(int status);
    void _Exit(int status);

    #include <unistd.h>

    void _exit(int status);
    ```
    status是终止状态。以下三种情况会导致终止状态未定义：  
    (a) 调用这些函数不带参数。  
    (b) main执行了一个无返回值的return语句。  
    (c) main没有声明返回类型为整型。  
    `exit(0);`等价于`return(0);`  
    2. atexit函数  
    exit会自动调用一些函数——“终止处理程序”(exit handler)，并调用atexit函数来登记(register)这些函数。调用这些函数的顺序与登记它们的顺序相反（先atexit(f2)再atext(f1)，结果是f1先调用）同一函数登记多次，也会调用多次。  

    ```c
    #include <stdlib.h>

    int atexit(void (*func)void);
    /* 返回值：成功0，出错非0 */
    ```
    atexit的参数是一个函数地址。  
    下图说明一个C程序是如何启动和终止的。  
    ![img][7.3]  
    内核执行程序的唯一方法是调用一个exec函数。进程自愿终止的唯一方法是显式地或隐式地(调用exit)调用_exit或_Exit。进程非自愿终止：由一个信号使其终止。  

<br>  

[返回主目录]: /2014/09/22/notes-of-apue.html
[7.3]: /images/apue/7.3.png         "C program start and terminate"
