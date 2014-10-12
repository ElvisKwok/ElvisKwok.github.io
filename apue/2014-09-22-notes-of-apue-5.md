---
layout: post
title: Notes of APUE 5
---

#{{ page.title }}  
<p class="meta">12 Oct 2014 - Guangzhou</p>   
+++++++++++++++++  

##[返回主目录][]  
<br>

##Chapter 5: 标准I/O库
1. 引言  
    标准I/O库处理很多细节，例如缓冲区分配，以“优化长度”执行I/O等等，这些处理使得用户不必担心如何选择正确的块长度。  
    标准I/O库由Dennis Ritchie在1975年左右编写，30年后只做极小修改。  
2. 流和FILE对象  
    在chapter 3，所有的I/O函数都是针对文件描述符fd的。而对于标准I/O库，它们的操作则是围绕**流(stream)**进行的。  
    标准文件流可用于单字节或多字节（“宽”）字符集。  
    **流的定向**决定所读、写的字符是单字节还是多字节。若在未定向的流使用一个多字节I/O函数，则流的定向设置为“宽定向”；若使用一个单字节I/O函数，则流的定向设置为“字节定向”。  
    只有两个函数可以改变流的定向。freopen函数清除流的定向（5.5节），fwide函数设置流的定向。  

    ```c
    #include <stdio.h>
    #include <wchar.h>
    
    int fwide(FILE *fp, int mode);
    /* 返回值：流是宽定向则返回正值，字节定向返回负值，未定向返回0 */
    ```
    根据mode参数的不同，fwide()执行不同工作：  
    * mode 负，fwide()试图设置指定的流是字节定向的。
    * mode 正，。。。。。。。。。。。。。宽定向的。
    * mode 0，fwide()不设置流的定向，返回原来标识该流定向的值。  

    fwide()不改变“已定向的”流的定向，fwide()没有出错返回，唯一可行的方法是调用fwide()时先清除errno，fwide()返回是检查errno的值。  
    打开一个流时，标准I/O函数fopen()返回一个指向FILE对象的指针(类型为FILE *， 称为文件指针)。FILE对象是一个结构，包含标准I/O库管理该“流”所需的所有信息，如：  
    * 用于实际I/O的文件描述符fd  
    * 指向该流缓冲区的指针  
    * 缓冲区的长度  
    * 当前在缓冲区中的字符数  
    * 出错标志  
    * 等等  

3. 标准输入、标准输出和标准出错    
    一个进程预定义以上三个**流**，这些流引用的文件与chapter3所用的文件描述符fd引用的文件相同。  
    这三个标准I/O流通过预定义文件指针stdin、stdout、stderr加以引用。三个文件指针定义在`<stdio.h>`。  

4. 缓冲  
    标准I/O库提供缓冲的目的：尽可能减少使用read和write调用的次数。      
    三种类型的缓冲（三种情况）：  
    （1）全缓冲。在这种情况下，填满标准I/O缓冲区才进行实际I/O操作，通常用于磁盘文件。  
        flush（冲洗）：在标准I/O库方面，flush是讲缓冲区中的内容写到磁盘。（该缓冲区不一定是满的）；而在chapter 18的终端程序驱动方面，flush（刷清）表示丢弃缓冲区的数据。  
    （2）行缓冲。在这种情况下，输入输出遇到换行符时，标准I/O库执行I/O操作。通常是流涉及一个终端时（如stdin何stdout）。  
    两个限制：① 每一行缓冲区长度固定，可能出现还没换行符就填满缓冲区进行I/O操作。② 当输入的数据是不带缓冲的流或者“要求从内核得到数据的”行缓冲的流，会造成flush所有行缓冲输出流。  
    （3）不带缓冲。标准I/O库不对字符进行缓冲存储，stderr通常是不带缓冲的（出错信息尽快显示出来）。  
    stdin和stdout不涉及交互式设备时，才是全缓冲；stderr绝对不是全缓冲。终端设备的流是行缓冲。  
    以下两个函数用于更改缓冲类型：  

    ```c
    #include <stdio.h>
    void setbuf(FILE *restrict fp, char *restrict buf);
    int setvbuf(FILE *restrict fp, char *restrict buf, int mode, size_t size);
    /* 返回值：成功0，出错非0 */
    ```
    要求：先打开流，再调用，而且必须在其他操作之前调用。  
    可用setbuf()打开或关闭缓冲机制。参数buf指向长度为BUFSIZ的缓冲区（BUFSIZ定义在stdio.h）。关闭缓冲可将buf设置为NULL。  
    setvbuf()根据mode参数，全缓冲`_IOFBF`, 行缓冲`_IOLBF`, 不带缓冲`_IONBF`。  
    具体如下表所示:  
    ![img][5.4]
    使用fflush强制fulsh一个流  

    ```c
    #include <stdio.h>
    int fflush(FILE *fp);
    /* 返回值：成功0，出错EOF */
    ```
    fflush()使得该流所有未写的数据传送至内核。若参数fp为NULL，则使得所有输出流被flush。  
