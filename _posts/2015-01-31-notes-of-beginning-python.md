---
layout: post
title: Notes of Beginning Python
---

#{{ page.title }}  
<p class="meta">31 Jan 2015 - Shanwei</p> 
+++++++++++++++++
<br>
REPL: Read-Eval-Print Loop, an interactive toplevel or language shell  
中文：`# coding: utf-8`可加入修饰字符。  
# chapter 1
### 1. 数字与表达式  
`1/2 = 0`, `1.0/2.0或1/2.0或1/2. = 0.5`  
`from __future__ import division` 实现`/`现实算术除, `//`编程除  
`2.75 % 0.5 = 0.25`  
`-3**2 = -(3**2)`  
`0xAF = 175, 010 = 8`  



### 2. 变量、语句



### 3. 获取用户输入

```python
x = input("x:")
y = input("y:")
print x * y
```



### 4. 函数

`pow(2, 3), abs(-10), round(0.5) = 1`



### 5. 模块

```python
>>> import math
>>> math.floor(32.9)
32.0

>>> int(32.0)
32

>>> from math import sqrt
>>> sqrt(9)
3.0

# 查看一个模块的内容
>>> import math
>>> dir(math)
['...', '...', ...]
```

复数

```python
>>> import cmath
>>> cmath.sqrt(-1)
1j
```



### 6. 运行Python脚本
`#!/usr/bin/env python`  
`#`注释  



### 7. 字符串

```python
>>> "hello world"
'hello world'
>>> 1000L
1000L
>>> print "hello world"
hello world
>>> print 1000L
1000

>>> print repr(1000L)
1000L
>>> print str(1000L)
1000
>>> print repr("hello world")
'hello world'
>>> print str("hello world")
hello world
```

拼接字符串`+`  
value转换为字符串表示, str和repr 

* str: 将value转换为用户可理解的字符串。  
* repr: 将value转换为合法的Python表达式。  

反引号\`可实现`repr(x)`   

```python
>>> a = 12
>>> print "a is " + repr(a)
a is 12
>>> print "a is " + `a`
a is 12
```

#### 尽量使用raw_input
`name = input(What is your name? )` input要求用户输入合法的Python表达式，即`repr()`函数的值域。  

```
# wrong
What is your name? Elvis
# correct
What is your name? "Elvis"
```

`raw_input()`将所有的输入当成原始数据(raw data)，然后放入***字符串***中  

```python
>>> input("Enter a num: ")
Enter a num: 3
3
>>> raw_input("Enter a num: ")
Enter a num: 3
'3'
```



### 8. 长字符串、原始字符串和Unicode
#### 长字符串
```python
'''
这是
长
字符串
'''
```


#### 原始字符串
```python
# unexpectable. \n
>>> print 'C:\nob'
C:
ob
>>> print r'C:\nob'
C:\nob

>>> print 'Let\'s go'
Let's go
>>> print r'Let\'s go'
Let\'s go
```


#### Unicode
` print u'Hello world'`





# Chapter 2 列表、元组
### 1. 序列
* 容器container：包含其他对象的任意对象。序列、映射(如字典, key-value)、集合都是容器。  
* 序列是Python最基本的数据结构。  
* 6种内建的序列：列表、元组、字符串、Unicode字符串、buffer对象和xrange对象。  
* 列表可修改。  
* 序列操作：索引、分片、加、乘、检查元素是否属于序列的成员、迭代(依次操作每个元素)、计算长度、找出最大最小元素。  

#### 索引
`"hello"[-1] = 'o'`  


#### 分片
```python
# list_test[index1: index2: step_len]
# slice包含第一个索引，不含第二个索引
>>> numbers = [0, 1, 2, 3, 4, 5]
>>> numbers[0:2]
[0, 1]
>>> numbers[-3:-1]
[3, 4]
# 最后一个索引可以是越界
>>> numbers[3: 6]
[3, 4, 5]
# “索引1”不可在“索引2”右边
>>> numbers[-3:0]
[]
>>> numbers[3:2]
[]
# 捷径，索引置空
>>> numbers[-3:]
[3, 4, 5]
>>> numbers[:3]
[0, 1, 2]
# 整个序列
>>> numbers[:]
[0, 1, 2, 3, 4, 5]

# 步长可以是负数，表示从右往左提取元素
>>> numbers[::-1]
[5, 4, 3, 2, 1, 0]
```


#### 序列相加
加号`+`用于***“相同类型”***的序列的**连接**（list和list，string和string）  


#### 乘法
将序列重复n次, 其中一种用法：内建值None初试化空列表

```python
>>> sequence = [None] * 10
>>> sequence
[None, None, None, None, None, None, None, None, None, None] 
```


#### 成员资格 in运算符，返回True/False

```python
>>> 'w' in "permision: rwx"
True
>>> 'Elvis_ff' in ['Elvis', 'root', 'test']
False
```


#### 长度len、最小min最大值max

```python
>>> num = [1, 2, 3]
>>> print len(num), min(num), max(num)
3 1 3
```



### 2. 列表
#### list函数
```python
# 字符串 -> 列表
>>> result = list('hello')
>>> print result
['h', 'e', 'l', 'l', 'o']
# 列表 -> 字符串
>>> ''.join(result)
'hello'
```


#### 列表操作
除了通用的序列操作，还有一些改变列表的操作: 元素赋值，元素删除，分片赋值，列表方法。  

```python
# 元素赋值
>>> users = ['Alice', 'Bob', 'Cat']
>>> users[0] = 'Apple'
>>> users
['Apple', 'Bob', 'Cat']


# 元素删除
>>> del users[0]
>>> users
['Bob', 'Cat']


# 分片赋值, 多元素、可不等长的替换，可插入新元素，可通过分片赋值删除元素
>>> name = list('Perl')
>>> name
['P', 'e', 'r', 'l']
>>> name[1:] = list('ython')
>>> name
['P', 'y', 't', 'h', 'o', 'n']

# 插入
>>> num = [1, 5]
>>> num[1:1] = [2, 3, 4]
>>> num 
[1, 2, 3, 4, 5]

# 删除
# 类似del num[1:4], del步长可选
>>> num[1:4] = []
>>> num
[1, 5]


# 列表方法：对象.方法(参数)
# append
# lst.append(value), 原地修改！
>>> num = [1, 2, 3]
>>> num.append(4)

# count
# lst.count(value)
>>> x = [[1, 2], 1, 1, [1, 1, [1,2]]]
>>> x.count(1)
2
>>> x.count([1,2])
1

