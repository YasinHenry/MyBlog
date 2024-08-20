# git 命令：

[TOC]

## 配置

### 用户标示：

```$ git config --global user.name "Your Name"```
`$ git config --global user.email "email@example.com"`

## 本地版本库：

选择位置：
`$ mkdir learngit`
`$ cd learngit`
`$ pwd`
`/Users/michael/learngit`
初始化版本库：
`$ git init`


在版本库下的文件readme.txt，添加到缓存区
`$ git add readme.txt`


把缓存去的文件提交到仓库 -m 加批语：
`$ git commit -m "wrote a readme file"`

修改刚才提交的内容或者说明：
`$ git commit --amend  --> 编辑提交说明，内容为当前缓存区的内容，如果没有后续提交内容还是和上次一样`
添加提交遗漏的文件
`$ git commit -m 'initial commit'`
`$ git add forgotten_file`
`$ git commit --amend`


查看版本库目录下的状态：
`$ git status`

查看readme.txt修改了什么内容：
`$ git diff readme.txt` 

把修改的提交到缓存区：
`$ git add readme.txt`

把缓存区文件提交到仓库
`$ git commit -m "add distributed"`

查看历史记录：
`$ git log`

上面命令打印太多，简化一下：
`$ git log --pretty=oneline`

查看是否有需要push到git服务器上的代码

`$ git log origin/master..HEAD`

退回版本到上一个版本：(--hard 删除回退版本的修改内容，--soft 回退版本的内容会回到工作空间)
`$  git reset --hard HEAD~1`

`$  git reset --soft HEAD^^`

> ^^ 的多少代表往前回退几个版本（windows中 ^ 被认为是换号符操作时需要多加一个^，推荐使用HEAD~1）
>
> ~ 后的数字代表往前回退的版本数

此时再看版本历史，发现最新的已经看不到了：
`$ git log <branch>`

要回到回退之前的版本怎么办，只要此时命令窗口没有关闭：
往上翻找此命令窗口的记录可以找到回退的版本id：
`$ git reset --hard 3628164  #就回来了`
如果关掉了怎么办：
用来记录每一条命令(包括被删除的commit 和 reset ; 当删除或者回退导致的误操作可以使用此命令找到锚点版本号找回来。)：date=iso显示日期
`$ git reflog  <branch> --date=iso` 
找到我们提交时的那个版本就可以了


查看工作区与版本库中最新内容的区别：
`$ git diff HEAD -- readme.txt`

丢弃工作区的修改:
`$ git checkout -- readme.txt`
命令git checkout -- readme.txt意思就是，把readme.txt文件在工作区的修改全部撤销，这里有两种情况：
一种是readme.txt自修改后还没有被放到暂存区，现在，撤销修改就回到和版本库一模一样的状态；
一种是readme.txt已经添加到暂存区后，又作了修改，现在，撤销修改就回到添加到暂存区后的状态。
总之，就是让这个文件回到最近一次git commit或git add时的状态。
git checkout -- file命令中的--很重要，没有--，就变成了“切换到另一个分支”的命令


git reset HEAD file可以把暂存区的修改撤销掉（unstage），重新放回工作区：

`$ git reset HEAD readme.txt`

场景1：当你改乱了工作区某个文件的内容，想直接丢弃工作区的修改时，用命令git checkout -- file。
场景2：当你不但改乱了工作区某个文件的内容，还添加到了暂存区时，想丢弃修改，分两步，第一步用命令git reset HEAD file，就回到了场景1，第二步按场景1操作。
场景3：已经提交了不合适的修改到版本库时，想要撤销本次提交，参考git reset --hard HEAD^，不过前提是没有推送到远程库。

删除文件:
从版本库：
`$ rm test.txt`
git status命令会立刻告诉你哪些文件被删除了：
选择1从版本库中删除此文件：
`$ git rm test.txt`
并且git commit
选择2rm错了：
`$ git checkout -- test.txt`

取消文件追踪：

```bash
$ git rm --cached [file_name] # 取消文件追踪，不删除本地文件
$ git rm --f [file_name] # 取消文件追踪，并删除本地文件
```



