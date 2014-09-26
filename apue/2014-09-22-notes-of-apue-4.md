---
layout: post
title: Notes of APUE 4
---

#{{ page.title }}  
<p class="meta">22 Sep 2014 - Guangzhou</p>   
+++++++++++++++++  

##chapter 4: 文件和目录
1. 引言  
    本章将描述文件系统的其他特征和文件的性质。通过stat函数介绍stat结构的每一个成员（文件的所有属性）。修改这些属性的函数（更改所有者、权限）。查看UNIX文件系统的结构和符号链接。目录操作，编写一个降序遍历目录层次结构的函数  
2. stat、fstat和lstat函数  
    
    ```c
    #include <sys/stat.h>
    int stat(const char *restrict pathname, struct stat *restrict buf); 
    /* according filename */
    int fstat(int fd, struct stat *buf); 
    /* according to fd */
    int lstat(const char *restrict pathname, struct stat *restrict buf); 
    /* like stat(), available for symbol link file */

    /* 三个函数保存到buf结构， 函数返回值：成功返回0，出错返回-1 */
    ```  
    stat结构如下图所示：  
    ![img][4.2]  
3. 文件类型  
    文件类型信息包含在stat结构的st_mode成员中
    + 普通文件（regular file）
    + 目录文件（directory file）
    + 块特殊文件
    + 字符特殊文件
    + FIFO（命名管道named pipe，用于进程间通信）
    + 套接字
    + 符号链接
4. 设置用户ID和设置组ID  
    实际用户（组）ID，有效用户（组）ID（用于文件访问权限检查），保存的设置用户ID（有exec函数保存）（如普通用户获得该文件的root权限）  
5. 文件访问权限  
6. 新文件和目录的所有权  
    新文件的用户ID设置为进程的有效用户ID  
    新文件的组ID可以是进程的有效组ID，或所在目录的组ID  
7. access函数  
    access函数按实际用户（组）ID进行访问权限测试  
    
    ```c
    #include <unistd.h>
    int access(const char *pathname, int mode);
    /* 返回值：成功0，出错-1 */
    ```
8. umask函数  
    umask函数为进程设置“文件模式创建屏蔽字”，并返回以前的值  

    ```c
    #include <sys/stat.h>
    mode_t umask(mode_t cmask);
    ```


[4.2]: /images/apue/4.2.png "struct stat"
