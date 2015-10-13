---
layout: post
title: Git Merge Conflict
---

#{{ page.title }}  
<p class="meta">13 Oct 2015 - Guangzhou</p> 

---
当多人对同一文件进行修改时，经常会碰到冲突的情况。  
原本，程序员A和程序员B的branch都与远程repository同步，这时：  
可简单分为2种情况：  

* A和B的修改没有交集
* A和B的修改有交集

--------
# 1. A和B的修改没有交集

例如：**远程repository**有文件test.cc  

```cpp
void test()
{

}
```


1. A对test.cc做如下修改：

```cpp
// This is add from A
void test()
{

}
```

2. B**同时**对test.cc做如下修改：

```cpp
void test()
{
    // This is add from B
}
```

3. B**先**将B的修改push到远程repository

4. 随后，A准备push，但是提示：

```
To git@github.com:XXXX/XXXXXXXXXX.git
! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to 'git@github.com:XXXX/XXXXXXXXXX.git'
To prevent you from losing history, non-fast-forward updates were rejected
Merge the remote changes (e.g. 'git pull') before pushing again.  See the
'Note about fast-forwards' section of 'git push --help' for details.

```

5. 此时，A可以`git pull`，或先`git fetch`再`git merge`（推荐），然后会看到以下部分提示：

```
Auto-merging test.cc
Merge made by the 'recursive' strategy.
test.cc |    1 +
1 file changed, 1 insertion(+)
```

此时test.cc的内容是auto-merge后的结果：  

```cpp
// This is add from A
void test()
{
    // This is add from B
}
```

可以看到A pull后的文件同时包含了A和B的修改。  

----------------------------------
# 2. A和B的修改有交集

例如：**远程repository**有文件test.cc  

```cpp
void test()
{
    cout << "Do nothing" << endl;
}
```


1. A对test.cc做如下修改：

```cpp
// This is add from A
void test()
{
    cout << "I want to print A" << endl;
}
```

2. B**同时**对test.cc做如下修改：

```cpp
void test()
{
    cout << "I want to print B" << endl;
    // This is add from B
}
```

3. B**先**将B的修改push到远程repository

4. 此时，由于修改内容有交集，A可以运行`git stash`暂存本地的修改，并将当前分支还原到最后一次pull状态。  
然后`git pull`，或先`git fetch`再`git merge`（推荐），与最新的远程repository同步。  

5. 然后，A可以将A所做的修改还原，从栈调出，运行`git stash pop`或`git stash apply`。  
可是会看到以下部分提示：  

```
Auto-merging test.cc
CONFLICT (content): Merge conflict in test.cc
```

git尝试将test.cc的内容auto-merge，但是出现CONFILICT错误，也就是冲突，提示A去解决  
此时test.cc的内容如下：  

```cpp
// This is add from A
void test()
{
<<<<<<< Updated upstream
    cout << "I want to print B" << endl;
    // This is add from B
=======
    cout << "I want to print A" << endl;
>>>>>>> Stashed changes
}
```

出现这个冲突是因为文件有交集，导致冲突。  
在这个文件中，`<<<<<<< Updated upstream`与`=======`之间的部分是pull抓取的内容。  
`=======`与`>>>>>>>> Stashed changes`之间的部分是A本地修改的内容。  
git保留了没有交集的第一行`// This is add from A`，但是git并不知道交集部分哪些是需要的，所以交给程序员A去决定内容的取舍。  
程序员A与B应该通过沟通决定哪些代码需要，哪些不要。这时，沟通显得特别重要。  

例如，协商决定后，由A修改，用`print A`代替`print B`，保留B的代码注释。  

```cpp
// This is add from A
void test()
{
    cout << "I want to print A" << endl;
    // This is add from B
}
```

A修改完毕后，可以执行和以往一样提交，`$ git add .; git commit -m "msg"; git push`  

# 总结

在大型项目的团队开发中，git冲突可能会经常出现。  

* 对于文件内容没有交集的情形，git采用auto merge自动完成合并，这时可能得到的结果不是我们想要的。
* 对于存在交集的情形，git将冲突内容清晰的展示出来。但是，后续的代码修改的工作量将十分庞大，需要程序员之间合理的沟通。

因此，可采取以下方式减少git版本冲突。  

1. 不要直接在clone下来的master默认分支修改，建立自己的分支，如git branch my\_branch，切换git checkout my\_branch
2. 确保该文件在自己两次提交之间，没有被修改过。
3. 如果确实无法避免，只能手动merge了。

