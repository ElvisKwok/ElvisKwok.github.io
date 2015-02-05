---
layout: post
title: Notes of Beginning Python
---

#{{ page.title }}  
<p class="meta">31 Jan 2015 - Shanwei</p> 
+++++++++++++++++
<br>
REPL: Read-Eval-Print Loop, an interactive toplevel or language shell
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
# lst1.extend(lst2), 末尾append一个序列
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
>>> 'using repr: %s' % 42L
'using repr: 42L'
# *使用元组第一个元素提供的字段宽度
>>> '%.*s' % (5, 'Guido van Rossum')
'Guido'
```

[3.1]: /images/beginning_python/3.1.png "format type"



### 2. 字符串方法
字符串常量: string.digits, string.letters, string.lowercase, string.uppercase, string.printable, string.punctation。  

```python
# find
# str.find(value, begin, end)，返回子串最左的索引，找不到返回-1
# 相关：rfind反向搜索返回正向索引, index, rindex, count, startwith, endswith
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
# str.replcase('from', 'to')

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

* 字典是Python中唯一内建的映射类型。key可以是数字、**字符串**甚至是**元组**。  
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
>>> d1 = {'name': 'foo’, 'obj':['a', 'b']}
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
Tracebace ...
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
# range(start, end+1)，若start==0，则

### 6. 列表推导式————轻量级循环



### 7. pass、del和exec
