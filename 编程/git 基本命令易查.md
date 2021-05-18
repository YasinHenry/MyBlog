git 命令：


安装后，本机配置机器唯一标示：
```$ git config --global user.name "Your Name"```
`$ git config --global user.email "email@example.com"`


创建本地版本库：
选择位置：
`$ mkdir learngit`
`$ cd learngit`
`$ pwd`
`/Users/michael/learngit`
创建版本库：
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


退回版本到上一个版本：
`$ git reset --hard HEAD^`
当然，下面命令是回到上上个版本：
`$ git reset --hard HEAD^^ 依次类推`
此时再看版本历史，发现最新的已经看不到了：
`$ git log`
要回到回退之前的版本怎么办，只要此时命令窗口没有关闭：
往上翻找此命令窗口的记录可以找到回退的版本id：
`$ git reset --hard 3628164  #就回来了`
如果关掉了怎么办：
用来记录每一条命令：
`$ git reflog`
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


远程仓库：
`$ ssh-keygen -t rsa -C "youremail@example.com"`
`ssh-keygen -t rsa -C "yasinwang@126.com"`


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


推送数据到远程仓库
`$ git push origin master`


分枝：
创建分之dev , -b 代表创建并切换
`$ git checkout -b dev`
Switched to a new branch 'dev'


查看当前分之：
`$ git branch`


创建分支：
`$ git branch <name>`


重命名分支：
`$ git branch -m oldbranchname newbranchname`


切换到master分枝：
`$ git checkout master`


在master分支上时，把dev合并到master 分支上去：
`$ git merge dev  # git merge命令用于合并指定分支到当前分支`


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
`git fetch --all ## 把远程分支同步下来`
`git reset --hard origin/master ## 强制用下载下来的master分支覆盖本地现在分支`



本地对比远程分支：
`git diff origin/dev`