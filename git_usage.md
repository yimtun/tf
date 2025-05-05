# 10 git 四种对象  commit tree/目录  blob/文件  tag


```
git cat-file  -p 5ebe7a4122c9
```

# 11 查看对象类型

```
git cat-file  -t 5ebe7a4122c9
```

# 12  分离头指针 detached HEAD' state


工作在没有任何分支的情况下了

```
git checkout ebd18ec1812bd6f3de54d9f9fc81563a0ec9f264
```





```
git status
HEAD detached at ebd18ec18  当前head没有指向任何分支 就是分离头指针的状态
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md
```


```
git branch -av
* (HEAD detached at ebd18ec18)   ebd18ec18 SSL: disabled TLSv1 and TLSv1.1 by default.
  master                         29aec5720 Upstream: copy upstream zone DNS valid time during config reload.
  remotes/origin/HEAD            -> origin/master
  remotes/origin/default         fb89d50ee Stream: OCSP stapling.
  remotes/origin/master          29aec5720 Upstream: copy upstream zone DNS valid time during config reload.
  remotes/origin/radix_with_skip 350d02749 add radix tree skip node
  remotes/origin/stable-0.5      b42ef0b68 release-0.5.38 tag
```


如果在分离都指针的情况下创建了commit 也可以基于commit 创建一个分支 如果不创建 
git会丢弃之前的commit



```
git branch <new-branch-name> f1a38af16

git branch fix_test f1a38af16
```

```
没有基于分支做变更时,会产生分离头指针，如果不重要仅是临时测试，可以不用基于分离头指针下的commit 创建分支
```

# 13 HEAD 特殊标识符

```
cat .git/HEAD  # 查看当前head 指向的分支 或 commit   // 但是最终都是指向一个commit
ref: refs/heads/master
```

HEAD 特殊标识符

```
git diff HEAD HEAD^
```

# 14 删除分支

```
git branch -D 分支名
```

# 15 基于当前分支 修改最近一次的commit 做message变更

```
git commit --amend
```

# 16 修复历史commit的message 

```
git rebase -i ebd18ec18 // 目标commit 的前一个commit
```

```
git rebase -i ebd18ec18
hint: Waiting for your editor to close the file... 
reword 9891d33a4 Back gagadd  ##reword
pick 5c0ad9d9f xxxxx 
```

# 17 将连续的多个commit 合并为一个commit



```
git rebase -i ebd18ec1812bd6 #'合并的前一个commit'
hint: Waiting for your editor to close the file... 
pick a0487497f Back gagaddsdfokokookokok
squash e5e4c6490 xxxxx #squash
squash d4817ce54 test s 
pick cbab94ffe test x



# This is a combination of 3 commits.
Create only one commit
# This is the 1st commit message:

```


# 18 ？ 将不连续的多个commit 合并为一个commit 


```
git rebase -i xxx
```

执行后出现了两个commit 没有祖先 正常情况下应该只有一个commit 是没有祖先的


# 19 暂存区和HEAD 做比较

```
git add README.md  #将修复添加到暂存区
yandundeMacBook-Pro:nginx yandun$ git status
On branch fix_test
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   README.md
```

```
git diff --cached 
diff --git a/README.md b/README.md
index 1ff7a0436..22f2f6951 100644
--- a/README.md
+++ b/README.md
@@ -1,4 +1,4 @@
-dddd
+ddddddd

```



当前分支的暂存区（staging area / index） 和 当前分支的 HEAD（上一次提交） 之间的差异。
```
git diff --cached
```





比较当前分支的暂存区和 master 的 HEAD：

```
git diff --cached master
```

# 20 比较工作区和暂存区的差异

```
git diff
```


比较工作区和暂存区的区别 仅比较指定文件

```
git diff -- README.md
```

# 21 工作区的变更 比暂存区的变更 更好

取消暂存区所有变更 恢复到和head 一样的

暂存区的所有变更都不想保留了

```
git reset HEAD  #后面不添加任何文件
```



```
git reset HEAD（等价于 git reset --mixed HEAD）
会把暂存区（staging area / index）的内容重置为当前分支 HEAD 的内容。
换句话说：把你已经 git add 到暂存区但还没 commit 的更改，全部“取消暂存”，但这些更改还会保留在你的工作区（working directory）。
```


```
git diff --cached ##先diff暂存区和最近一次提交
diff --git a/README.md b/README.md
index 1ff7a0436..864433f4e 100644
--- a/README.md
+++ b/README.md
@@ -1,4 +1,6 @@
-dddd
+ddddddd
+
+
 
 
 git reset HEAD # 取消暂存区变更 
Unstaged changes after reset:
M	README.md

git diff --cached #再次比较暂存区和最近一个commit
没有输出 即没有差异
```

# 22 将工作区内容 恢复到和暂存区一致



