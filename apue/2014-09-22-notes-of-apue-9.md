---
layout: post
title: Notes of APUE 9
---

#{{ page.title }}  
<p class="meta">03 Nov 2014 - Guangzhou</p>   
+++++++++++++++++  

###[返回主目录][]  
<br>

##Chapter 9: 进程关系
1. 引言  
　　本章详细说明进程组以及POSIX.1引入的会话的概念。  
　　登录shell（登录时调用的）和“所有从‘登录shell’启动的进程”之间的关系。  
　　在讨论进程关系时会谈及到信号。  

2. 终端登录  
　　终端登录到UNIX系统，过程是类似的，与所使用的终端无关（基于字符的终端，简单的基于字符终端的图形终端，窗口系统的图形终端）  
    1. BSD终端登录  
　　init进程读文件/etc/ttys，为每一个允许登录的终端设备，调用一次fork，在init的子进程通过exec执行getty程序。getty为终端设备调用open函数，等用户输入就用户名后，getty完成工作，最后调用login（以下方式：`execle("/bin/login", "login", "-p", username, (char *)0, envp);`）  
　　![img][9.2]  
　　上图底部三个进程的进程ID相同，且父进程都是ID为1的init进程。  
　　用户正确登录后，login执行以下工作：  
　　①chdir把当前工作目录更换为用户的起始目录；  
　　②chown改变该终端的所有权为登录用户；  
　　③访问权限改为读和写；  
　　④setgid及initgroups设置进程的组ID；  
　　⑤将login得到信息用来初始化环境：起始目录（HOME）、shell（SHELL）、用户名（USER和LOGNAME）、系统默认路径（PATH)；  
　　⑥将login进程改变为登录用户的用户ID（setuid)，并这样调用该用户的登录shell（`execl("/bin/sh", "-sh", (char *)0);`）。  
　　到此为止，登录用户的登录shell开始运行，并读取其“启动文件”（如.bash_profile）。  
    2. Mac OS X终端登录  
　　Mac OS X部分基于FreeBSD，登录进程的工作步骤与BSD相同，但是Mac OS X一开始提供图形终端。  
    3. Linux终端登录  
　　非常类似与BSD，主要区别在于说明终端配置的方式。（/etc/inittab包含配置信息，说明了init应该为之启动getty进程的各终端设备）。  
    4. Solaris终端登录  
　　两种方式：①前面所说的getty；②ttymon登录（区别是用户登录shell的父进程是ttymon，而在getty中是init）  

3. 网络登录  
　　“网络登录”和“串行终端登录”主要区别（physically）是：网络登录时，终端和计算机不是点对点连接的，login只是作为一种**服务**。  
    1. BSD终端登录  
　　有一个inetd进程（或称为因特网超级服务器），等待大多数网络连接。inetd等待TCP/IP连接请求到到主机，有一个请求到达时，就fork一次，生成与请求相关的子进程响应。  
　　系统启动时，init调用shell，执行shell脚本/etc/rc，从而启动inetd守护进程，脚本终止后，inetd的父进程就变成init。  
　　telnet请求客户启动TELNET**客户进程**（`>telnet hostname`），打开一个到hostname主机的TCP连接，hostname主机运行者TELNET**服务进程**。下图是TELNET服务进程（称为telnetd）执行情况，telnetd进程打开一个**“伪终端”**（终端login和网络login都能处理的软件驱动程序），fork成两个进程，父进程 处理网络连接的通信，子进程执行login程序。父子进程通过伪终端连接。  
　　![img][9.3]  
    2. Mac OS X终端登录  
　　Mac OS X部分基于FreeBSD，网络登录的工作步骤与BSD完全相同。  
    3. Linux终端登录  
　　xinetd代替inetd，更精细。其他与BSD相同。  
    4. Solaris终端登录  
　　与Linux步骤几乎一致，但inetd有附加能力：在服务访问设施框架下运行。  

4. 进程组  
　　进程组是一个或多个进程的集合。关联与同一作业，接收同一终端的信号。`pid_t`数据类型存放唯一的进程组ID，getpgrp()返回进程组ID。  

    ```c
    #include <unistd.h>

    pid_t getpgrp(void);
    /* 返回值：调用进程的进程组ID */
    ```