# extend
# lst1.extend(lst2), 末尾append一个序列(的元素)
# 区别于'+'连接：extend原地修改被扩展的序列，'+'返回全新序列
# a.extend(b) 效率高于 a = a + b和a[len(a):] = b
>>> a = [1, 2]
>>> b = [3, 4]
>>> a + b
[1, 2, 3, 4]
>>> a
[1, 2]
>>> a.extend(b)
>>> a
[1, 2, 3, 4]

# index
# lst.index(value), 根据value找index
>>> test = ['a', 'b']
>>> test.index('b')
1

# insert
# lst.insert(最终位置，值)
>>> num = [1, 2, 4]
>>> num.insert(2, 'three')
>>> num
[1, 2, 'three', 4]

# pop
# lst.pop(参数)，若参数为空，则移除最后一个。
# 唯一一个：修改列表并且返回元素值的列表方法！
# 实现队列:x.append(pop(0)), 更好的方法是使用collection模块的deque对象
>>> x = [1, 2, 3]
>>> x.pop()
3
>>> x
[1, 2]
>>> x.pop(0)
1
>>> x
[2]

# remove
# lst.remove(第一个匹配值)
>>> x = ['a', 'c', 'a', 'b']
>>> x.remove('a')
>>> x
['c', 'a', 'b']

# revese
# lst.reverse(), 原地修改，但不返回值
# reversed(lst)反向迭代，返回一个迭代器对象(iterator)
>>> x = [1, 2, 3]
>>> x.reverse()
>>> x
[3, 2, 1]
# 相当于 x = x[::-1]

# sort
# lst.sort(), 原地排序,不返回值
>>> x = [2, 1, 3]
>>> y = x.sort() # wrong
>>> y
None
# 副本
>>> x = [2, 1, 3]
>>> y = x[:]
>>> y.sort()
>>> x
[2, 1, 3]
>>> y
[1, 2, 3]
 # 指向同一个列表
>>> y = x       
>>> y.sort()
>>> x
[1, 2, 3]
>>> y 
[1, 2, 3]
# sorted函数
>>> x = [2, 1, 3]
>>> y = sorted(x)
>>> x
[2, 1, 3]
>>> y
[1, 2, 3]
>>> sorted('test')
['e', 's', 't', 't']

# 高级排序
# sort默认根据内建函数cmp进行比较，cmp(1,3)=-1,cmp(3,1)=1,cmp(1,1)=0
# sort()有两个可选的关键字参数——key和reverse
# sort(key = 某个函数)，为每个元素创建一个key，然后按照key排序
>>> x = ['apple', 'bob', 'is']
>>> x.sort(key=len)
>>> x
['is', 'bob', 'apple']
>>>[2, 1, 3].sort(reverse=True)
[3, 2, 1]
```



### 3. 元组：不可变序列

```python
>>> 1, 2, 3
(1, 2, 3)
>>> 3*(40+2,)
(42, 42, 42)
>>> 3*(40+2)
126

# tuple函数
>>> x = [1, 2, 3]
>>> tuple(x)
(1, 2, 3)
>>> tuple('abc')
('a', 'b', 'c')
>>> t = 1, 2, 3
>>> t[0:2]
(1, 2)
```
* 元组可作为映射的key，列表不行
* 元组作为内建函数和方法的返回值





# Chapter 3 字符串
字符串不可变。  
### 1. 字符串格式化%
形式：`字符串str` % `匹配格式`   
%{空白}±“宽度”.“精度”"类型"，空白用于对齐正负数，在正数前面加空格  

```python
>>> s = "%d + %d = 5"
>>> values = (1, 4)
>>> print s % values
1 + 4 = 5
>>> format = "pi with three decimals: %.3f"
>>> from math import pi
>>> print format % pi
pi with three decimals: 3.142
```
用`%%`表示%。  

```python
# 模板字符串, Template模板化，substitute用关键字foo替换$foo
>>> from string import Template
>>> s = Template('A $thing must $action.')
>>> s.substitute(thing='man', action='study')
A man must study
>>> d = {}
>>> d['thing'] = 'man'
>>> d['action'] = 'eat'
>>> s.substitute(d)
A man must eat
```

![img][3.1]

```python
>>> 'using str: %s' % 42L
'using str: 42'
>>> 'using repr: %r' % 42L
'using repr: 42L'
# *使用元组第一个元素提供的字段宽度
>>> '%.*s' % (5, 'Guido van Rossum')
'Guido'
```



### 2. 字符串方法
字符串常量: string.digits, string.letters, string.lowercase, string.uppercase, string.printable, string.punctation。  

```python
# find
# str.find(value, begin, end)，返回子串最左的索引，找不到返回-1
# 相关：rfind反向搜索返回正向索引, index, rindex, count, startswith, endswith
>>> 'Hello world'.find('or')
7

# join
# str.join(字符串元素序列), 是split的逆
>>> dirs = '', 'usr', 'bin', 'env' # 第一个留空，表示分隔符左为空，这样分隔符就在最左有一个
>>> '/'.join(dirs)
'/usr/bin/env'
>>> print 'C:'+'\\'.join(dirs)
C:\usr\bin\env

# split
# str.split(分隔符), 若分隔符为空，则使用空格(' '或'\t'或'\n')作为分隔符
>>> '/usr/bin/env'.split('/')
['', 'usr', 'bin', 'env']

# strip
# str.strip(要删除的每个独立字符组成的字符串), 参数为空表示' '
# 只能删除左右两侧！！
>>> '  **   test *  test     !!'.strip('!* ')
'test *  test'

# replace
# str.replace('from', 'to')

# tranlate
# 与replace不同，translate可以替换多个匹配的“独立单字符”
# 首先使用string模块的maketrans函数制作一张转换表(ASCII字符集)
>>> from string import maketrans
>>> table = maketrans('cs', 'kz')
>>> len(table)
256
>>> table[97:123]
'abkdefghijklmnopqrztuvwxyz'
>>> "this is a test".translate(table)
'thiz iz a tezt'

