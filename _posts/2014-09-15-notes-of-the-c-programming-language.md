---
layout: post
title: Notes of the C Programming Language
---

#{{ page.title }}  
<p class="meta">15 Sep 2014 - Guangzhou</p> 

========================================================   
<br>
##chapter 1: 导言
1. 变量、算术表达式;基本数据类型
2. `for`语句;
3. 符号常量;`#define` 大写名字 被替换文本
4. 字符输入/输出;`c = getchar();` `putchar(c);` `EOF`
5. 数组;
6. 函数;
7. 参数传值;
8. 字符数组;
9. 外部变量、作用域;  
<br>

##chapter 2: 类型、运算符与表达式
1. 变量名;
2. 数据类型及长度;
3. 常量;整数常量;结尾`l/L,u/U`;前缀 `0,0x`;字符常量是一个整数;字符串常量
4. 声明;`const`不能修改
5. 算术运算符;
6. 关系运算符与逻辑运算符
7. 类型转换;隐式(自动)(`char,short￫int`、其中一个float则另外一个提升为float。。。);强制`(int)n`, n本身的值没有改变
8. 自增自减运算符;
9. 按位运算符;`&|^异或<< >>~`; 部分位:清零`&0`,置1`|1`,求反`^1`
10. 赋值运算符与表达式; `+=,-=,/=,*=,>>=`
11. 条件表达式`z = (a > b) ?a : b;`
12. 运算符优先级与求值次序(结合性)  
<br>

##chapter 3: 控制流
1. 语句与程序块;语句结束符; 
2. `if-else`语句;配对
3. `else-if`语句;
4. `switch`语句; `break`
5. `while`循环`for`循环;
6. `do-while`循环;
7. `break`、`continue`;
8. `goto`语句与标号;常用于深度嵌套的跳出;维护可读性差  
<br>

##chapter 4: 函数与程序结构
1. 函数的基本知识；
2. 返回非整型值的函数；`atof`科学表示法123.45e-6, %g是什么
3. 外部变量；
4. 作用域规则；
5. 头文件；
6. 静态变量；只被初始化一次；`static`可限定外部变量and函数，使得其他文件无法访问
7. 寄存器变量；取决于底层硬件环境、编译器，寄存器变量的数目类型有所限制
8. 初始化； 外部变量和静态变量初始化为0（没有显式初始化的情况下）
9. 递归；
10. C预处理器；文件包含`#include`、宏替换`#define`、条件包含   
<br>

##chapter 5: 指针与数组
1. 指针与地址；
2. 指针与函数参数；
3. 指针与数组；`*(a+i)` is `a[i]`；数组名不是变量，指针是一个变量
4. 地址算术运算；`char *alloc(int n);` `void afree(char *p)`; `strlen` 
5. 字符指针与函数；`while( *s++ = *t++);`  `*s++`(先`*s`,再`s++`)
6. 指针数组以及指向指针的指针；字符串排序
7. 多维数组；逻辑表达式leap做数组下标； `int (*)a[10]` 指向数组的指针，这个指针指向具有10个元素的一维数组；`int *a[10]` 指针数组，数组的元素a[0]~a[9]都是指向int对象的指针
8. 指针数组的的初始化
9. 指针与多维数组；二维数组与指针数组的区别，空间分配，矩阵下标计算；指针数组优点每一行长度可以不同，常用于存放不同长度的字符串
10. 命令行参数；`int argc` 参数个数（包括执行的程序）. `char *argv[]`；printf的参数可以是表达式，如`printf((argc > 1) ? “%s “ : “%s”, *++argv)`;
11. 指向函数的指针`int (*pf)()；`qsort 命令行模式，`int (*comp)(void *, void *);` 返回指针的函数 `int *comp(void *, void *)；`
12. 复杂声明;编写程序输出字符串解释函数的声明  
<br>

##chapter 6: 结构
1. 结构的基本知识;结构有助于组织复杂数据，图像坐标表示；`struct`关键字+结构标记+\{结构声明\}；成员，成员运算符`.`; 初始化
2. 结构与函数;传递：分别传递各个结构成员、传递整个结构、传递指向结构的指针，各有利弊；指向结构的指针`struct rect *p;`, `p->x`==`(*p).x`；`++p->len`==`++(p->len)`
3. 结构数组; `struct key { char *word, int count;} keytab[NKEYS];`；编写一个统计c关键字的程序
4. 指向结构的指针; `mid = low + (high-low) /2`
5. 自引用结构; 统计所有单词出现次数，使用二叉树左右子树字典顺序
6. 表查找
7. 类型定义
8. 联合
9. 位字段  