　　**组长进程**（标识：pid==pgid）：可创建进程组、组内进程。  
　　进程组的生存期：进程组创建到最后一个进程离开/终止（不一定是组长进程）。setpgid()创建一个新进程组或加入现有的组。  

    ```c
    #include <unistd.h>

    int setpgid(pid_t pid, pid_t pgid);
    /* 
     * 将pid进程拉入到pgid组，若参数pid==pgid，则pid进程成为组长进程。
     * 若pid==0, 则使用调用者的pid；若pgid==0，则把pid设为pgid。 
     * 一个进程只能为自己或子进程setpgid，且要在子进程调用exec之前
     */
    /* 返回值：成功0，出错-1 */
    ```

5. 会话  
　　session是一个或多个**进程组**，通常由shell的管道线`|`将几个进程编成一组。进程调用setsid()建立一个新会话。  

    ```c
    #include <unistd.h>

    pid_t setsid(void);
    /* 返回值：成功返回进程组pgid，出错-1 */
    ```
　　若调用setsid()的进程pi不是一个进程组的组长，则setsid()之后：  
　　①该进程pi成为session leader（会话首进程，创建session的进程），且进程pi是新会话的only进程；  
　　②进程pi成为一个新的进程组的组长，且进程组pgid==进程pi的进程id；  
　　③进程pi没有控制终端，若调用setsid()之前已有，则也会被中断。
　
    ```c
    #include <unistd.h>

    pid_t getsid(pid_t pid);
    /* 
     * 返回值：
     * 成功：session leader的进程组pgid
     * 出错：-1
     */
     ```
 
6. 控制终端  
　　①一个session可以有一个controlling terminal（终端设备（终端登录）或伪设备（网络登录））  
　　②建立“与controlling terminal连接”的session leader被称为controlling process  
　　③一个session的可以有前台进程组（foreground process group）和后台进程组（background）  
　　④无论何时，若raise一个中断信号（终端中断键），该信号会发送给前台进程组的所有进程。  
　　⑤无论何时，若raise一个退出信号（终端退出键），该信号会发送给前台进程组的所有进程。  
　　⑥modem（或网络）断开连接，raise一个挂断信号，该信号会发送个控制进程（session leader）  
　　在内核中，/dev/tty是控制终端的同义语。  
　　下图显示控制终端的进程组和会话：  
　　![img][9.6]  

7. tcgetpgrp、tcsetpgrp和tcgetsid函数  
    
    ```c
    #include <unistd.h>

    pid_t tcgetpgrp(int fd);
    /* 返回值：
     * 成功：与文件描述符fd关联的控制终端的前台进程组的进程组pgid
     * 出错：-1
     */
    
    int tcsetpgrp(int fd, pid_t pgrpid)
    /* 返回值：
     * 成功：0
     * 出错：-1
     */

    #inlcude <termios.h>
    pid_t tcgetsid(int fd);
    /* 返回值：
     * 成功：session leader的进程组pgid
     * 出错：-1
     */
    ```

8. 作业控制  
　　三个特殊字符可使“终端驱动程序”产生信号，送至“前台进程组”的所有进程，后台进程组不受影响。这三个字符分别是：
　　①中断字符（Ctrl+C）产生SIGINT  
　　②退出字符（Ctrl+\）产生SIGQUIT  
　　③挂起字符（Ctrl+z）SIGTSTP  
　　若后台作业试图读取终端，则终端驱动程序发现后会向后台作业发送SIGITIN信号，暂停后台作业。  
　　`fg %作业号[i]`使作业i置入前台进程组（tcsetpgrp()），同时，将SIGCONT（继续信号）送给进程组。
　　若后台作业试图写终端（默认可以），用户可用stty(1)命令禁止，直至fg(1)命令调入前台进程组，向作业发送SIGTTOU信号。  
　　下图总结了前后台进程组与终端驱动程序的作业控制：  
　　![img][9.8]  

9. shell执行程序  




<br>  

[返回主目录]: /2014/09/22/notes-of-apue.html
[9.2]: /images/apue/9.2.png "init for terminal login"
[9.3]: /images/apue/9.3.png "telnetd"
[9.6]: /images/apue/9.6.png "controlling terminal"
[9.8]: /images/apue/9.8.png "job control"