5. 打开流  
    下列三个函数打开一个标准I/O流。  

    ```c
    #include <stdio.h>

    FILE *fopen(const char *restrict pathname, const char *restrict type);
    FILE *freopen(const char *restrict pathname, const char *restrict type, 
                    FILE *restrict fp);
    FILE *fdopen(int fd, const char *type);
    /* 返回值：成功返回文件指针fp，出错NULL */
    ```
    * fopen()打开一个文件。
    * freopen()在一个**指定的流**打开一个指定的文件。若该流已打开，则先关闭该流；若该流已经定向，则清除该定向。常用于为一个文件打开以下三种流：stdin，stdout，stderr。   
    * fdopen()把现有的文件描述符fd和标准I/O流结合。常用于由创建“管道”和“网络通信”函数（设备专用函数）返回的描述符。因为这些特殊文件不能用fopen打开。  
    type是读写方式r，rb，r+，w，a等等。指定w或a类型创建一个新文件时，不能指定访问权限位（open函数和creat函数可以）  
    fclose()关闭一个打开的流。关闭之前flush缓冲区的输出数据，丢弃输入数据。  

    ```c
    #include <stdio.h>
    int fclose(FILE *fp);
    /* 成功0，出错EOF */
    ```
6. 读和写流  
   三种非格式化I/O的读写操作：
   * (5.6节)每次一个字符的I/O。一次读或写一个字符。
   * (5.7节)每次一行的I/O。每次读或写一行，则使用fgets和fputs，每行都以一个换行符终止。调用fgets时应指定能处理的最大行长度。
   * (5.9节)直接I/O（二进制I/O、一次一个对象I/O）。fread和fwrite支持这种类型的I/O。每次I/O某种数量的对象，每个对象具有指定长度。常用于从二进制文件每次读写一个结构。
   
   6.1 输入函数  
   一次读一个字符  

    ```c
    #include <stdio.h>
    int get(FILE *fp);
    int fgetc(FILE *fp);
    int getchar(void);
    /* 返回值：成功则返回下一个字符，出错或文件结尾返回EOF(可以用ferror和feof区分) */
    ```
    getchar函数等价于getc(stdin)。getc可被实现为宏，fgetc不能。
    
    ```c
    #include <stdio.h>
    int ferror(FILE *fp);
    int feof(FILE *fp);
    /* 返回值：条件真则返回真（非0值），否则返回0 */
    
    void clearerr(FILE *fp);
    ```  
    从流中读取数据后，可以调用ungetc将字符再压回流中。（一次一个字符）  

    ```c
    #include <stdio.h>
    int ungetc(int c, FILE *fp);
    /* 返回值：成功c，出错EOF */
    ```
    应用场景：需要先查看一下下一个字符，在决定如何处理当前字符。

   6.2 输出函数  

   ```c
   #include <stdio.h>
   int puc(int c, FILE *fp);    /* 可实现宏 */
   int fputc(int c, FILE *fp);  /* 不可实现宏 */
   int putchar(int c);          /* 等效于putc(c, stdout) */
   /* 返回值：成功c，出错EOF */
   ```
7. 每次一行I/O  

<br>  

[返回主目录]: /2014/09/22/notes-of-apue.html

[5.4]: /images/apue/5.4.png "buf change"
