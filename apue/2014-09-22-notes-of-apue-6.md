---
layout: post
title: Notes of APUE 6
---

#{{ page.title }}  
<p class="meta">16 Oct 2014 - Guangzhou</p>   
+++++++++++++++++  

##[返回主目录][]  
<br>

##Chapter 6: 系统数据文件和信息
1. 引言  
    例如，口令文件`/etc/passwd`和组文件`/etc/group`就是经常由多种程序使用的两个文件。  
    我们需要能够以非ASCII文本格式存放这些文件，但仍向应用程序提供可以处理任何一种文件格式的接口。   
    针对这些数据文件的可移植接口是本章的主题，本章还介绍系统标识函数、时间和日期函数。  

2. 口令文件  
    POSIX.1只定义了两个获取口令文件项的函数。给出用户登录名或数值用户ID，就能查询相关项。  

    ```c
    #include <stdio.h>

    struct passwd *getpwuid(uid_t uid);
    /* 由ls程序使用，它将数值用户ID映射为用户登录名 */
    struct passwd *getpwnam(const char *name);
    /* 处理登录名，它由login程序使用 */
    /* 返回值：成功则返回一个指向passwd结构的指针，出错NULL */
    ```
    以下3个函数可用于查看整个口令文件(Single UNIX Specification的XSI扩展)。  

    ```c
    #include <pwd.h>

    struct passwd *getpwent(void);
    /* 返回值：成功则返回指针，出错或文件结尾则返回NULL */

    void setpwent(void);    /* 定位到文件开始处（反绕）*/
    void endpwent(void);    /* 关闭口令文件 */
    ```

<br>  

[返回主目录]: /2014/09/22/notes-of-apue.html
