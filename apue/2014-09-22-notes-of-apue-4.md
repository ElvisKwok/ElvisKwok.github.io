---
layout: post
title: Notes of APUE 4
---

#{{ page.title }}  
<p class="meta">22 Sep 2014 - Guangzhou</p>   
+++++++++++++++++  

##[返回主目录][]  
<br>

##Chapter 4: 文件和目录
1. 引言  
    本章将描述文件系统的其他特征和文件的性质。通过stat函数介绍stat结构的每一个成员（文件的所有属性）。修改这些属性的函数（更改所有者、权限）。查看UNIX文件系统的结构和符号链接。目录操作，编写一个降序遍历目录层次结构的函数。  
2. stat、fstat和lstat函数  
    
    ```c
    #include <sys/stat.h>
    int stat(const char *restrict pathname, struct stat *restrict buf); 
    /* according to filename */
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
    * 实际用户（组）ID
    * 有效用户（组）ID（用于文件访问权限检查）
    * 保存的设置用户ID（有exec函数保存）（如普通用户获得该文件的root权限）  
5. 文件访问权限  
    取自`<sys/stat.h>`的9个访问权限位，如下表所示：  
    ![img][4.5]  
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
   * 绝对设置：S\_IRUSR,S\_IWUSR等等“或”作为chmod参数mode  
10. 粘住位  
    S\_ISVTX位首先是粘住位（sticky bit），后来称为保存正文位（saved-text bit)  
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
    磁盘=n个分区，每个分区可以包含一个文件系统，如下图  
    ![img][4.14.1]  
    文件链接:  
    @ 硬链接（链接计数减为0才可删除，删除一个目录项的函数被称为unlink而不是delete）  
    @ 符号链接（实际内容为目标文件名字）  
    * i节点
    * 指向i节点的目录项  
    两者关系如下图所示  
    ![img][4.14.2]  
    i节点是固定长度的记录项，包含有关文件的大部分信息，stat结构大多数信息取自i节点（除了存放在目录项的文件名和i节点编号外）  
    执行`mv`命令改名，文件内容没有移动，新建一个指向i节点的目录项，然后解除旧目录项的链接  
    对目录文件的链接计数：`.`,`..`，每一个目录的链接计数至少为2（命名该目录的目录项，目录底下的 `.`）父目录的每个子目录都会使该父目录的链接计数加1（子目录含有`..`）  
15. link、unlink、remove和rename函数  
    
    ```c
    #include <unistd.h>
    int link(const char *existingpath, const char *newpath);
    int unlink(const char *pathname);
    /* 返回值：成功返回0，否则-1; */
    ```
    link函数创建的是硬链接，创建新的目录项和增加链接计数是原子操作，而且一般要求在同一个文件系统。  
    unlink用于**删除**一个现有的目录项,并将pathname所引用文件的链接计数减去1，当链接计数达到0时，文件的内容才可被删除（若有进程打开该文件，则文件内容也不能被删除）。  
    关闭一个文件时，内核先检查打开该文件的进程数，达到0，再检查链接计数，若也是0，就删除该文件的内容。  
    unlink函数要求对该目录项所在目录具有w和x权限，而且若设置了sticky位，还需4.10节所示的三个条件之一。  
    remove函数可解除对一个文件或目录的链接， rename函数改名文件或目录。  
    
    ```c
    #include <stdio.h>
    int remove(const char *pathname);
    int rename(const char *oldname, const char *newname);
    /* 返回值：成功返回0，出错-1 */
    ```
16. 符号链接  
    硬链接直接指向文件的i节点，限制：要求文件和链接在同一个文件系统；超级用户才可创建指向目录的硬链接。  
    符号链接对指向的对象和文件系统不限制。甚至不要求符号链接所指向的文件存在。  
    函数对符号链接的处理可分为“跟随符号链接”和“不跟随符号链接”（引用链接本身，而不是该链接所指向的文件）。如下表所示：   
    ![img][4.16]  
    note: 使用符号链接可能在文件系统中引入循环，如：`ln -s ../foo foo/testdir`，这种循环可用unlink消除（unlink不跟随符号链接）。若是硬链接构成的循环，则很难消除，所以超级用户才允许执行link函数构建“指向目录的硬链接”  
17. symlink函数和readlink函数  
    symlink函数创建一个符号链接
    readlink函数解决以下问题：因为open函数跟随符号链接（打不开链接**本身**），所以可以使用readlink打开链接**本身**  

    ```c
    #include <unistd.h>
    int symlink(const char *actualpath, const char *sympath);
    /* 返回值：成功返回0， 出错-1 */
    ssize_t readlink(const char *restrict pathname, char *restrict buf,
                     size_t bufsize);
    /* 返回值：成功返回读到的字节数，出错-1 */
    ```
18. 文件的时间  
    每个文件都保留三个时间字段，如下表所示：  
    ![img][4.18]  
    note: st_ctime是**i节点状态**更改时间，st_mtime是**文件内容**的修改时间  
19. utime函数  
    utime函数可以更改文件的访问和修改时间（日历时间）。  
    
    ```c
    #include <utime.h>
    int utime(const char *pathname, const struct utimbuf *times);
    /* 返回值：成功0，出错-1 */
    /* 若times为NULL，则设为当前时间；（要求进程的有效用户ID==文件所有者ID，或进程有w权限） */
    /* 若times非空，则设置为times所指向的结构中的值（2个）;
      （要求进程的有效用户ID==文件所有者ID，或进程是超级用户（有w权限不够））
    */ 
    struct utimbuf {
        time_t actime;
        time_t modtime;
    }
    ``` 
    示例程序：open截短文件长度为0，不更改atime和mtime。方法：先`stat()`保存之前时间，再截短，最后使用utime复位时间。  
    ![img][4.19]  
    程序结果：atime和mtime不变，而“更改状态时间”ctime改为程序运行的时间。  
20. mkdir和rmdir函数  

    ```c
    #include <sys/stat.h>
    int mkdir(const char *pathname, mode_t mode)
    ```
    mkdir函数创建一个空目录，其中目录项`.`,`..`是自动创建的。**常见错误**：目录忘了设置x权限，用来访问目录中的文件名。  
    rmdir函数删除一个**空**目录（只包含目录项`.`,`..`）

    ```c
    #include <unistd.h>
    int rmdir(const char *pathname);
    /* 返回值：成功0，出错-1 */
    ```
21. 读目录
    
    ```c
    #include <dirent.h>
    DIR *opendir(const char *pathname); 
    /* 返回值：成功返回指针DIR *dp，出错NULL */
    
    struct dirent *readdir(DIR *dp); 
    /* 返回值：成功返回指针dirent struct *dirp ，出错或在目录结尾返回NULL */
    
    void rewinddir(DIR *dp);
    int closedir(DIR *dp); /* 返回值：成功0，出错-1 */
    long telldir(DIR *dp); /* 返回值：与dp关联的目录中的当前位置 */
    void seekdir(DIR *dp, long loc);
    ```
    dirent结构至少包含的成员
    
    ```c
    struct dirent {
        ino_t d_ino;            /* i-node number */
        char d_name[NAME_MAX+1];
    }
    ```
    DIR是内部结构，上述6个函数用这个内部结构保存当前正被读的目录有关信息。  
    编写程序遍历文件层次结构，并统计4.3节的文件类型  



[返回主目录]: /2014/09/22/notes-of-apue.html

[4.2]: /images/apue/4.2.png "struct stat"
[4.5]: /images/apue/4.5.png "permission"
[4.14.1]: /images/apue/4.14.1.png "disk, partition and file system"
[4.14.2]: /images/apue/4.14.2.png "inode and directory item pointing to inode"
[4.16]: /images/apue/4.16.png "symbol link"
[4.18]: /images/apue/4.18.png "file time"
[4.19]: /images/apue/4.19.png "4-19.c"
