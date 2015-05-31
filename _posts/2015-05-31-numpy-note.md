---
layout: post
title: NumPy Note
---

#{{ page.title }}  
<p class="meta">31 May 2015 - Guangzhou</p> 
+++++++++++++++++
<br>

---

* NumPy的对象是同类型元素的多维数组ndarray，通过元组索引。
* 在NumPy中，维度（dimensions）叫做轴（axes），轴的个数叫做秩（rank）。
* n维 = n个轴 = （秩=n）

---
ndarray对象属性:

* ndarray.ndim: 轴个数（维度、秩）
* ndarray.shape: （n,m,...)元组， 元组长度为秩
* ndarray.size: 元素总个数n*m
* ndarray.dtype: 元素类型
* ndarray.itemsize: 每个元素的字节大小（float64=8B, complex32=4B)

---
创建数组：

* a = array([1,2,3,4])
* 创建初始化的数组：  
全0：zeros((n,m,...)), 全1：ones((n,m,...)), 随机：empty((n,m,...))  
默认是float64类型，可人工指定，e.g., ones((2,3), dtype=int32)  
* arange(start, end, step)，步长step可以是浮点型, b=linspace(0,pi,3)0到pi之间的3个元素
* 其他：zeros\_like, ones\_like, empty\_like, rand, randn, fromfunction, fromfile 

---
基本运算：

* 算术运算以元素为单位执行，`a*b`把a，b数组元素对应相乘,`dot(a,b)`实现矩阵相乘
* a.sum(), a.min(), a.max(), d=exp(a)以e为底、a为指数的幂,sin,cos  
axis参数指定运算的轴，`b=ones(2,3)`,列的sum`b.sum(axis=0)`为array([2,2,2])，行的sum`b.sum(axis=1)`为array([3,3])
* 其他:all, alltrue, any, apply along axis, argmax, argmin, argsort, average, bincount, ceil, clip, conj, conjugate, corrcoef, cov, cross, cumprod, cumsum, diff, floor, inner, inv, lexsort, maximum, mean, median, minimum, nonzero, outer, prod, re, round, sometrue, sort, std, trace, transpose, var, vdot, vectorize, where

---
索引，切片，迭代：  

* 多维数组可以是每个轴一个索引，索引用逗号隔开。如`a=arange(9).reshape(3,3)`, a[0:1,2]输出row0和row1的column2，a[:,1]输入所有row的column1
* 索引个数少于轴数时，缺失的索引被认为是整个切片`:`,如`b[-1]`相当于`b[-1,:]`
* 多维数组的迭代的是第一个轴,`for row in a: print row`。若要遍历所有元素，可用`for element in a.flat: print element,`

---
改变形状：

* a.ravel() 展平为一维
* a.shape=(m,n,...)，a.reshape(m,n,...), a.resize((m,n...))
* a.transpose()转置

---
组合、分割：

* stack组合不同数组: vstack()纵向(沿着第一个轴),hstack(),column\_stack(),row_stack(),concatenate()
* split分割成几个小数组: vsplit,hsplit,array split

---
复制、视图view：

* 视图（浅复制）： `c=a.view()`，`c is not a`返回true，c的shape改变不影响a，c元素值改变会影响a

---
函数目录：

* 创建数组：  

```
arange, array, copy, empty, empty_like, eye, fromfile, fromfunction, identity, linspace, logspace, mgrid, ogrid, ones, ones_like, r , zeros, zeros_like 
```

* 转化：

```
astype, atleast 1d, atleast 2d, atleast 3d, mat 
```

* 操作：

```
array split, column stack, concatenate, diagonal, dsplit, dstack, hsplit, hstack, item, newaxis, ravel, repeat, reshape, resize, squeeze, swapaxes, take, transpose, vsplit, vstack 
```

* 询问：

```
all, any, nonzero, where 
```

* 排序：

```
argmax, argmin, argsort, max, min, ptp, searchsorted, sort 
```

* 运算：

```
choose, compress, cumprod, cumsum, inner, fill, imag, prod, put, putmask, real, sum 
```

* 基本统计：

```
cov, mean, std, var
```

* 基本线性代数

```
cross, dot, outer, svd, vdot
```

---
参考网址:

* [NumPy的详细教程][]基础篇
* [Python中的Numpy入门教程][]

[NumPy的详细教程]: http://www.tuicool.com/articles/r2yyei
[Python中的Numpy入门教程]: http://www.jb51.net/article/49397.htm