***页码缺失6.5~6.9***   
<br>

##chapter 7: 输入与输出
1. 标准输入/输出; 输入/输出重定向`./a.out < infile`, `./a.out > outfile`；管道`1.exe | 2.exe`;
2. 格式化输出——printf函数；格式字符串包括普通字符和转换说明；
3. 变长参数表；mimprintf
4. 格式化输入——scanf函数；
5. 文件访问；文件指针，指向包含文件信息的结构（体），`FILE *fp`,`FILE`是一个类似int的类型名，由`typedef`定义; `int getc(FILE *fp)`,`int putc(intc, FILE *fp)`,实现filecopy；cat命令
6. 错误处理——`stderr`和`exit`; `feof`文件结尾则返回非0值
7. 行输入和行输出；`char *fgets(char *line, int maxline, FILE *fp)`从fp指向的文件读取一行，存放在line数组；`int fputs(char *line, FILE *fp)`将line字符串写入fp指向的文件，错误返回EOF、正确返回非负值；
8. 其他函数
    1. 字符串操作函数`strlen`, `strcpy`, `strcat`, `strcmp`,`strchr(s, c)`在s中找c第一次出现的位置
    2. 字符类别测试和转换函数;  
    `isalpha(c)`字母返回非0, `isupper(c)`,`islower(c)`,`isdigit(c)`,`isalnum(c)`数字或字母,`isspace(c)`,`toupper(c)`,`tolower(c)`
    3. `int ungetc(int c, FILE *fp)`将c写回文件fp，成功返回c，否则EOF
    4. 命令执行函数;`system("ls")`执行命令ls输出，然后继续执行当前程序
    5. 存储管理函数;`void *malloc(size_t n)`,分配成功返回指针，指向n个**字节**长度的未初始化的存储空间，否则返回NULL；`void *calloc(size_t n, size_t size)`, 指针指向n个**指定长度size的对象**的空间；  
     
    ```c
    int *ip;  
    ip = (int *) calloc(n, sizeof(int));
    ```    
    `free(p)`***只能释放由malloc或calloc得到的p***，使用已经释放的空间是典型错误，释放项目之前要保存必要信息，如暂存`q = p->next;`才`free(p)`  
    6. 数学函数都是double to double；`sin,cos,exp,log,pow,sqrt,fabs`  
    7. 随机数发生器函数; `rand()`生成0~RAND_MAX；  
    生成0~1`#define frand() ((double) rand() / (RAND_MAX+1.0))`

<br>

##chapter 8: UNIX系统接口
1. 文件描述符;文件描述符标识文件，非负整数，012(stdin, stdout, stderr)
2. 低级I/O——read和write；输入输出是通过read和write系统调用实现的；  
  `int n_read = read(int fd, char *buf, int n);` 文件描述符fd， 读写数据buf，传输字节数n；返回实际传输字节数  
  `int n_written = write(int fd, char *buf, int n);`  
   原书`#include "syscalls.h"`报错，`#include <sys/syscall.h>`ok；实现输入复制到输出；  
   用read和write构造getchar,putchar等高级函数  
3. open、creat、close和unlink
    `int fd; int open(char *name, int flags, int perms);`, 文件名name，打开方式flags，权限perms，如`#define PERMS 0755`, 返回文件描述符fd
    `int creat(char *name, int perms);`返回文件描述符
    close(int fd)断开文件描述符与已打开文件之间的连接，并释放文件描述符
    unlink(char *name)将文件name从文件系统删除
4. 随机访问——lseek; `long lseek(int fd, long offset, int origin);` origin可以0、1、2，分别是文件开始、当前、结束位置
5. 实例——fopen和getc函数的实现
6. 实例——目录列表；`opendir``readdir``closedir``Dirent``DIR``stat`
7. 实例——存储分配程序;`malloc``free`；malloc管理的空间不一定是连续的，空闲存储空间以空闲块链表组织，malloc返回的块=头部+分配空间；头部——块开始处的控制信息——“指向下一个空闲块的指针+size”，对齐——块大小为头部大小的整数倍，`union`实现——定义一个数据类型强制头部最坏情况下对齐align；“首次适应”（first fit）;sbrk函数；free函数释放的块若与空闲块相邻，则合并（设置指针，重设块大小）;  

声明（declaration）说明每个标识符的含义，不为标识符预留存储空间；定义（definition）是预留存储空间的声明
