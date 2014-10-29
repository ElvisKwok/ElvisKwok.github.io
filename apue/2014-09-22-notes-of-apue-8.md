---
layout: post
title: Notes of APUE 8
---

#{{ page.title }}  
<p class="meta">20 Oct 2014 - Guangzhou</p>   
+++++++++++++++++  

###[返回主目录][]  
<br>

##Chapter 8: 进程控制
1. 引言  
    本章介绍的UNIX进程控制，包括：（基本的进程控制原语: fork创建新进程，exec执行新程序，exit函数和两个wait函数处理终止和等待终止）   
    * 创建新进程
    * 执行程序
    * 进程终止
    * 进程属性的各种ID——“实际、有效和保存”的“用户和组ID”，以及它们如何收到“进程控制原语”的影响
    * 解释器文件和system函数
    * 进程会计机制

2. 进程标识符  
　　每个进程都有一个唯一、非负的进程ID，但是进程终止后，进程ID可以重用（延迟重用，避免出错）  
　　一些专用进程：  
　　ID=0是交换进程(swapper)（也叫：系统进程），它是调度进程，是内核的一部分。  
　　ID=1是init进程，由内核调用，读系统的初始化文件（`/etc/rc*`)，引导系统到一个状态（如多用户），init进程不会终止，以超级用户特权运行。  
    以下函数返回进程相关的标识符：  

    ```c
    #include <unistd.h>

    pid_t getpid(void);
    pid_t getppid(void);    /* parent process id */
    
    uid_t getuid(void);
    uid_t geteuid(void);    /* 有效用户ID */

    gid_t getgid(void);
    gid_t getegid(void);    /* 有效组ID */
    ```

3. fork函数  
　　一个**现有**进程可以调用fork()创建一个新进程（子进程）。  

    ```c
    #include <unistd.h>

    pid_t fork(void);
    /* fork被调用一次，返回两次 */
    /* 返回值：在子进程中返回0，子进程ID返回给父进程，出错返回-1 */
    ```
　　两个返回值的解释：  
　　①子进程ID返回给父进程的理由是：一个进程可以有多个子进程，而且目前没有函数可以使得一个进程获取它的子进程的进程ID。  
　　②子进程得到返回值0的理由是：一个进程只有一个父进程，可通过getppid()获取（进程ID=0必定是swapper交换进程，所以一个子进程的进程ID不可能为0）。具体的编程实现中，可用`if (pid == 0)`判断当前进程是否为原来的子进程，pid=0则是原来的子进程  
　　子进程和父进程***都要***继续执行fork之后的程序语句。子进程是父进程的副本（获得父进程的数据空间、堆、栈的**副本**，notice:不是**共享**）,正文段（程序语句）才是共享。  
　　strlen和sizeof计算字符串长度的区别：  
　　①strlen计算不包含终止null字节的字符串长度（肉眼长度），sizeof包含。  
　　②strlen需要进行一次函数调用，sizeof不用。因为缓冲区已经用“已知字符串”进行了初始化，其长度是固定的，所以sizeof在编译时计算缓冲区长度。  
　　实例程序中用write函数（不带缓冲的IO）输出一行，用printf函数（标准I/O，带缓冲）也输出了一行。针对“交互式终端输出”和“重定向到一个文件”printf函数会出现如下不同结果：  
　　①首先，对于write函数，无论哪一种输出都是整个程序（父子进程一起）只输出一次。  
　　②“交互式终端输出”时，整个进程只输出一次（因为stdout输出到终端设备时，它是***行缓冲***的，stdout缓冲区遇到换行符时会进行flush）  
　　③“重定向到一个文件”时，printf输出两次，因为它这时是***全缓冲***的。调用fork时，该行数据仍在缓冲区中。而父进程把它的**数据空间复制**到子进程（包括printf函数的缓冲区），这时，父子进程都有该行内容的标准I/O缓冲区。当每个进程终止时，缓冲区的***副本***才被flush。  

    **文件共享**  