```
$ git checkout -- . # 撤销工作空间修改，回到最近一次git commit或git add时的状态
$ git reset version # 回退到 version 代码不会退到工作空间，默认（--mixed）
$ git reset --hard version\HEAD^\HEAD^^ # 回退到指定版本或以当前HEAD为基准网上回退几个提交版本， 代码不会退到工作空间
$ git reset --soft version\HEAD~1\HEAD^^  # 回退到指定版本或以当前HEAD为基准网上回退几个提交版本， 代码会退到工作空间
```

```
# 当使用git reset 回退到了已经push到远程仓库的版本号时，再次push服务器会拒绝你的推送，遇到这种情况只能~强制推送覆盖远程分支~: -f=--force
git push -f origin
```







## 远程仓库：

### 生成密钥

`$ ssh-keygen -t rsa -C "youremail@example.com"`
`$ ssh-keygen -t rsa -C "yasinwang@126.com"`

远程仓库的连接是用ssh协议：
在本地创建公钥和私钥：
`$ ssh-keygen -t rsa -C "youremail@example.com"`
在本用户目录下有.ssh 下有id_rsa是私钥，id_rsa.pub是公钥（要把内容存到远程服务器上）
接下来用浏览器访问远程库的web界面，创建一个远程项目，之后会提示你怎么关联本地库，和克隆远程库。


把本地库的内容推送到远程，用git push命令，实际上是把当前分支master推送到远程。
由于远程库是空的，我们第一次推送master分支时，加上了-u参数，Git不但会把本地的master分支内容推送的远程新的master分支，还会把本地的master分支和远程的master分支关联起来，在以后的推送或者拉取时就可以简化命令。
`$ git push -u origin master #关联后第一次推送`
`$ git push origin master # 之后再推送`

关联远程库：
`$ git remote add origin git@example:user/projectname`
origin 为在本地取得远程库的名字（origin 与 git@example:user/projectname如键值对关系 ）

重新设置远程仓库地址
`$ git remote set-url origin git@other:user/projectname`

当更改远程仓库地址或新增并从新增的远程仓库地址pull 操作时报"[fatal: refusing to merge unrelated histories]()" 这通常是因为你更换了远程仓库地址后，新的远程仓库中包含了本地仓库中不存在的提交。 解决办法

```
git pull origin main --allow-unrelated-histories
```


查看远程库：
`git remote -v #-v 选项（译注：此为 --verbose 的简写，取首字母），显示对应的克隆地址`


pb如origin 指代对应的仓库地址了
git fetch pb  # 要抓取远端仓库pb所有的分支到本地但不合并，但本地仓库没有的信息,到本地但不会合并


删除远程库paul:
`$ git remote rm paul`


远程仓库 pb从命名paul：
`$ git remote rename pb paul`


远程仓库的删除：
`$ git remote rm origin`

查看某个远程仓库的详细信息
`$ git remote show origin`
如果是在 master 分支，就可以用 git pull 命令抓取数据合并到本地

设置追踪远程分支（本地分支关联远程分支）

`$ git branch --set-upstream-to=origin/<branch> local_branch`




推送数据到远程仓库
`$ git push origin master`

分枝：
创建分之dev , -b 代表创建并切换
`$ git checkout -b dev`
Switched to a new branch 'dev'


查看当前分之：
`$ git branch`

查看分支详情
`$ git branch -v`

查看所有分支（包括远程）
`$ git branch -a`

查看所有分支（可以看到本地分支追踪的远程分支）
`$ git branch -vv`


创建分支：
`$ git branch <name>`

重命名分支：
`$ git branch -m oldbranchname newbranchname`

重命名远程分支：

`$ git push origin :old-branch new-branch`


切换到master分枝：
`$ git checkout master`

在master分支上时，把dev合并到master 分支上去：
`$ git merge --not-ff dev  # git merge命令用于合并指定分支到当前分支,--not-ff 代表使master的提交记录不会被打乱`

合并远程分支

- step 1: 获取并检出此合并请求的分支

  `git fetch origin`

  `git checkout -b develop origin/develop`