# lower
# str.lower(), 常用于不区分大小写的匹配
# if user.lower() in users: print 'Found it'
# 相关：islower, capitalize句首大写, swapcase逐个相反\ 
# title首字母大写, istitle, upper, isupper
# 另一种方法：使用string模块的capwords函数
>>> import string
>>> string.capwords("that's all, folks")
"That's All. Folks"
```





# Chapter 4 字典

* 字典是Python中唯一内建的映射类型。key(不可变)可以是数字、**字符串**甚至是**元组**。  
* 无序
* key唯一，值不唯一。  


### 1. 创建字典 

```python
>>> phonebook = {'Alice': '1234', 'Bob': '0923'}
# 使用dict函数, 使用(key, value)的序列对创建字典
>>> items = [('name', 'Bob'), ('age', 12)]
>>> d = dict(items)
>>> d
{'age': 12, 'name': 'Bob'}
>>> d['name']
'Bob'
```



### 2. 基本字典操作 
* len(d)
* d[k] 返回value
* d[k] = v 赋值v
* del d[k] 删除key-value对
* k in d 成员资格

字典与列表的区别：  

* key类型：索引是整型数据，key不一定，可以是任意不可变的类型
* 自动添加：key在dict不存在，可以建立一个新item，而列表不能超出索引范围
* 成员资格：k in d找的是key，v in l找的是value

```python
>>> x = []
>>> x[42] = 'foo' # 报错：IndexError
Traceback
...
IndexError: list assignment index out of range
>>> x = {}
>>> x[42] = 'foo'
>>> x
{42: 'foo'}
```


### 3. 字典的格式化字符串
在%后面可以加上某个key，后面照常。如`%(Bob)s`, `%(num).4f`  
字典的key必须是字符串。  
“格式化说明符”可以比字典item少。  

```python
>>> template = '''<html>
    <head><title>%(title)s</title></head>
    <body>
    <h1>%(title)s</h1>
    <p>%(text)s</p>
    </body>'''
>>> data = {'title': 'My Home Page', 'text': 'Welcome to my home page!'}
>>> print template % data
<html>
<head><title>My Home Page</title></head>
<body>
<h1>My Home Page</h1>
<p>Welcome to my home page!</p>
</body>
```



### 4. 字典方法

```python
# clear
# d.clear(), 清除字典所有item
>>> x = {}
>>> y = x
>>> x['key'] = 'value'
>>> y
{'key': 'value'}
# 若x，y关联同一个字典，通过x = {}只是把x关联到一个新的空字典，不能把y也置空
# 这时就要使用clear()清空“原始”字典
>>> x =  {}
>>> y
{'key': 'value'}
# 假设上面x = {}没有执行
>>> x.clear()
>>> y
{}

