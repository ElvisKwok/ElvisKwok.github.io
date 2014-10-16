---
layout: post
title: Notes of APUE 6
---

#{{ page.title }}  
<p class="meta">16 Oct 2014 - Guangzhou</p>   
+++++++++++++++++  

###[返回主目录][]  
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

3. 阴影口令  
    阴影口令文件`/etc/shadow`通常是有setID为root的程序才能存取，如login(1)和passwd(1)。有一组函数可用于访问阴影口令文件。  

    ```c
    #include <shadow.h>
    
    struct spwd *getspnam(const char *name);
    struct spwd *getspent(void);
    /* 返回值：成功返回指针，出错NULL */
    
    void setspent(void);
    void endspent(void);
    ```

4. 组文件  
    下列两个由POSIX.1定义的函数来查看组名或数值组ID。

    ```c
    #include <grp.h>

    struct group *getgrgid(git_t gid);
    struct group *getgrnam(const char *name);
    /* 返回值：成功返回指向一个静态变量的指针，出错NULL */
    ```
    搜索整个组文件(Single UNIX Specification的XSI扩展)：  

    ```c
    #include <grp.h>

    struct group *getgrent(void);
    /* 返回值：成功指针，出错或文件结尾返回NULL */

    void setgrent(void);    /* 打开组文件并“反绕” */
    void endgrent(void);
    ```

5. 附加组ID  
    使用附加组ID的优点是不必显式地经常更改组。获取和设置附加组ID的三个函数：  
    
    ```c
    #include <unistd.h>
    
    int getgroups(int gidsetsize, gid_t grouplist[]);
    /* 将各个附加组ID写入数组grouplist中，该数组存放元素个数最多为gidsetsize */
    /* 返回值：成功返回实际填写的附加组ID数目，出错-1 */
    
    #include <grp.h>        /* on Linux */
    #include <unistd.h>     /* on FreeBSD, Mac Os X, and Solaris */
    
    int setgroups(int ngroups, const gid_t grouplist[]);
    int initgroups(const char *username, gid_t basegid);    /* not available on Solaris */
    /* 返回值：成功0，出错-1 */
    ```

6. 实现的区别  

7. 其他数据文件  
    一般数据文件都有这3个函数变体：
    * get，读下一个记录（可顺便打开文件），返回指向静态结构的指针（要保存其内容，需要复制它），文件结尾返回NULL。
    * set，打开数据文件（若还没打开），然后“反绕”该文件。常用于希望在文件起始处开始处理的情况。
    * end，关闭数据文件。  
    另外，有些“搜索指定关键字的记录”的例程。如getpwnam()寻找指定用户名的记录，getpwduid()寻找指定用户ID的记录。  
    ![img][6.7]

8. 登录账户记录  
    utmp文件记录当前登录进系统的各个用户。wtmp文件跟踪各个登录和注销事件。这两个文件的结构记录为：  

    ```c
    struct utmp {
        char ut_line[8];    /* tty line: "ttyh0"... */
        char ut_name[8];    /* login name */
        long ut_time;       /* seconds since Epoch */
    };
    ```
    登录时，login程序填写此类型结构，然后写入utmp文件中，也append到wtmp文件中。注销时，init进程将utmp文件相应记录erase。append一个注销记录在wtmp文件中。  
    who(1)程序读utmp文件，last(1)读wtmp文件。  

9. 系统标识  
    POSIX.1定义的uname函数，返回与当前主机和os有关信息。  

    ```c
    #include <sys/utsname.h>
    
    int uname(struct utsname *name);
    /* 返回值：成功非负，出错-1 */
    ```

    只返回主机名的函数。hostname(1)命令可获取和设置主机名  
    
    ```c
    #include <unistd.h>
    
    int gethostname(char *name, int namelen);
    /* namelen是缓冲区name的长度 */
    /* 返回值：成功0，出错-1 */
    ```

10. 时间和日期例程  
    日历时间包含时间和日期。内核提供的基本时间服务是从UTC 1970.1.1 00:00:00以来的秒数，用数据类型time_t表示。  
    time()返回当前时间和日期。  

    ```c
    #include <time.h>

    time_t time(time_t *calptr);
    /* 返回值：成功返回时间值，出错-1 */
    ```
    gettimeofday()提供了微秒级的精确度。  

    ```c
    #include <sys/time.h>

    int gettimeofday(struct timeval *restrict tp, void *restrict tzp);
    /* 该函数将当前时间存放在tp指向的timeval结构中*/
    /* tzp的唯一合法值是NULL */
    /* 返回值：总是返回0 */
    ```
    timeval结构：

    ```c
    struct timeval {
        time_t tv_sec;      /* seconds */
        long tv_usec;       /* microseconds */
    }
    ```
    获得秒数后，通常调用函数转换为可读的时间日期。各个时间函数的关系如下图所示：  
    ![img][6.10.1]  
    可读时间用一个tm结构存放：  
    ![img][6.10.2]
    接下来分别介绍gmtime(), localtime(), mktime(), asctime(), ctime(), strftime()  

    ```c
    #include <time.h>

    struct tm *gmtime(const time_t *calptr);        /* utc时间 */
    struct tm *localtime(const time_t *calptr);     /* 本地时间 */
    /* 返回值：指向tm结构的指针 */
    
    time_t mktime(struct tm *tmptr);        /* 以本地时间的年月日为参数 */
    /* 返回值：成功返回日历时间，出错-1 */

    char *asctime(const struct tm *tmptr);  /* 指向年月日等字符串的指针 */
    char *ctime(const time_t *calptr);      /* 参数：指向日历时间的指针calptr */
    /* 两个函数产生类似与date(1)命令的输出 */
    /* 返回值：指向null结尾的字符串指针 */

    size_t strftime(char *restrict buf, size_t maxsize,
                    const char *restrict format,
                    const struct tm *restrict tmptr);
    /* 格式化结果存放在大小为maxsize的buf数组 */
    /* format控制时间值的格式，类似与printf的%后面 */
    /* 参数tmptr是要格式化的时间值 */
    /* 返回值：有空间? 存入数组的字符数: 0；*/
    ```

11. 小结  
    * 本章说明了读“口令文件”和“组文件”的各种函数。
    * 也介绍了阴影口令，增加系统安全性。
    * 附加组ID使得用户可以同时参加多个组。
    * 还介绍了存取其他系统数据文件的类似函数。
    * 系统标识函数uname()，hostname()等等。
    * 时间和日期的一些函数。

<br>  

[返回主目录]: /2014/09/22/notes-of-apue.html
[6.7]: /images/apue/6.7.png "system data file"
[6.10.1]: /images/apue/6.10.1.png "relation of each time function"
[6.10.2]: /images/apue/6.10.2.png "struct tm"