　　实例程序中子进程的stdout也被重定向到同一个文件。这是因为fork的特性：父进程所有打开的文件描述符fd也会被复制到子进程中，父子进程的每个相同的fd共享一个“文件表项”（chapter 3），如下图所示：  
　　![img][8.3.1]  
　　这样使得父子进程对同一个文件使用一个“文件偏移量”（比如子进程向stdout文件printf，父进程共享到了stdout文件偏移量，在子进程后面接着printf），但是应该注意，父子进程共享同一fd，必须要经过***同步***操作（例如父进程sleep，等待子进程），否则它们的输出就会相互混合。  
　　**fork之后处理fd的两种情况：**  
　　①父进程等待子进程。此时父进程无需对fd做任何处理，子进程终止后，文件偏移量都执行了相应的更新。  
　　②父子进程各自执行“不同的代码段”，不干扰各自使用的fd。常用于网络服务进程。  
　　除了“打开文件”之外，子进程还**继承父进程的其他属性**，如下图：  
　　![img][8.3.2]  
　　**父、子进程的区别有：**  
　　①fork的返回值  
　　②进程ID不同，父进程ID也不同  
　　③子进程tms\_utime,tms\_stime,tms\_cutime,tms\_ustime被设为0  
　　④父进程设置的文件锁不会被子进程继承  
　　⑤子进程未处理的闹钟(alarm)会被清除  
　　⑥子进程未处理的信号集设置为空集  
　　**fork失败的两个原因：**  
　　①系统已经有太多进程（对于整个系统而言）  
　　②该实际用户ID的进程总数超出系统给他的限制（对于某一个用户而言）  
　　**fork的两种用法：**  
　　①父进程希望和子进程一起“执行不同的代码段”，常见于网络服务进程。例如：父进程监听client请求，当请求到达时，fork子进程处理这个请求，父进程继续监听。  
　　②一个进程要执行一个不同的程序。如shell需要fork子进程执行exec。（有些系统会将fork和exec组合在一起，叫做spawn，但是UNIX没有用spawn）  

4. vfork函数  
　　与fork()不同:  
　　①vfork()创建新进程的目的是exec一个新程序。  
　　②vfork()出来的子进程**不会完全复制**父进程的地址空间，因为子进程会立即调用exec或exit，不会访问到该地址空间。  
　　③子进程在调用exec或exit之前，还在父进程的空间中运行（所以子进程可能改变父进程的变量值）。  
　　④vfork()保证子进程先运行。因此不需要父进程调用sleep等待。内核会保证子进程调用exec时，父进程处于休眠状态。  
　　notice：实例程序在子进程中使用\_exit而不是exit，因为\_exit不会flush标准I/O的缓冲，exit会，若使用exit，由于子进程借用了父进程的地址空间，当父进程恢复运行时，printf可能不会产生任何输出（如果该实现也关闭标准I/O流）  

5. exit函数  
　　7.3节提到5+3种进程终止方式，但是无论哪一种方式，都会执行内核中的同一段代码，其功能是为相应进程关闭所有打开的fd，释放它使用的存储器等。  
　　“退出状态”是exit()或\_exit()的参数，内核调用\_exit()时，会把“退出状态”转换成“终止状态”。  
　　①如果父进程在子进程之前终止：子进程的父进程改变为init进程，这种现象称为“子进程被init进程领养”。所以“一个init的子进程”有两种可能（init直接产生、领养）  
　　②如果子进程在父进程之前终止：父进程可以调用wait()或waitpid()捕捉子进程的终止状态，内核可以释放“终止进程”所使用的的存储区（“善后”处理）。如果子进程已经终止，父进程还没将它“善后”，这种进程称为僵死进程(zombie)。ps(1)命令输出的状态为Z。（ps: init进程领养的进程不会变成zombie，init会调用wait()获取领养进程的终止状态）  