- step 2: 本地审查变更

- step 3: 合并分支并修复出现的任何冲突

  `git fetch origin`

  `git checkout origin/master`

  `git meger --no-ff develop`

- step 4: 推送合并的结果到GitLab, 因为上面git checkout origin/master 非本地分支，是远程分支的一个快照，我们这这个快照中合并分支后推送到gitlag 服务端需要是 “HEAD:master” 这样分支名前加“HEAD:branch”

  `git push origin HEAD:master` 




删除分支：
`git branch -d <name>`

删除远程分支：
`git push origin :branch_you_want_to_delete  # origin 远程仓库名，branch_you_want_to_delete 删除的分支名`


图形
`gitk`


列显已有的标签(在开发中经常为么个时间的版本打上标签比如发布版本1.0):
`git tag`
显示的标签按字母顺序排列，所以标签的先后并不表示重要程度的轻重


搜索符合要求的标签：
`git tag -l 'v1.4.2.*'`


新建标签：
Git 使用的标签有两种类型：轻量级的（lightweight）和含附注的（annotated）
含附注的标签:
`git tag -a v1.4 -m 'my version 1.4'   #用 -a （译注：取 annotated 的首字母）`


git show v1.4 # 查看标签的详细信息


签署标签：
如果你有自己的私钥，还可以用 GPG 来签署标签，只需要把之前的 -a 改为 -s （译注： 取 signed 的首字母）即可：
`git tag -s v1.5 -m 'my signed 1.5 tag'`


轻量级标签：
`git tag v1.4-lw`


验证标签


可以使用 git tag -v [tag-name] （译注：取 verify 的首字母）的方式验证已经签署的标签。此命令会调用 GPG 来验证签名，所以你需要有签署者的公钥，存放在 keyring 中，才能验证：
`git tag -v v1.4.2.1`


后期加注标签：
`git log --pretty=oneline`
 》9fceb02d0ae598e95dc970b74767f19372d61af8 updated rakefile


我们忘了在提交 “updated rakefile” 后为此项目打上版本号 v1.2，没关系，现在也能做。只要在打标签的时候跟上对应提交对象的校验和（或前几位字符）即可：
`git tag -a v1.2 9fceb02`


分享标签
默认情况下，git push 并不会把标签传送到远端服务器上，只有通过显式命令才能分享标签到远端仓库。其命令格式如同推送分支，运行 git push origin [tagname] 即可：
`git push origin v1.5`
如果要一次推送所有本地新增的标签上去，可以使用 --tags 选项：
`git push origin --tags`


查看各个分支最后一个提交对象的信息，运行 
`git branch -v`


要从该清单中筛选出你已经（或尚未）与当前分支合并的分支，可以用 --merge 和 --no-merged
`git branch --merged/--no-merged`


强制用远程分支覆盖本地分支：
`git fetch --all ## 把远程分支同步下来, git fetch与git pull 区别是不与本地分支merge`
`git reset --hard origin/master ## 强制用下载下来的master分支覆盖本地现在分支`



本地对比远程分支：
`git diff origin/dev`



reset checkout -- restore区别

