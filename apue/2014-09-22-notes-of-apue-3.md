---
layout: post
title: Notes of APUE 3
---

#{{ page.title }}  
<p class="meta">22 Sep 2014 - Guangzhou</p>   
+++++++++++++++++  

##chapter 3: 文件I/O
1. 引言  
    5个文件I/O函数：`open`，`read`，`write`，`lseek`，`close`，不同缓冲区长度对read和write的影响  
    本章所说明的函数被称为**不带缓冲的I/O**（unbuffered I/O），**不带缓冲**指的是每个read和write都调用内核的一个系统调用。不带缓冲的I/O函数不是ISO C的组成成分，是POSIX.1和Single UNIX Specification的组成部分  
    原子操作，通过文件I/O和open函数的参数来讨论；多进程共享文件，涉及的内核数据结构；`dup`，`fcntl`，`sync`，`fsync`和`ioctl`函数  
2. 文件描述符  
    使用open或creat时，内核向进程返回fd，作为参数传给read或write
    0、1、2分别与stdin、stdout、stderr关联,头文件`<unistd.h>`分别定义为常量`STDIN_FILENO`, `STDOUT_FILENO`和`STDERR_FILENO`  
3. open函数  

    ```c
    #include <fcntl.h>  
    int open(const char *pathname, int oflag, ...);  
    ```   
    oflag可为O_RDONLY,O_WRONLY,O_RDWR，还有其他可选参数，这些常量在`<fcntl.h>`定义  
    返回最小的未用描述符数值  
4. creat函数  

    ```c
    #include <fcntl.h>  
    int creat(const char *pathname, mode_t mode);  
    ```  
    等效于`open(pathname, O_WRONLY | O_CREAT | O_TRUNC, mode)`  
    creat缺点：只能以*只写方式*打开创建的文件，如果要先写后读，只能调用creat,再close,再调用open。现在可以这样`open(pathname, O_RDWR | O_CREAT |O_TRUNC, mode)`  
5. close函数  

    ```c
    #include <unistd.h>  
    int close(int fd);  
    ```   
    关闭文件还会释放*加在文件上的所有记录锁*  
    进程终止，内核自动关闭该进程打开的文件
6. lseek函数  
    **当前文件偏移量**  

    ```c
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

    ```c
    #include <unistd.h>
    ssize_t read(int fd, void *buf, size_t nbytes);
    /* 返回值：成功返回读到的字节数,到达文件末尾返回0，出错返回-1 */
    ```  
    e.g.: 离文件末尾剩余30字节，要求读100字节，则read返回30，下一次调用read时返回0
8. write函数  
    
    ```c
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
    * 文件表(其中文件状态标志可为read，write, rw等access mode，append，同步和非阻塞等)
    * v节点表  

    下图为一个进程打开两个**不同**的文件（fd分别为0、1），同一个进程表项的两个fd、两个文件表项、两个v节点表项  
    ![img][3.10.1]  
    下图为两个独立进程各自打开**同一个**文件，两个进程表项的两个fd（3，4）、两个文件表项(使得每个进程都有它自己的该文件当前偏移量)、同一个v节点表项  
    ![img][3.10.2]  
    多个文件描述符可能指向同一个文件表项，e.g.: dup函数、fork的父子进程对于每一个打开的文件描述符共享一个文件表项  
11. 原子操作  
    一般而言，原子操作（atomic operation）指的是有多步组成的操作。如果该操作原子地执行，要么执行完所有步骤， 要么一步不执行，不可能值执行所有步骤的一个子集  
    1. 添加至一个文件  
    e.g., 使用lseek和write函数完成open的O_APPEND操作，进程A、B对同一个文件操作。然而，在两个函数调用之间，内核可能会临时挂起某一个进程。所以，任何一个需要多个函数调用的操作都不可能是原子操作  
    2. pread和pwrite函数
    Single UNIX Specification包括了XSI扩展，该扩展允许原子性地seek和执行I/O  

    ```c
    #include <unistd.h>
    ssize_t pread(int fd, void *buf, size_t nubytes, off_t offset);
    ssize_t pwrite(itn fd, const void *buf, size_t nbytes, off_t offset);
    ```  
    pread相当于顺序调用lseek和read（区别是定位和读操作不能中断，而且不更新文件指针），pwrite相当于顺序调用lseek和write  
    3. 创建一个文件
    “检查该文件是否存在“以及”创建该文件“这两个操作是作为一个原子操作执行的