# copy
# d2 = d1.copy()，返回相同key-value对的新字典。
# 浅复制(shallow copy)，值本身相同，不是副本。
# 若在副本替换值（下例把值‘foo’整个换成‘bar’），原始字典不受影响；
# 若修改值，原始字典也跟着修改。（下例把‘obj’其中一个项remove）
>>> d1 = {'name': 'foo', 'obj':['a', 'b']}
>>> d2 = d1.copy()
>>> d2['name'] = 'bar'
>>> d2['obj'].remove('a')
>>> d2
{'name': 'bar', 'obj':['b']}
>>> d1
{'name': 'foo', 'obj':['b']}
# 避免以上问题：使用copy模块的deepcopy函数（深复制）
>>> from copy import deepcopy
>>> a = {'name': ['Alfred', 'Bob']}
>>> c = a.copy()
>>> dc = deepcopy(a)
>>> d['name'].append('Cat')
>>> c
{'name': [Alfred', 'Bob', 'Cat']}
>>> dc
{'name': [Alfred', 'Bob']}

# fromkeys
# {}.fromkeys(['key1', 'key2', '...'], 每个key的value=None
# 或者在“字典类型”dict直接调用: dict.fromkeys(['key1', '...'])

# get
# 宽松访问字典item，key存在时正常，不存在时如下：
>>> d = {}
>>> print d.get('noexist') # 使用print d['noexist']会报错
None
# 可以自定义get不到时的返回值
>>> print d.get('noexist', 'self-define return')
'self-define return'

# has_key
# d.has_key(k)相当于k in d，Python3.0不包括has_key函数

# items和iteritems
# items()将字典的每一个item以对应的(key, value)构成list
>>> d = {'k1': 'v1', 'k2': v2}
>>> d.items()
[('k1', 'v1'), ('k2', v2)]
# iteritems()返回一个迭代器对象
>>> it = d.iteritems()
>>> it
<dictionary-iterator object at 0x......>
>>> list(it)
[('k1', 'v1'), ('k2', v2)]

# keys和iterkeys
# keys返回各个key组成的list，iterkeys返回key的迭代器

# values和itervalues
# 由于value可能重复，生成的list可以包含重复元素

# pop
# d.pop(key), 移除这个key-value item

# popitem
# d.popitem() 随机无序移除，主要用于：一个一个移除item（并不需要预先获取key的list）

# setdefault
# d.setdefault(key, value)，若key已存在，则不修改；若key不存在，则值改为value
# 主要用途：(假设value是列表)
>>> d.setdefault(key, []).append(new_list_item)


# update
# d1.update(d2)，将字典d2的所有item添加到d1，若key冲突，则覆盖更新
# d1变d2不变
>>> d1 = {'a': 1, 'b':2}
>>> d2 = {'a': 2, 'c':2}
>>> d1.update(d2)
>>> d1
{'a': 2, 'c': 2, 'b': 2}
>>> d2
{'a': 2, 'c': 2}

```





# Chapter 5 条件、循环和其他语句
### 1. print和import补充
逗号隔开多个表达式print，输出时显示空格隔开。  
注意：如果用逗号作为字符串拼接会生成多余的空格，所以要用`+`。  

```python
# 若在print结尾加逗号，则接下来的语句会和当前语句同一行print
print 'a',
print 'b'
# 输出结果：a b
```

import相关

```python
import some_module
from some_module import f1, f2, f3
from some_module import *    # 使用该模块所有f时才用这个
# 若module1和module2都有f函数，则使用第一种import，并应这样使用：
module1.f()
module2.f()
# 或者用as提供别名, as可以作用于module或者module中的f
>>> import math as foo
>>> foo.sqrt(4)
2.0
>>> from math import sqrt as bar
>>> bar(4)
2.0
```



### 2. 赋值
#### 序列解包(squence unpacking)
将多个值的序列解开，然后放到变量的序列中。  

```python
# 同时多个赋值
>>> x, y, z = 1, 2, 3
# 交换多个变量
>> x, y = y, x
>>> print x, y, z
2, 1, 3
# 序列解包用例：函数或方法返回元组时
>>> d = {'a': 1, 'b': 2}
>>> key, value = d.popitem()
>>> key
'a'
>>> value
1
```


#### 链式赋值(chained assignment)
`x = y = some_function()`


#### 增量赋值(augmented assignment)

```python
# 对于+、/、%等标准运算符都适用
# 注意，只能用于变量（常量不可修改）
>>> x *= 2
>>> str = 'foo'
>>> str += 'bar'
>>> str
foobar
```

#### 语句块

* 标准&推荐使用4空格缩进
* `:`标识语句块开始



### 4. 条件语句
python中假的值（除此之外都为True）：  

```python
标准值False, None
所有类型的数字0
空序列"", (), []
空字典{}
# 注意不同类型的False值本身不相等

# bool类型值True和False不过是1和0的华丽外表
>>> True + False + 42
43

>>> bool('This is a test')
True
>>> bool(42)
True
>>> bool('')
False
```

`elif:`，`else:`是if语句的字句，不能单独使用。  

比较运算符：

```python
大小如 ==, !=, <=等等
x is y(x和y是同一个对象), is not    # 同一性，不是相等性 
x in y(x是y容器的成员), not in
# 和赋值一样，比较运算也是可连接的: 0 < age < 100

>>> "alpha" < "beta"    # ASCII
True
>>> [2, [1, 4]] < [2, [1, 5]]
True
>>> x = y = [1, 2]   # x, y指向同一list
>>> z = [1, 2]
>>> x == y == z
True
>>> x is y
True
>>> x is z
False
```

布尔（逻辑）运算符：and or not  
**短路逻辑(short-circuit logic)(惰性求值lazy evaluation)**，应用：

```python
# 仅当raw_input语句的返回值为False（空string），才将默认的"<unknown>"赋给name
name = raw_input("Please enter your name: ") or "<unknown>"
```


**断言assert**: `assert 表达式, "可选的断言解释"`  

```python
>>> age = 10
>>> assert 0 < age < 100
>>> age = -1
>>> assert 0 < age < 100, "The age must be realistic"
Traceback ...
...
AssertionError: The age must be realistic
```



### 5. 循环
while, for  

```python
# while
x = 1
while x <= 100:
    print x
    x += 1
    

# for
numbers = [1, 2, 3]
for num in numbers:
    print num

# range(start, end+1, step)，start不提供则表示从0开始, step步长默认为1
>>> range(6)
[0, 1, 2, 3, 4, 5]
>>> range(5, 0, -1)
[4, 3, 2, 1, 0]
>>> xrange(6)
xrange(6)
# xrange一次只创建一个数，大序列更高效，range一次创建整个序列

# 遍历字典
d = {'a': 1, 'b': 2}
for key in d:
    print key, '--', d[key]
# 或者
for key, value in d.items():    # 在循环中序列解包
    print key, '--', value
# notice：字典元素无序，若要求顺序，可以将key另存在list中，在迭代之前排序

# 迭代工具
# 1. 并行迭代：zip压缩两个list，返回元组的list。可处理不等长list, 短停止。
>>> keys = ['a', 'b']
>>> values = [1, 2]
>>> zip(keys, values)
[('a’, 1), ('b', 2)]
for key, value in zip(keys, values):
    print key, '--', value
>>> zip(range(2), xrange(1000))
[(0, 0), (1, 1)]
# 2. 编号迭代
for index, string in enumerate(strings):    # 屏蔽含有敏感词汇的整个句子
    if 'xxx' in string:
        strings[index] = '[censored]'
# 3. 翻转和排序迭代
reversed返回可迭代对象，sorted返回列表
>>> list(reversed('abc!'))
['!', 'c', 'b', 'a']
>>> sorted([2, 1, 1])
[1, 1, 2]

# 跳出循环
# 1. break
# 2. continue
# 3. while True: ... break

# 循环的else子句
# 如果for里面没有执行break，则else子句会被执行
for i in range(100):
    if i == 100:
        break
else:
    print "I didn't break out!"
```



### 6. 列表推导式————轻量级循环
list comprehension是利用其它list创建新list

```python
>>> [x*x for x in range(5) if x % 2 == 0]
[0, 4, 16]
>>> [(x, y) for x in range(2) for y in range(1)]
[(0, 0), (1, 0)]
# 等价于
result = []
for x in range(2):
    for y in range(1):
        result.append((x, y))        

# 应用：查找首字母相同的男和女
girls = ['alice', 'betty', 'cat']
boys = ['chris', 'arnold', 'bob']
# 低效version
print [b+'+'+g for b in boys for g in girls if b[0] == g[0])
# 高效version
letterGirls = {}
for girl in girls:
    letterGirls.setdefault(girl[0], []).append(girl)
    # setdefault检查是否有girl[0]的key，若无则新建列表
    # 整个循环将首字母相同的女孩归为同一key的列表项
print [b+'+'+g for b in boys for g in letterGirls(b[0]))
```



### 7. pass、del和exec
pass什么没发生，if语句空代码块是非法的，可以用pass代替。  
del删除

```python
>>> lst1  = [1, 2]
>>> lst1 = None
# 垃圾收集：列表没有任何名字绑定到它，Python解释器就直接删除了内存中的该列表

# del
>>> x = ["Hello", "world"]
>>> y = x
>>> del x
>>> y
['Hello', 'world']
# 原因：del只是删除名称，不是删除列表本身（值）。
# Python无法删除值（某个值不再使用时，Python解释器会负责内存回收）
```

* exec（执行）字符串（Python语句）
* eval（求值）字符串（Python表达式），并返回结果

exec执行一个储存在字符串的Python语句：  
`exec "print 'hello world'"`  
给exec提供命名空间/作用域(scope)  

```python
# exec
>>> from math import sqrt
>>> exec "sqrt = 'new_name'"
>>> sqrt(4)
Traceback ...
...
TypeError: 'str' object is not callable
>>> from math import sqrt
>>> scope = {}
>>> exec "sqrt = 'new_name'" in scope
>>> sqrt(4)
2.0
>>> scope['sqrt']
'new_name'
>>> scope.keys()
['__builtins__', 'sqrt']

# eval
>>> eval(raw_input("Enter an arithmetic expression: ")
Enter an arithmetic expression: 1 + 2 * 3
7
# 放置值到作用域(exec和eval可共享一个指定的作用域字典)
>>> scope = {}
>>> scope['x'] = 2
>>> scope['y'] = 3
>>> eval('x * y', scope)
6
```





# Chapter 6 抽象：函数
函数，参数parameter、作用域scope、递归。  

```python
# 内建callable函数判断函数是否可以调用
>>> callable(math.sqrt)
True
```



### 1. 函数定义def。  
文档字符串：应用于函数、类、模块的开头。在函数中紧接def语句，作为函数一部分存储。  
使用`函数名.__doc__`可访问文档字符串，也可通过help(函数名)获取更多信息。  
返回值：return。跳出函数。return也可不写或者return后面留空。

```python
def fibs(num):
    "Doc string: Generate a fibs sequence consist of 'num' number"
    result = [0, 1]
    for i in range(num-2)
        result.append(result[-2] + result[-1])
    return result
```



### 2. 参数
参数存储在局部作用域。  

```python
num = 0
def change(n):
    n = 1
change(num)
# num还是0

lst = [0, 2]
def change_list(lst_ref)
    lst_ref[0] = 1
change_list(lst)
# lst变为[1, 2], 形参实参引用同一列表
# 副本作为参数：change_list(lst[:])，则不改变原来变量

# 参数不可变的情况下，想改变参数
# 1. 通过返回值，多返回值可用元组
>>> def inc(x): return x+1
>>> foo = 10
>>> foo = inc(foo)
>>> foo
11
# 2. 将值放在list
>>> def inc(x): x[0] += 1
>>> foo = [10]
>>> inc(foo)
>>> foo
[11]
```

关键字参数和默认值  

```python
# 关键字参数，指定参数名，参数顺序可无序（不用关键字参数的话(“位置参数”)必须有序）
def hello(greeting, name)
    print '%s, %s' % (greeting, name)
hello(name = 'Elvis', greeting = 'Hello')
# 默认值(定义函数时提供), 调用时可覆盖（顺序覆盖, 或指定参数名覆盖）
def hello(greeting='Hello', name='World')
    print '%s, %s' % (greeting, name)
>>> hello('Hi')
Hi, World
>>> hello(name = 'Elvis')
Hello Elvis
```

收集参数

* `*变量名`收集其余的**位置参数**: 返回元组
* `**变量名`收集**关键字参数**：返回字典

```python
def print_params(title, *pos_par, **key_par):
    print title
    print pos_par
    print key_par
>>> print_params("ok", 1, 2, foo=1, bar=2)
ok
(1, 2)
{'foo': 1, 'bar': 2}
```


反转过程（收集参数的逆过程）  

```python
def add(x, y): return x+y
pos_par = (1,2)
>>> add(*pos_par)
3

def hello(greeting="hello", name="World"): print greeting, name
key_par = {'name': 'Elvis', 'greeting': 'Hello'}
>>> hello(**key_par)
Hello, Elvis

```



### 3. 作用域
内建的vars()返回变量的字典(“不可见”), 叫做**“命名空间”**或**“作用域”**  

```python
a = 1
print vars()
# 输出结果如下（略去一部分）：
# {'a': 1, '__file__': './6.py', '__package__': None, \
#  '__name__': '__main__', '__doc__': None}

>>> def foo(): x = 42
>>> x = 1
>>> foo()    # 新的作用域，局部变量
>>> x
1
# notice: 若要在函数访问全局变量，而局部变量与全局变量同名，则会屏蔽全局变量
# 解决方法：使用globals函数返回全局变量的字典
def combine(param):
    print param + globals()['param']
>>> param = 'berry'
>>> combine('Shrub')
Shrubberry
# 在函数内部告诉变量x是一个全局变量
# “重绑定”全局变量，使得函数内部也可以像全局作用域那样使用
x = 1
def change_global():
    global x
    x = x + 1
>>> change_global()
>>> x
2

# 函数嵌套
def outside(factor):
    def inside(num):
        return num * factor
    return inside
>>> outside(2)(3)
6
# inside函数存储“子封闭作用域”的行为叫做closure闭包
```



### 4. 递归



### 5. 函数式编程：map、filter、reduce、lambda表达式

```python
# map函数将“序列”中的元素全部传给一个“函数”
# map(函数，序列)
>>> map(str, range(5))  # 等价于[str(i) for i in range(5)]
['0', '1', '2', '3', '4']

# filter函数：基于一个“返回布尔值的”函数，对元素进行过滤
# filter(函数，序列)
def f(x):
    return x.isalnum()    # 字母或数字则返回True
seq = ["foo", "x41", "$#%^", "***"]
>>> filter(f, seq)
['foo', 'x41']
# 列表推导式解决方案:
>>> [x for x in seq if x.isalnum()]
['foo', 'x41']
# lambda表达式解决方案：
>>> filter(lambda x: x.isalnum(), seq)
['foo', 'x41']
# lambda函数也叫匿名函数（函数没有具体名称）
# 用法 lambda parameters: expression
# 可接受多个参数，并返回单个表达式的值(lambda返回值是函数的地址)
>>> g = lambda x: x**2
>>> print g(4)
16

# reduce函数
# reduce(函数，序列)
# 将函数f作用于序列前两个元素，返回值和第3个元素继续给f使用，直到整个序列处理完毕。
>>> num = [1, 2, 3, 4]
>>> reduce(lambda x, y: x+y, num)   # 等效于sum(num)
10
# (((1+2)+3)+4)
```





# Chapter 7 更加抽象：类和对象
### 1. 对象
对象：数据（“特性”）以及一系列可以操作数据的函数（“方法”）组成的集合。  

* 多态(Polymorphism)：对不同类对象使用同样操作，根据对象类型的不同表现出不同行为。
* 封装(Inheritance)：对外部隐藏对象的工作细节
* 继承(Encapsulation)：以“普通类”为基础建立专门的类对象

任何不知道对象是什么类型，但要对对象“做点什么”事，都会使用多态。唯一能毁掉多态的就是使用函数显示地检查类型，如type、isinstance以及insubclass等（尽量避免）。  



### 2. 类和类型
所有属于某一个类的对象，称为该类的实例(instance).  
习惯用首字母大写的单数名词表示类，如Bird.  
子类(subclass)、超类(superclass).  

```python
__metaclass__ = type    # 确定使用新式类
class Person:
    def setName(self, name):
        self.name = name

    def getName(self):
        return self.name

    def greet(self):
        print "Hello, world! I'm %s." % self.name

>>> foo = Person()
>>> bar = Person()
>>> foo.setName('Elvis')
>>> bar.setName('OK')
>>> foo.greet()
print "Hello, world! I'm Elvis."
>>> bar.greet()
print "Hello, world! I'm OK."

# 访问对象的特性
>>> print foo.name
Elvis

# self是对于对象自身的引用, 调用对象foo时，foo将自己作为第一参数传入函数
# self参数是方法(绑定方法)和函数的区别

class Bird:
    song = 'aaa'
    def sing(self):
        print self.song
>>> bird = Bird()
>>> bird.sing()
aaa
>>> bound = bird.sing
>>> bound()   # 这里不是函数调用，还是对self参数的访问（变量bound绑定到类的相同实例）
aaa
```

```python
# 方法或特性“私有化”：名字前加上双下划线"__"
class Secretive:
    def __inaccessible(self):
        print "this message is designed as inaccessible"
    def accessible(self):
        print "The secret message is: "
        self.__inaccessible()
# 上述__inaccessible外界无法访问，只能在类内部使用（比如从accessible）
# 类的内部定义中，所有以双下划线开始的名字都被“翻译”成前面加“单下划线”和类名的形式。
# 实际上还是能在类外访问这些私有方法：
>>> s = Secretive()
>>> s.__inaccessible()
Traceback .... # 出错
>>> s._Secretive__inaccessible()
this message is designed as inaccessible
```

```python
# 类的命名空间(class namespace), 可由类内所有成员访问
class MemberCounter:
    members = 0
    def init(self):
        MemberCounter.members += 1

m1 = MemberCounter()
m1.init()
print MemberCounter.members     # 1 

m2 = MemberCounter()
m2.init()
print MemberCounter.members     # 2

print m1.members, m2.members    # 2 2

m1.members = 'Two'      # 重绑定members特性，屏蔽
print m1.members, m2.members    # Two 2
```

```python
# 指定超类，示例定义SPAMFilter的两个要点：
# 1. 重写Filter的init定义
# 2. 直接继承Filter类的filter方法
class Filter:
    def init(self):
        self.blocked = []
    def filter(self, sequence):
        return [x for x in sequence if x not in self.blocked]

class SPAMFilter(Filter):       # SPAMFilter是Filter的子类
    def init(self):             # 重写Filter超类的init方法
        self.blocked = ['SPAM']

s = SPAMFilter()
s.init()
print s.filter(['SPAM', 'SPAM', 'SPAM', 'SPAM', 'egg', 'bacon', 'SPAM'])
```

```python
# issubclass(subclass, superclass)，判断子类关系
>>> issubclass(SPAMFilter, Filter)
True
>>> SPAMFilter.__bases__    # __bases__特性查看：类的基(超)类(们)
(<class '__main__.Filter'>,)

# isinstance(instance, class)判断某对象是否是一个类的实例
# 子类的实例，在超类的isinstance函数也返回True(间接成员)
>>> s = SPAMFilter()
>>> print isinstance(s, SPAMFilter), isinstance(s, Filter)
True, True
# 通过对象的__class__特性，查看属于哪个类
>>> s.__class__
<class '__main__.SPAMFilter'>
```

```python
# 多重继承(multiple inheritance)：超类可能多于一个
# 超类之间同名方法的冲突：先继承的超类中的方法会覆盖后继承的
class Calculator:
    def calculate(self, expression):
        self.value = eval(expression)

class Talker:
    def talk(self):
        print 'Hi, my value is', self.value

class TalkingCalculator(Calculator, Talker):
    pass

tc = TalkingCalculator()
tc.calculate('1+2*3')       # 调用calculate方法后，对象tc有了value特性
tc.talk()
```

```python
# 接口：与“多态”有关，或称为“协议”：公开的方法和特性
>>> hasattr(tc, 'talk')
True
>>> setattr(tc, 'name', 'Elvis')
>>> print tc.name
Elvis
# dict特性：查看对象内所有存储的值，对象.__dict__
>>> tc.__dict__
{'name': 'Elvis', 'value': 7}
```

面向对象模型：  

1. 问题描述，并找出名词、动词、形容词。
    * 名词   --   类
    * 动词   --   方法
    * 形容词 --   特性
2. 把方法和特性分配到类





# Chapter 8 异常
每个异常是都是一些类的实例，这些异常可以被raise，并捕捉(若不捕捉，会导致回溯Traceback的错误信息)，然后对其处理，而不是让整个程序崩溃。  
raise语句:  
`>>> raise Exception`  
![img][8.1]  

自定义异常类(需确保从Exception类继承):  
`class Custom_Exception(Exception): pass`  

捕捉异常try/expcept:

```python
# 也可使用if语句检查y值，但是若程序有多个除法，就必须给每个除法加if
# 而try/except只需一个错误处理器
# except子句可多个
# 若except子句中不指定异常类，则所有异常都会被捕捉
# 捕捉所有异常很危险，因为会捕捉用户Ctrl+C和sys.exit。用except Exception, e更好
try:
    x = input('Enter the first number: ')
    y = input('Enter the second number: ')
    print x/y
except ZeroDivisionError:
    print "The second number can't be zero!"
except TypeError:
    print "You must input a number type"

# 多个异常也可以在except子句中用“元组”一并列出
# except (ZeroDivisionError, TypeError, NameError):
#    print '...'
```

```python
# 不带参数的raise语句，在except子句重新引发该子句捕捉到的异常。
# 打开/关闭 屏蔽机制
class MuffledCalculator:
    muffled = False
    def calc(self, expr):
        try:
            return eval(expr)
        except ZeroDivisionError:
            if self.muffled:
                print "Division by zero is illegal"
            else:
                raise

>>> calculator = MuffledCalculator()
>>> print calculator.calc('10/2')
5
>>> print calculator.calc('10/0')   # No muffling
Traceback ...
...
>>> calculator.muffled = True
>>> calculator.calc('10/0')         # 这里calc方法会返回None 
Division by zero is illegal
```

```python
# 捕捉“对象”
# 在except子句使用第二个参数，访问异常对象本身
try:
    x = input('Enter the first number: ')
    y = input('Enter the second number: ')
    print x/y
except (ZeroDivisionError, TypeError), e:
    print e
```

```python
# try/except加上else
# 若无异常，则else语句才会执行
try:
    print 'success'
except:
    print 'wrong'
else:
    print 'no except'
```

```python
# finally子句
# 不管try子句中是否异常，finally子句肯定被执行
try:
    1/0
except ZeroDivisionError:
    print "Error: division of zero"
else:
    print "went well"
finally:
    print "cleaning up"
```

异常传播：如果函数内的异常**引发而不处理**，则传播至函数调用的地方。若继续没处理，则继续传播，直至主程序（global scope）  
若全都不处理，则最终导致traceback堆栈跟踪。  

```python
# zen of exception
# 下例若使用if语句检查'occupation'这个key是否在dict，然后再查询dict获得value
# 则导致两次查找：（1）if语句中key是否存在；（2）获得value
# 此时使用异常更高效
def describePerson(person):
    print 'Name: ', person['name']
    print 'Age: ', person['age']
    try:
        print 'Occupation: ' + person['occupation'] 
        # 注意，这里若使用逗号，则字符串'Occupation: '会在异常引发前输出
    except KeyError: pass

# 查看一个obj是否有某个attribute
# 这是内部实现getattr的方法
try:
    obj.write   # 仅访问attribute，不做任何事
except AttributeError:
    print 'the obj is not writeable'
else:
    print 'writeable obj'
```





# Chapter 9 魔法方法、属性和迭代器

* 魔法方法（特殊方法）：前后加上两个下划线，如`__init__`, `__future__`
* 属性：旧版本的Python使用魔法方法处理，现在通过property函数
* 迭代器：使用魔法方法`__iter__`来允许迭代器在for循环使用



### 1. 构造方法
对象被生成以后，立即调用构造方法init()。  
使用魔法方法`__init__`定义构造方法:  

```python
# 构造方法的定义
class FooBar:
    def __init__(self, value=42):
        self.somevar = value
>>> f = FooBar()
>>> f.somevar
42
>>> b = FooBar("hello")
>>> b.somevar
'hello'
```
重写超类的构造方法，导致超类特性缺失而影响继承而来的超类方法。  
解决方案：  

* 调用未绑定的超类构造方法（旧方案）
* 使用super函数

```python
# 法1
# 在子类的构造方法中添加一行：超类name.__init__(self)
# 直接调用”类的方法“，则没有instance会被绑定到self参数，从而可以自由提供需要的self参数
# 将当前instance作为self参数提供给未绑定方法, 子类就可以使用超类构造方法的所有实现
class Bird:
    def __init__(self):
        self.hungry = True
    def eat(self):
        if self.hungry:
            print 'hungry -> eat'
            self.hungry = False
        else:
            print 'No, thanks'

class SongBird(Bird):
    def __init__(self):
        Bird.__init__(self)
        self.sound = 'Squawk!'
    def sing(self):
        print self.sound
```

```python
# 法2
# 类或对象为参数，返回的对象的任何方法都是调用超类的方法
class SongBird(Bird):
    def __init__(self):
        super(SongBird, self).__init__()
        self.sound = 'Squawk!'
    def sing(self):
        print self.sound
```



### 2. 属性
属性：通过访问器定义的特性。  

```python
# property函数，property函数4个参数分别叫做：fget、fset、fdel和doc
# 下例size本是假想特性，property将其变成真正特性，
__metaclass__ = type
class Rectangle:
    def __init__(self):
        self.width = 0
        self.height = 0
    def setSize(self, size):
        self.width, self.height = size
    def getSize(self):
        return self.width, self.height
    size = property(getSize, setSize)

>>> r = Rectangle()
>>> r.width = 10
>>> r.height = 5
>>> r.size
(10, 5)
>>> r.size = 150, 100
>>> r.width
150
```

```python
# 静态方法：无self参数，能被类本身直接调用
# 类成员方法：需有名为cls的参数，类似于self，能被类的具体对象调用
# 使用方式：@操作符，在方法上方列出装饰器decorator（对可调用的对象进行包装）
__metaclass__ = type
class MyClass:
    @staticmethod
    def smeth():
        print "this is a static method"
    
    @classmethod
    def cmeth(cls):
        print "This is a class method of", cls

>>> MyClass.smeth()
This is a static method
>>> MyClass.cmeth()
This is a class method of <class '__main__.MyClass'>
```



### 3. 迭代器(iterator）
`__iter__`方法返回一个迭代器(具有next方法的对象)。调用next方法时迭代器返回下一个值。   
compare to 列表：列表一次性获取，占内存。iterator逐个。

```python
class Fibs:
    def __init__(self):
        self.a = 0
        self.b = 1
    def next(self):
        self.a, self.b = self.b, self.a + self.b
        return self.a
    def __iter__(self):
        return self

fibs = Fibs()
for f in fibs:
    if f>1000:
        print f
        break
```



### 4. 生成器(generator)
任何包含`yield`关键字的函数称为generator，返回一个迭代器iterator。  
generator由两部分组成：  

* 生成器的函数: def语句定义，包含yield的部分，yield表达式每次产生一个值
* 生成器的迭代器：返回值

```python
# 创建generator
nested_lst = [[1, 2], [3, 4], 5]
def flatten(nested_lst):
    for sub_lst in nested_lst:
        for element in sub_lst:
            yield element

# 接下来可以在generator上迭代
>>> for num in flatten(nested_lst):
        print num
1
2
3
4
5
```

```python 
# 生成器推导式
>>> g = (i**2 for i in range(2,10))
>>> g.next()
4
# 也可在函数调用的括号内使用
>>> sum(i**2 for i in range(3))
5
```
生成器方法，“外部作用域”访问生成器：send、throw和close方法。  





# chapter 10 模块&标准库
import模块时，产生pyc扩展名文件（平台无关的编译过），更有效地处理文件。  
为了让代码可重用（code reuse），请将它模块化！  
使用`__name__`变量，在模块中增加测试代码。在主程序中，`__name___`的值是`__main__`；在导入的模块中，`__name___`的值是模块名。 
使你的模块可用：  
法1：将模块放在正确位置（python解释器查找模块的路径）  

```python
>>> import sys, pprint
>>> pprint.pprint(sys.path)     # pprint是智能print，用于大数据结构
```

法2：告诉解释器去哪里找模块(自定义的路径)  
编辑sys.path， `sys.path.append("/your/absolute/path")`  
标准方法：将路径包含在PYTHONPATH环境变量。  

包package:  
如下图的目录结构，其中必须包含`__init__.py`文件，该文件的内容是单纯把drawing包作为（一级）模块的内容：  
![img][10.1]  
这样使用：  

```python
import drawing
import drawing.colors
from drawing import shapes
```

探究模块：  
使用dir(模块名）列出内容；  
其中`__all__`变量列出部分主要内容（`from 模块名 import *`的内容）；  
help(copy.copy)可获取copy模块的copy函数的帮助内容（提取于`__doc__`），help函数可作用于模块或模块的内容（class，function）  


查阅文档（python解释器）：  
运行`print copy.__doc__  # copy是模块`输出shallow copy和deep copy的区别：  

```
The difference between shallow and deep copying is only relevant for
compound objects (objects that contain other objects, like lists or
class instances).

- A shallow copy constructs a new compound object and then (to the
  extent possible) inserts *the same objects* into it that the
  original contains.

- A deep copy constructs a new compound object and then, recursively,
  inserts *copies* into it of the objects found in the original.

Two problems often exist with deep copy operations that don't exist
with shallow copy operations:

 a) recursive objects (compound objects that, directly or indirectly,
    contain a reference to themselves) may cause a recursive loop

 b) because deep copy copies *everything* it may copy too much, e.g.
    administrative data structures that should be shared even between
    copies

Python's deep copy operation avoids these problems by:

 a) keeping a table of objects already copied during the current
    copying pass

 b) letting user-defined classes override the copying operation or the
    set of components copied
```

阅读源代码：  
通过检查模块的`__file__`属性得到源码路径。  



### 标准库选集
#### 1. sys模块：与python解释器交互
![img][10.2]  

```python
# reverse_args.py: 反序打印命令行参数
import sys
args = sys.argv[1:]
args.reverse()
print ' '.join(args)
```


#### 2. os模块：访问os service
![img][10.3]  


#### 3. fileinput模块
![img][10.4]  


#### 4. time模块
实现功能：获得当前时间、格式化时间为字符串，字符串格式化为时间。  
日期可以用实数（时间戳，1970年至今秒数）或是包含9个整数的元组`（y, m, d, h, m, s, week(周一是0, 0~6), 累计日(1~366), 夏令时(无0、-1、1)）`  
![img][10.5]  


#### 5. random模块
![img][10.6]  
examples:  

```python
# 随机选词 lucky_word.py
import fileinput, random
word_list = list(fileinput.input())
print random.choice(word_list)
```

```bash
$ ./luck_word.py /usr/share/dict/words
magnolia
```


#### 6. shelve模块
shelve包含函数open，以文件名为参数，返回一个Shelf对象（可看做key为字符串的字典），可用来存储内容，调用close方法以关闭之。  


#### 7. re模块
正则表达式regular expression是可以匹配文本片段的模式。  

##### 1. re语法

* 通配符wildcard“点号.”只能匹配任一单个字符。  
* 转义escape有两个级别：（1）解释器；（2）re模块。因此若要表示文字意义上的特殊符号，需要两个“反斜线\”，或者使用原始字符串，如`r"python\.org"`**唯一**匹配“python.org”，里面的点号不是通配符。  
* 字符集character set使用中括号，用于匹配**“一个”**它包含的任意字符。如`[pj]ython`匹配”python"和"jython"。可以使用范围，如`"[a-z]"`或`"[a-zA-Z0-9]"`。反向字符集（“脱字符^”）`"[^ab]"`匹配**除了**a、b之外的所有字符。
* 选择符（“管道符号|”）、子模式（subpattern，圆括号括起）。如`"python|perl"`可选择匹配“python”和“perl”，或者结合子模式`"p(ython|erl)"`。
* 可选项（子模式后面加“问号?”）、重复子模式。
    * `"(pattern)*"`：允许模式重复0或多次
    * `"(pattern)+"`：允许模式重复1或多次
    * `"(pattern){m,n}"`：允许模式重复m~n次  
    重复运算符默认是贪婪的：尽量长的匹配。如`pat = r"\*(.+)\*"`, `text = "*This* is *it*"`, `re.sub(pat, r'<em>\1</em>', text)`得到`'<em>This* is *it</em>'`。非贪婪模式：将pat改成`pat = r"\*(.+?)\*"`，得到`'<em>This</em> is <em>it</em>'`。   
* 只匹配开始（"^"）、结尾（"$"，表示匹配整行）：如`"^http"`不会匹配"www.http.org"

##### 2. re模块的函数
![img][10.7]

```python
>>> pat = '[a-zA-Z]+'
>>> text = "Hm... Err -- are you sure?"
>>> re.findall(pat, text)
['Hm', 'Err', 'are', 'you', 'sure']

>>> pat = '{name}'
>>> text = "Hello {name}..."
>>> re.sub(pat, "Elvis", text)
'Hello Elvis...'
```

##### 3. 匹配对象MatchObject、组group
函数找到匹配项时，返回MatchObject对象：包含匹配模式的子字符串的信息、已经匹配的子字符串的哪部分（组group，一种子模式）。  
group有序号，用group左边的左括号数目计算。  

```python
>>> import re
>>> m = re.match(r'www\.(.*)\..{3}', 'www.python.org')
>>> m.group(0)
'www.python.org'
>>> m.group(1)
'python'
>>> m.start(1)
4
>>> m.end(1)
10
>>> m.span(1)
(4, 10)
```




#### 8. 数据结构补充（与module相关）
一些数据结构：集合set、堆heap、双端队列(deque, Double-ended queue)  
##### 1. 集合
集合是由可迭代的对象（如序列）构建的，主要用于检查成员资格，元素不重复。  
集合是可变的（`frozenset(变量)`可产生不可变的集合），但是集合里面的元素是不可变的。  
Set类在python2.3以前是位于sets模块。  

```python
>>> set([0, 1, 2, 0, 1, 2])
set([0, 1, 2])
# 可用set进行集合操作（如并、交、差）
>>> a = set([1, 2, 3])
>>> b = set([2, 3, 4])
>>> a.union(b)
set([1, 2, 3, 4])
>>> a | b
set([1, 2, 3, 4])
>>> a&b
set([2, 3])
>>> c = a.intersection(b)
>>> c
set([2, 3])
>>> c.issubset(a)
True
>>> a.issuperset(b)
False
>>> a.issuperset(c)
True
>>> a.difference(b)
set([1])
>>> a-b
set([1])
```

##### 2. 堆
堆是优先队列的一种，Python没有堆类型，只有一个包含堆操作函数的模块heapq。q是queue的缩写。  
***小顶堆***(元素[i]小于元素[2i]和元素[2i+1])，可以快速找到min  
下面是heapq模块中重要的函数：  
![img][10.8]  

```python
>>> from heapq import *
>>> from random import shuffle
>>> data = range(10)
>>> shuffle(data)
>>> heap = []
>>> for n in data:
...     heappush(heap, n)
... 
>>> heap
[0, 1, 4, 2, 6, 9, 7, 5, 3, 8]
>>> heappush(heap, 0.001)
>>> heap
[0, 0.001, 4, 2, 1, 9, 7, 5, 3, 8, 6]
>>> heappop(heap)   # 弹出最小元素
0
>>> heappop(heap)
0.001
>>> heappop(heap)
1
>>> heappop(heap)
2
```

###### 3. 双端队列
collections模块包含双端队列deque类型。  
使用双端队列能有效在队列头部增加和弹出元素（appendleft, popleft），还能旋转队列。  

```python
>>> from collections import deque
>>> q = deque(range(5))
>>> q
deque([0, 1, 2, 3, 4])
>>> q.append(5)
>>> q
deque([0, 1, 2, 3, 4, 5])
>>> q.appendleft(6)
>>> q
deque([6, 0, 1, 2, 3, 4, 5])
>>> q.pop()
5
>>> q.popleft()
6
>>> q.rotate(3)
>>> q
deque([2, 3, 4, 0, 1])
```











[3.1]: /images/beginning_python/3.1.png "format type"
[8.1]: /images/beginning_python/8.1.png "Built-in Exceptions"
[10.1]: /images/beginning_python/10.1.png "package of module"
[10.2]: /images/beginning_python/10.1.png "module of sys"
[10.3]: /images/beginning_python/10.1.png "module of os"
[10.4]: /images/beginning_python/10.1.png "module of fileinput"
[10.5]: /images/beginning_python/10.1.png "module of time" 
[10.6]: /images/beginning_python/10.1.png "module of random" 
[10.7]: /images/beginning_python/10.1.png "module of re" 
[10.8]: /images/beginning_python/10.1.png "module of heapq"