```
git reset 操作会将 HEAD 指向的分支指针移动到指定的提交，同时撤销之前的 commit。它还可以用来修改暂存区中的文件,多用于~批量回退版本到某个版本提交的位置，此位置之后的提交将被回退~。

git restore 操作用于恢复工作区或暂存区中被修改的文件到指定的提交状态。它可以用于撤销文件的更改，但不影响 Git 仓库中的提交历史。

git checkout -- . 操作将当前目录下所有被修改的文件恢复到最近一次 commit 的版本。它类似于 git restore ，但是只能恢复整个目录和暂存区中的文件，而不是一个单独的文件。

git revert 用于撤销~指定提交~的更改（只针对当前提交的内容回退），并且创建一个新的提交来记录这个撤销操作。与 git reset 不同，git revert 不会修改分支的历史记录，而是添加了一个新的提交来表示撤销的更改。因此，git revert 可以安全地应用于已经在共享存储中的提交。需要注意的是，如果要回滚多个提交，通常最好使用 git reset 命令;由于是此命令不会修改分支的历史记录而是添加一个新的提交，当revert一个merge一个分支操作时,当下次再次merge此分支会导致代码冲突和此前revert的合并内容不会合并进来。针对merger操作可以考虑使用reset操作，或者stash保存当前需要撤销的合并之后合并再应用。

git restore <file>：撤销对工作副本中指定文件的更改。
git restore --staged <file>：撤销对暂存区的更改，即将已暂存的文件恢复到未暂存的状态。

对文件、目录：工作副本和缓存区（git restore 是git checkout -- 的优化版，因为它提供了更清晰的命令行选项和行为）
git checkout – 和 git restore 通常用于撤销对工作副本或暂存区的更改，而不改变提交历史。
对版本，级别可以是commit后的恢复，reset是恢复到某次版本号。revert是针对当前版本号回退。
git reset 可以用于撤销提交历史，但使用时要小心，因为它可能会改变历史记录。
git revert 用于在不改变现有历史的前提下，撤销之前的提交更改。
```

一键删除未追踪的文件

```
git clean -n  会列举出要删除的文件
git clean -f  会删除未追踪的文件
git clean -n -d 要查看将要被删除的未追踪文件和目录列表
git clean -f -d 实际删除这些未追踪的文件和目录
```

代码分支合并

```
git checkout develop
git merge origin/develop-1 #把develop-1 分支代码合并到develop上
git merge origin/develop-1 --allow-unrelated-histories #git 默认是不允许两个没有共同相关历史提交的两个分支的代码合并在一起的，但是非要合并到一起可以使用参数--allow-unrelated-histories 但是需要注意可能会导致冲突和数据丢失
git merge 参数还有如下：
--no-commit：在自动合并时不进行提交。这样可以查看合并后的代码，并在确认无误后手动提交。
--ff-only：只使用快进合并。如果当前分支没有任何新的提交，那么合并操作将自动执行快进合并。否则，将会出现 "not a fast-forward" 错误。
--no-ff:和--ff-only 相反，非快速合并。
--squash：执行 squash 合并。这意味着 Git 会将两个分支中的所有更改都压缩到一个新的提交中，而不是创建一个新的合并提交，一版情况主分支合并到开发分支为了保持。Squash 合并是一种将多个提交压缩成单个提交的方法，没有显示的合并历史记录。这使得开发分支能够保持干净整洁，而不会包括合并的历史记录。相反，如果您想要将开发分支的更改合并到主分支中，则可能需要保留合并历史记录。因为这有助于跟踪和理解代码库的演变过程。通常情况下，推荐在开发分支上使用 Squash 合并来保持干净整洁的分支历史记录，在主分支上使用普通的合并策略来保留合并历史记录。但具体还要根据您的项目需求和团队协作方式来决定。
--strategy=<strategy>：指定合并策略。常用的策略包括 recursive（递归合并）、resolve（解决合并）和 octopus（章鱼合并）等。
--abort：取消尚未完成的合并操作。
-m <parent-number>：当合并有多个父节点时，指定要使用的父节点号码。通常情况下，Git 可以自动检测父节点，但有时需要手动设置
```

只合并develop-1 的某一次提交到develop 中如何实现

```
1、在develop-1当前分支确定要合并的提交id
git log --pretty=oneline
2、切换会develop 中
git checkout develop
3、把此次提交Id的内容合并到develop
git cherry-pick <commit_id>
4、解决冲突推送
```

标签

```
#查看当前分支： 
$ git tag
#添加本地标签：
$ git tag -a 版本号
#删除本地标签: 
$ git tag -d 版本号
#推送某标签至远程：
$ git push origin 版本号
#推送全部标签至远程：
$ git push origin –tags 提交所有tag至远程，使用git push origin 不会提交本地标签
# 删除远程标签： 
$ git push origin :refs/tags/版本号
```

### 轻量标签

轻量标签（lightweight tag）仅仅是一个指向特定提交的引用，它不会存储任何额外的信息。创建轻量标签的命令如下：