12. dup和dup2函数  

    ```c
    #include <unistd.h>
    int dup(int fd);
    int dup2(int fd, int fd2);
    /* 两个函数返回值：成功返回新的fd，否则返回-1 */
    ```
    dup返回的新文件描述符一定是**当前可用文件描述符之中的最小数值**，dup2则可以返回fd2指定的新描述符，若fd2已经打开，则先将fd2关闭
    函数返回的新fd与参数fd**共享同一个文件表项**，如下图  
    ![img][3.12]  
    由于两个fd共享同一个文件表项，所以共享同一文件状态标志（读、写、添加）以及同一当前文件偏移量  
    复制fd的另一种方法：使用fcntl函数  
    `dup(fd);`等效于`fcntl(fd, F_DUPFD, 0);`  
    `dup2(fd, fd2);`等效于（不完全等同）`close(fd2);`、`fcntl(fd, F_DUPFD, fd2);`  
13. sync、fsync和fdatasync函数  
    延迟写：传统的UNIX系统在内核中设置缓冲区高速缓存，写文件时内核首先将数据复制到缓冲区，等待**缓冲区写满**或缓冲区需要重用时才将缓冲排队到输出队列，然后才实际I/O操作。  
    延迟写优点：减少磁盘读写次数；缺点：文件内容更新速度降低，系统故障时可能丢失数据。  
    UNIX提供sync、fsync和fdatasync函数来保证实际文件系统与缓冲区高速缓存的**内容一致性**  
    
    ```c
    #include <unistd.h>
    int fsync(int fd);      /* 单一文件fd，等待写磁盘结束 */
    int fdatasync(int fd);  /* 类似fsync，但fsync还会同步更新文件属性 */
    /* 返回值：成功0，否则-1 */

    void sync(void);    /* 将修改过的块缓冲区排队到写队列，然后返回(不等待实际写磁盘结束) */
    ```
    update守护进程会周期性的调用sync函数，命令sync也调用sync函数  
14. fcntl函数  
    fcntl函数可以改变已打开的文件的性质  
    
    ```c
    #include <fcntl.h>
    int fcntl(int fd, int cmd, ...);
    /* 返回值：成功则依赖于cmd，若出错则返回-1 */
    ```
    fcntl函数有5种功能：  
    * 复制一个现有的fd（cmd=F_DUPFD）
    * 获得/设置fd标记（cmd=F_GETFD或F_SETFD) 
    * 获得/设置文件状态标志（cmd=F_GETFL或F_SETFL)
    * 获得/设置异步I/O所有权（cmd=F_GETOWN或F_SETOWN)
    * 获得/设置记录锁（cmd=F_GETKL、F_SETLK或F_SETLKW)  
    编写程序：对于指定的描述符打印文件标志  
    编写程序：对一个fd设置一个或多个文件状态标志
15. ioctl函数  
    ioctl函数是I/O操作的杂物箱。不能用本章中其他函数表示的I/O操作通常都能用ioctl表示。  
    终端I/O是ioctl的最大使用方面  

    ```c
    #include <unistd.h>     /* System V */
    #include <sys/ioctl.h>  /* BSD and Linux */
    #include <stropts.h>    /* XSI STREAMS */

    int ioctl(int fd, int request, ...);

    /*返回值：出错返回-1，成功返回其他值 */
    ```
    通常ioctl函数还要求另外的设备专用头文件，如终端I/O的ioctl命令要求头文件`<termios.h>`  
    每个设备驱动程序都可以定义自己专用的一组ioctl命令  
16. /dev/fd  
    /dev/fd目录的目录项是名为0、1、2等文件。打开文件/dev/fd/n等效于复制描述符n.  
    `fd = open("/dev/fd/0", mode);` 等效于 `fd = dup(0);`  
    `ls | cat file1 - file3`等效于`ls | cat file1 /dev/fd/0 file3`, cat 将`-`解释为标准输入（这里是ls命令），但看起来像是一个选项，使用/dev/fd/0则更加清晰  
17. 小结  
    * 本章说明了UNIX系统提供的基本I/O函数。因为read和write都在内核执行，所以称这些函数为**不带缓冲的I/O函数**。  
    * 只使用read和write的情况下，观察不同I/O长度读文件的所需时间的影响。  
    * 将写入的数据冲洗到磁盘的方法，对性能的影响。  
    * 原子操作：多进程apped/creat同一文件。  
    * 内核用来共享打开文件信息的数据结构。   
    * ioctl和fcntl函数  

<br>


[3.9]: /images/apue/3.9.png "BUFFSIZE influence efficiency"
[3.10.1]: /images/apue/3.10.1.png "file sharing"
[3.10.2]: /images/apue/3.10.2.png "file sharing"
[3.12]: /images/apue/3.12.png "dup"