6. wait和waitpid函数  
　　进程终止（正常或异常）时，内核会向它的父进程发送异步信号SIGHLD（因为子进程可在父进程运行的任何时候终止）  
　　调用wait或waitpid的三种结果：  
　　①阻塞：所有子进程仍在运行。  
　　②返回某一子进程的终止状态：该子进程已终止。  
　　③返回出错。不存在子进程。  

    ```c
    #include <sys/wait.h>
    
    pid_t wait(int *statloc);                               
    /* 子进程终止前，调用者（父进程）会阻塞 */
    
    pid_t waitpid(pid_t pid, int *staloc, int options);     
    /* 调用者可以不阻塞（根据options） */
    /* 参数pid指定等待的进程: 
     * pid == -1表示等待任一子进程
     * pid > 0  表示等待进程pid
     * pid == 0 表示等待与父进程同一组ID的任一子进程
     * pid < -1 表示等待组ID==|pid|的任一子进程
     */

    /* statloc指针指向的单元保存子进程的终止状态 */
    /* 两个函数返回值：成功返回进程ID，0，出错返回-1 */
    ```
　　以下四个宏可用来检查wait()和waitpid()返回的终止状态statloc（或称status）：  
　　WIFEXITED(status)为真则表示子进程正常终结，WIFSIGNALED(status)为真则表示异常终结；WIFSTOPPED(status)为真则表示子进程当前暂停，WIFCONTINUED(status)为真则表示暂停的子进程已经继续。  
　　waitpid()有，wait()没有的三个功能：  
　　①waitpid()可等待指定进程；   
　　②非阻塞；  
　　③waitpid()支持作业控制；  
　　现在有这样的需求：fork子进程之后：①不等待子进程终止；②不希望父进程终止后，子进程处于僵死状态。  
　　Solution：调用两次fork  

7. waitid函数  
　　Single UNIX Specification的XSI扩展，类似于waitpid()，也是取进程终止状态的函数，灵活性增加。但是只有Solaris支持waitid()  

    ```c
    #include <sys/wait.h>

    int waitid(idtype_t idtype, id_t id, siginfo_t *infop, int options);
    /* 返回值：成功0，出错-1 */
    ```

8. wait3和wait4函数  
　　这两个函数提供一个参数rusage指针，要求内核返回终止进程和所有子进程使用的资源汇总（用户、系统cpu时间，页面出错次数、接收到的信号次数等）。

    ```c
    #include <sys/types.h>
    #include <sys/wait.h>
    #include <sys/time.h>
    #include <sys/resource.h>

    pid_t wait3(int *statloc, int options, struct rusage *rusage);
    pid_t wait4(pid_t int *statloc, int options, struct rusage *rusage);
    /* 返回值：成功：进程ID，出错：-1 */
    ```

9. 竞争条件  
　　发生竞争条件(race condition)：多进程处理共享数据，最后结果取决于进程的运行顺序。  
　　fork之后无法预料父、子谁先运行，即使sleep也无法保证。（系统负载很重时），而轮询（polling）又浪费cpu时间。  
　　实例程序（具有竞争条件）会产生错误输出:  
　　![img][8.9]  
　　以下五个例程：`TELL_WAIT, TELL_PARENT, TELL_CHILD, WAIT_PARENT, WAIT_CHILD`可用于避免竞争条件，两种实现方法：信号（10.16节），管道（15.2节）  

10. exec函数  
　　fork函数创建的子进程通常要调用exec函数，exec函数不创建新进程，执行exec前后，进程ID不变。exec函数用新的程序替换进程的“正文、数据、堆和栈段”。  
    
    ```c
    #inlcude <unistd.h>
    
    int execl(const char *pathname, const char *arg0,　　

<br>

[返回主目录]: /2014/09/22/notes-of-apue.html

[8.3.1]: /images/apue/8.3.1.png "file sharing of fork()"
[8.3.2]: /images/apue/8.3.2.png "property inheritance"
[8.9]: /images/apue/8.9.png "race condition"
