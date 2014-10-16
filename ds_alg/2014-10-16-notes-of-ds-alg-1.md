---
layout: post
title: Notes of Ds and Alg in C 1
---

#{{ page.title }}  
<p class="meta">16 Oct 2014 - Guangzhou</p>   
+++++++++++++++++  

###[返回主目录][]  
<br>

##Chapter 1: 引论
1. 本书讨论的内容  
    写出一个可以工作的程序并不够，对于大量的输入，如何估计程序的运行时间。彻底改变程序速度以及确定程序瓶颈的方法。
2. 数学知识复习  
    1. 指数
    2. 对数
    3. 级数
    4. 模运算。A与B模N同余(congruent)，如果(A-B) mod N == 0
    5. 证明方法
        1. 归纳证明
            * 基准情形(base case)
            * 归纳假设(inductive hypothesis) (≤k时)
            * 下一个值(k+1时)
        2. 反证法
3. 递归简论  
    1. base case
    2. making progress(to base case)
    3. design rule: every recursive calling can be run
    4. compound interest rule(合成效益法则): do not do the same thing repeatly in different recursion.


<br>  

[返回主目录]: /2014/10/16/notes-of-ds-alg.html
