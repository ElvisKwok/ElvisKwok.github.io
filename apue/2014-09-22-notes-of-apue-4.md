---
layout: post
title: Notes of APUE 4
---

#{{ page.title }}  
<p class="meta">22 Sep 2014 - Guangzhou</p>   
+++++++++++++++++  

##Chapter 4: 文件和目录
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
9. chmod和fchmod函数  
    
    ```c
    #include <sys/stat.h>
    int chmod(const char *pathname, mode_t mode);  /* 指定的文件 */
    int fchmod(int fd, mode_t mode);               /* 已打开的文件 */
    /* 成功返回0，出错-1 */
    ```
   要改变文件的权限位，进程的有效用户ID必须等于文件的所有者ID、或必须具有root权限。  
   两种方法设置mode：
   * 先用stat("pathname", &statbuf)，再statbuf.st\_mode & ~S\_IXGRP作为chmod参数mode
   * 绝对设置：S_IRUSR,S_IWUSR等等“或”作为chmod参数mode  
10. 粘住位  
    S_ISVTX位首先是粘住位（sticky bit），后来称为保存正文位（saved-text bit)
    程序第一次执行时文件的副本保存在交换区，便于下次执行  
    如果对一个目录设置了粘住位，则只有对目录具有w权限的用户在满足下列条件之一，才能rm或mv目录文件：  
    * 拥有此文件
    * 拥有此目录
    * 是超级用户
    典型例子：/tmp /var/spool/uucppublic，任何用户可在这两个目录创建文件，但不能删除和改名别人的文件
11. chown、fchown和lchown函数   
    
    ```c
    #include <unistd.h>
    int chown(const char *pathname, uid_t owner, gid_t group);
    int fchown(int fd, uid_t owner, gid_t group);
    int lchown(const char *pathname, uid_t owner, gid_t group);
    /* lchown 改变符号链接，而不是链接指向的文件 */
    /* 成功返回0，出错-1 */
    ```
12. 文件长度  
    stat结构成员st_size表示以**字节**为单位的文件长度  
    * 普通文件，长度可为0,
    * 目录通常是一个数的倍数
    * 符号链接，文件长度是“文件名”的字节数（符号链接**自身文件内容**就是目标文件的文件名），如lib-> usr/lib, 符号链接lib的长度7，（“usr/lib“7个字符）  
13. 文件截短  
    有时我们需要在文件尾端截去一些数据以缩短文件，打开文件时使用O_TRUNC可做到这一点  

    ```c
    #include <unistd.h>
    int truncate(const char *pathname, off_t length);
    int ftruncate(int fd, off_t length);
    /* 将文件截短为length字节，成功返回0，出错-1 */
    ```
14. 文件系统  
    UNIX文件系统：本节讨论UFS文件系统（UNIX file system），UFS是以BSD快速文件系统为基础的  
    文件链接（硬链接（链接计数减为0才可删除，删除一个目录项的函数被称为unlink而不是delete），符号链接（实际内容为目标文件名字））  
    * i节点
    * 指向i节点的目录项  
    i节点是固定长度的记录项，包含有关文件的大部分信息，stat结构大多数信息取自i节点（除了存放在目录项的文件名和i节点编号外）  
    执行`mv`命令改名，文件内容没有移动，新建一个指向i节点的目录项，然后解除旧目录项的链接  
    对目录文件的链接计数：`.`,`..`，每一个目录的链接计数至少为2（命名该目录的目录项，目录底下的 `.`）父目录的每个子目录都会使该父目录的链接计数加1（子目录含有`..`）  
15. link、unlink、remove和rename函数  
    


[4.2]: /images/apue/4.2.png "struct stat"
