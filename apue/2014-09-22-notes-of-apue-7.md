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
　　③ 调用\_exit或\_Exit  
　　④ 最后一个线程从其**“启动例程”**返回(11.5)  
　　⑤ 最后一个线程调用pthread\_exit(11.5)  
　　⑥ 调用abort(10.17)  
　　⑦ 接到一个信号并终止(10.2)  
　　⑧ 最后一个线程对“取消请求”做出响应(11.5和12.7)  
　　7.2节的**“启动例程”**是这样编写的：`exit(main(argc, argv));`，这样，使得从main返回后立即调用exit函数。  
    1. exit函数  
　　正常终止一个程序：\_exit和\_Exit立即进入内核；exit先执行一些清理（调用执行各个**"终止处理程序""**，关闭所有标准I/O(即fclose()，会造成所有缓冲的输出数据被flush)），然后才进入内核。  
    
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
　　内核执行程序的唯一方法是调用一个exec函数。进程自愿终止的唯一方法是显式地或隐式地(调用exit)调用\_exit或\_Exit。进程非自愿终止：由一个信号使其终止。  

4. 命令行参数  
　　执行一个A程序时，调用exec的进程可将命令行参数传递给该A程序。  
　　其中argv[argc]是空指针NULL。故以下语句也是合法的：`for (i = 0; argv[i] != NULL; i++);`。  

5. 环境表  
　　与参数表一样，环境表也是一个字符指针数组。全局变量environ包含了该指针数组的地址： `extern char **environ;`，称environ为“环境指针”，指针数组为环境表，环境表的每一项为`name=value`，例如是HOME=/root\0、PATH=:/bin:/usr/bin\0等等  

6. C程序的存储空间布局  
　　C程序由以下几部分组成：  
    + 正文段。cpu执行的机器指令部分，只读，可共享（所以即使是频繁执行的程序**也只需**一个副本在内存）
    + 初始化数据段。通常称为数据段。包含了***明确***赋初值的变量，如`int max=99;`
    + 非初始化数据段。通常称为bss段(block started by symbol)。没有赋值的变量，如`long sum[100];`，内核将此段中的数据初始化为0或NULL。  
    + 栈。auto变量和每一次**函数调用**需要保存的信息（返回地址、环境信息等保护现场）。
    + 堆。通常在堆中进行“动态内存分配”。  
　　下图是典型的C程序存储空间布局，可用size(1)命令报告正文段(text)、数据段(data)和bss段的字节数：  
    ![img][7.6]  

7. 共享库   
　　若在gcc时不指定 `-static`参数，则默认使用共享库。  
　　共享库的优点：  
　　① 可执行文件不需要包含公用的库例程(只需在共享的存储区（所有进程可引用）中维护这种库例程的一个副本)。程序第一次执行或第一次调用某个库函数时，动态链接的方式链接“程序”与“共享库函数”。减少了可执行文件的长度（缺点是增加运行时间开销）   
　　② 可以用库函数的新版本代替老版本，无需重新连接编辑使用该库的程序。  

    ```bash
    $ cc -static hello.c    阻止gcc使用共享库
    $ ls -l a.out
    $ size a.out

    $ cc hello.c            gcc默认使用共享库
    $ ls -l a.out           可执行文件变小
    $ size a.out            正文和数据段长度都会减少
    ```
8. 存储器分配  
　　ISO C说明了三个存储空间动态分配的函数：  
　　① malloc。分配指定**字节数**的存储区，存储区的初始值不确定。  
　　② calloc。为“指定数量”的“指定长度的对象”分配存储空间。该空间每一位都初始化为0。  
　　③ realloc。更改以前分配区的长度。  

    ```c
    #include <stdlib.h>

    void *malloc(size_t size);
    void *calloc(size_t nobj, size_t size);
    void *realloc(void *ptr, size_t newsize);  
    /* 若ptr==NULL，则realloc等效于malloc */
    /* 三个函数返回值：成功返回非空指针(通用指针 void *)，出错NULL */

    void free(void *ptr);
    ```
　　以上这些分配例程通常用sbrk(2)系统调用实现。  
　　**notice**：通常，“实际分配的空间”比“请求分配的空间”要稍大，额外的空间用于记录管理信息——分配的块长度，指向下一块的指针等等。所以使用**超过**以一个请求分配的空间,会导致错误（覆盖了块的管理信息），而这种错误不会很快暴露出来。  
　　另一类错误：free一个已经free的块；调用free时的参数不是以上3个alloc函数的返回值。若malloc后忘记free，则该进程占用的内存空间就会连续增加（称为***泄漏(leakage)***），进程地址空间长度会慢慢增加，直至没有空闲空间，而且过度分页开销，性能下降。  
　　本节余下部分还介绍了以上4个函数在某些系统的另一种实现，增加了附加的检错。如libmalloc库，vmalloc，基于“快速匹配(quick-fit)”的malloc和free，alloca函数  

9. 环境变量  
    环境字符串的形式：name=value  
    ISO C定义的getenv()用于取环境变量值。  

    ```c
    #include <stdlib.h>

    char *getenv(const char *name);
    /* 返回值：指向与name关联的value指针，找不到则返回NULL */
    ```
    另外3个函数  

    ```c
    #include <stdlib.h>

    int putenv(char *str);
    /* str字符串为“name=value”
    /* return: 成功0，出错非0 */

    int setenv(const char *name, const char *value, int rewrite);
    int unsetenv(const char *name);
    /* both return: 成功0，出错-1 */
    ```
    
10. setjmp和longjmp函数  







<br>  

[返回主目录]: /2014/09/22/notes-of-apue.html
[7.3]: /images/apue/7.3.png         "C program start and terminate"
[7.6]: /images/apue/7.6.png         "memory layout of C program"