```shell
git tag {标签名} {提交ID}
```

例如，创建一个指向最新提交的轻量标签：

```shell
git tag v1.0.0
```

### 附注标签

附注标签（annotated tag）是存储在Git数据库中的一个完整对象，它有一个标签名，标签信息，标签签名等信息。创建附注标签的命令如下：

```shell
git tag -a {标签名} -m "{标签信息}" {提交ID}
```

例如，创建一个指向最新提交的附注标签：

```shell
git tag -a v1.0.0 -m "Release version 1.0.0" HEAD
```

### 查看标签

查看当前项目中的所有标签，可以使用以下命令：

```shell
git tag
```

如果想查看某个具体标签的信息，可以使用以下命令：

```shell
git show {标签名}
```

### 推送标签

默认情况下，`git push`命令不会将标签推送到远程服务器，需要使用以下命令将标签推送到远程服务器：

```shell
git push origin {标签名}
```

如果要一次性推送所有本地标签，可以使用以下命令：

```shell
git push origin --tags
```

### 删除标签

删除本地标签的命令如下：

```shell
git tag -d {标签名}
```

删除远程标签的命令如下：

```shell
git push origin :refs/tags/{标签名}
```

### 分支描述

为分支添加描述，便于分支太多无法分别

```
git config branch.<branch>.description "分支描述"
```

查看分支描述
```shell
git config branch.<branch>.description
```



## git-lfs大文件存储

> tip:
>
> 1. 在安装git时不要选中git自带的git-lfs ，后续下载git lfs 程序安装
> 2. 在将大文件添加进缓存区（git add 操作）之前要使用git lfs对文件追踪（eg: git-lfs track "*.text*"）
> 3. 在工程目录下安装lfs（git lfs install ）

### git-lfs 执行流程

> 注意顺序，部分步骤可以少，但顺序不可乱

1. 初始化git工程(如果是clone 的项目则无需此部)

   `git init`

2. 安装lfs

   `git lfs install ` or `git lfs install --skip-smudge`

   相反操作`git lfs uninstall`

3. lfs 追踪大文件(eg：whl后缀文件)

   > 执行下面命令会生成**.gitattributes** 里面就是配置追踪文件的规则

   `git lfs track "*.whl"`

4. 将**.gitattributes**添加到缓存区提交推送

   ```
   git add .gitattributes
   git commit -m "LFS track files"
   git push origin develop
   ```

5. 追踪的大文件添加缓存区

   `git add xxx.whl`

6. 提交推送git服务器

   ```
   git commit -m "LFS commit"
   git push origin develop
   ```

> 1. 在第3步之后可以验证lfs track 配置是否成功
>
>    `git lfs track`
>
> 2. 不想使用lfs追踪管理了
>
>    `git lfs untrack "*.whl"`
>
> 3. 在第5步之后可以验证当前添加进缓存区的大文件有没有被git-lfs追踪（之前因为安装git时选中git自带的git-lfs在这里碰到过坑）
>
>    `git lfs ls-files`
>
> 4. 使用命令查询lfs状态
>
>    `git lfs status`

7. 平常拉去代码使用命令`git pull` 只会拉去lfs追踪的大文件的指纹，要拉取真正的文件需要使用`git lfs pull` fetch 同样适用。
8. 如果在git lfs track "*.whl*" 之前缓存区已经存在了.whl 大文件，管理历史存在的，可以使用以下命令

```
git lfs migrate import --include-ref=master --include="biger.zip"
```

> --include-ref 选项指定导入的分支
>
> 如果向应用到所有分支，则使用--everything选项
>
> --include 选项指定要导入的文件。可以使用通配符，批量导入。



9. 上述操作会改写提交历史，如果不想改写历史，则使用 `--no-rewrite`选项，并提供新的commit信息：

   ```
   git lfs migrate import --no-rewrite -m "lfs import"
   ```

   

10. 如果一个仓库中包含LFS内容，但是在推送时不想推送这类文件，只要加上 `--no-verify`选项

```
git push --no-verify
```