```
git diff  # 先比较一下工作区和暂存区的差别
diff --git a/README.md b/README.md
index 1ff7a0436..06d55b152 100644
--- a/README.md
+++ b/README.md
@@ -1,4 +1,7 @@
-dddd
+ddddddd
+
+
+工作区 
```

```
git checkout README.md # 或者 git restore README.md 
Updated 1 path from the index
Updated 1 path from the index
```

再次比较工作区和暂存区差别

```
git diff  # 无输出 即没有差别
```

# 23 取消暂存区部分文件的更改

```
git status #暂存区修改的文件
On branch fix_test
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   LICENSE
	modified:   README.md


git reset HEAD -- LICENSE # 恢复指定文件

git status # 再次查看 只有一个文件了
On branch fix_test
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   README.md
```

# 24 消除最近几次提交


```
git reset --hard xxid  # 暂存区和工作区 也都恢复到这个指定的commitID 了
```

# 25 查看不同commit 指定文件的差异

```
git diff fix_test master -- README.md # 指定文件在2个分支中的差异
git diff commidA  commidB -- README.md # 指定文件在2commit 中的差异
```

# 26 删除文件

```
rm xxx.md #    工作区删除文件
git rm  xxx.md # 暂存区删除文件


可以直接用 git rm xxx.md 就可以了 它会直接删文件并同步到暂存区
```

# 27 临时加塞紧急任务

一部分文件已经在暂存区中，一部分文件在工作区修改当中

```
git stash list


git stash  # 临时保存你当前工作区和暂存区的修改
git stash apply  # 1 把之前的内容放到工作区 2 stash  列表信息还在  不会被删除
git stash pod    # 1 把之前的内容放到工作区   2 stash  列表信息 会被删除

```

# 29  仓库备份

克隆一个没有工作区的裸仓库

```
git clone --bare https://github.com/nginx/nginx.git
```

智能协议-file 协议


智能协议 file 备份一个仓库
```
git clone --bare file:///x/y/z/.git   zhineng.git

```


测试 将本地变更同步到远端仓库


添加远端仓库

```
git remote add zhineng file:///x/y/z/zhineng.git
```


```
git push --set-upstream zhineng sulixxx
```

# 33 

```
git push remoteName --all // push 所有分支到 remote
```

```
git fetch remoteName master
```

执行下merge

```
git checkout master
git merge --allow-unrelated-histories  remoteName/master
```


merge 后push

```
git push remoteName master
```

# 34 在同一个分支中 两个人修改了不一样的文件



```
git fetch remoteName

#因为是修改了同一个分支的 不同文件 所以merge 会比较顺利
git merge  remoteName/remoteBranch
```


# 35 在同一个分支中 两个人修改了一样文件的不同区域


```
git fetch
git branch -av
git merge remoteName/remoteBranch
```


# 36 在同一个分支中 两个人修改了一样文件的相同区域


```
git merge remoteName/remoteBranch
Already up to date # 说明远端变了


git pull  # fetch and merge
conflict


vim 冲突文件

git status
you have unmerged paths

git commit -am "xxx"

git status


git push remoteName
```

# 37 同时变更了文件名 和文件内容

```
git mv  x x1
git commit -am "xxx"


non-fast-froward


git pull
```

# 38  2个人同时修改了同一个文件为不同的文件名

```
git mv x x1
git mv x x2

git pull

git status
#unmerged paths
index.htm
index1.htm
index2.htm




git rm  index.htm
git add index1.htm
git rm index2.htm

git status
all conflicts fixed but you are still merging


git commit -am "xxx"
```

# 49 github merge选项


merge:   Create a merge  commit 会把 PR 里的所有提交原样合并到目标分支，保留每一个 commit


merge:   Squash and merge
会把 PR 里的所有提交“压缩”为一个新的提交，只在目标分支上留下这一个 commit，commit message 可以自定义（默认是所有 commit message 的合并）。


merge:   Rebase and merge
会把 PR 里的每个提交“平铺”到目标分支上，像是直接在目标分支上逐个提交。


# 53  rebase 和 rerere 

```
git checkout Shanghai
git rebase origin/master 

vim readme  解决冲突
git add .   修改保存到暂存区


git rebase --continue 
vim readme   解决冲突
git add .   修改保存到暂存区


git rebase --continue 
# 之前有多个提交 就可能做多次的 git rebase --continue

git status

git push -f origin Shanghai


Shanghai puu request 2 master
```

减少上面的对同一个冲突的多次修改

```
git config --global rerere.enabled true
git rerere status

git merge master
Recorded preimage for 'readme'


vim readme
git add .
git commit -m 'temp'
git reset --hard commitID

git rebase commitID
提示有冲突
vim readme  但是之前已经记录了知道怎么解决冲突了

git rebase --continue
git add readme # 不需要再反复解决冲突


```


# cmd

从暂存区移除文件到工作空间

```
git rm --cached test.md
```