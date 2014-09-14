---
layout: post
title: Markdown学习笔记
---

===============================
<p class="title">{{ page.title }}</p> <p class="meta">14 Sep 2014 - Guangzhou</p>  

前言  
很久前就听说过Markdown，由于最近需要记录一些东西，所以今天才开始系统的学习Markdown。  
Markdown是一种标记语言（文本的格式化表示），之所以选择Markdown，一者,是想让文本具有更高的的可读性，相比于HTML，没有太多<tag>干扰。再者，使用Markdown可以在任何一种文本编辑器上书写，比如我正在使用的vim，简洁美观，而且方便在网页上展示（使用rdiscount解释Markdown语言很容易生成HTML），正如[Markdown语法说明][]所说的，”HTML 是一種*發佈*的格式，Markdown 是一種*編寫*的格式“。最后，Markdown在程序员社区具有较高的认可度，比如github。  

以下是我的学习笔记  
段落：使用一个或多个空行，分隔文本内容。或者在段落后加上两个或以上空格  
标题：atx, setext  

* atx-style  
使用前缀"#"，"#"的个数分别对应于h1~h6,例如，  
# This is an H1  
###### This is an H6  

* setext-style  
	* 定义h1:  
	THIS IS H1  
	== 

	* 定义h2  
	THIS IS H2  
	-- 


使用">"作为段落的前缀，标识该段落是引用部分，类似于Email标记的应用文字     
> This is the first level of quoting
>
> > This is the nested blockquote
>
> Back to the first level

使用 "*", "+", "-" 来表示无序的列表；  
"+"  

+ unorder +1
+ unorder +2

"*"

* unorder *1
	* 1.1
	* 1.2
* unorder *2
	* 2.1
	* 2.2

"-" 

- unorder -1
- unorder -2

使用"数字."表示有序列表  

1. firstline
2. secondline  

使用4个***"以上"***的空格或一个**"以上"**的tab标记代码段落，或者`code`,或者区块元素（4空格）, 或者前后\`\`\`包围
    
     test code
     ok?

`test code`

    区块元素的标签不会被处理，区块必须在前后加上空行

	<table>
		<tr>
			<td>foo</td>
		</tr>
	</table>
	
	this is another  

隔离  

```
adfdfd
bdfdf
csaf
```

链接：[test](http://dfdf.com "标题")  
图片：![img](http://dfdf.com/img.png, "可以是相对路径")  
引用图片：目前为止，Markdown还无法指定图片宽和高，如若需要，需使用<img\>  
![alt text][id]  
[id]: http://img.t.sinajs.cn/t5/style/images/staticlogo/logoContrast_pic.png?version=1a386bde78f5d832 "weibo"  

突出字体：__轻点__, **重点**, *一个斜*，**两个粗**，***三个又斜又粗***  
删除句子：~~删去这句话~~

引用链接：[wiki][1],[google][2]，[预设链接后面加空的中括号，要求文字相同][]
[1]: http://www.wikipedia.org "wiki"
[2]: http://goole.com 		  'google'
[预设链接后面加空的中括号，要求文字相同]: yushe.com 'yushe'

<br>
行内链接：this is an [example link](http://example.com "标题")  
快速链接：<http://elviskwok.github.io>, <359619839@qq.com>  

需要用\对下面字符转义: \`,\*,\_,\{\},\[\],\(\),\#,\+,\-,\.,\!  
\`code\`  
`code`  
``code contain ` character``  

特殊字符转换：&copy; &amp; &lt; AT&T  

<br>

#### Tables

A simple table looks like this:

First Header | Second Header | Third Header
------------ | ------------- | ------------
Content Cell | Content Cell  | Content Cell
Content Cell | Content Cell  | Content Cell

If you wish, you can add a leading and tailing pipe to each line of the table:

| First Header | Second Header | Third Header |
| ------------ | ------------- | ------------ |
| Content Cell | Content Cell  | Content Cell |
| Content Cell | Content Cell  | Content Cell |

Specify alignement for each column by adding colons to separator lines:

First Header | Second Header | Third Header
:----------- | :-----------: | -----------:
Left         | Center        | Right
Left         | Center        | Right


<br>

Markdown推荐教程  
[Markdown文件](http://markdown.tw/#p)  
[Markdown 作者](http://daringfireball.net/projects/markdown/)  
[开始使用Markdown](http://ued.taobao.org/blog/2012/07/getting-started-with-markdown/)  
