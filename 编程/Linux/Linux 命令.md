# Linux 命令

> 工作学习中linux 命令学习记录



1. 当使用 vi or vim编辑某个文件时发现没有这个文件的写权限，往往现在推出为时已晚。

   ```bash
   # 进入命令模式下,"%" 代表当前文件键入之后可以按 “tab” 键自动把%转换为当前全路径的文件名。
   :w !sudo tee %
   # 此命令是把当前文件（即%）作为stdin传给sudo tee命令来执行。
   # 用法：tee [选项]... [文件]...
   # 将标准输入复制到每个指定文件，并显示到标准输出。
   ```

2. 查看磁盘挂载情况 
	```bash
	   \> lsblk
	```

3. xml 文件格式化

   ```bash
   # 以下内容配置到.vimrc 文件，在使用vim格式化打开的xml文件时在正常模式下敲击 “gg=G” 这几个字符即可
   syntax on 
   filetype plugin indent on 
   ```

4. xml 文件格式化2

   ```bash
   # 1 保持文件
   :w
   # 2 启动自动缩进
   :filetype indent on
   # 3 设置文件类型
   : set filetype=xml
   # 4 全局格式化
   # 4.1 回到文件头，按键如下
   gg
   # 4.2 使用缩进（格式化），按键如下
   =
   # 4.3 格式化到文件尾，，按键如下
   G
   ```

   

5. 操作中常用目录切换的问题，pushd 、popd、dirs

   ```bash
   # 将目录放到栈中
   \> pushd `pwd` # 当前目录放入栈中
   \> pushd \home\user\data  # 将指定目录放到栈中
   # 查看栈中存放的目录路径
   \> dirs -v # 当前目录永远是第一个位置，坐标为0
   # 清空栈
   \> dirs -c
   # 从栈中弹出（删除）路径
   \> popd +N # N 为坐标 和 dirs -v 列出的数字一致；也可以使用 -N 就是倒叙第几个；或者直接执行popd 弹出当前目录到下一个目录
   # 不弹出目录，只是跳到栈中的目录
   \> pushd +N # 【N 意思的解释同上】
   
   ```

6. 在shell 脚本中经常看到的 `set -ex`  什么意思

   > -e 脚本中命令一旦运行失败就终止脚本的执行
   >
   > -x 用于显示出命令与其执行结果（默认shell脚本中只显示执行结果）
   >
   > +ex 表示不终止错误，不显示结果.

7. 查找开放的端口

   ```bash
   # 1 常用的netstat
   \> netstat -anp|grep 50070
   # 2 当linux 系统最小化安装的时候未必有netstat
   \> ss -ap | grep 50070
   ```

8. 判断服务器端口是否开放，端口是否通

   ```bash
   # 通常使用 telnet
   /> telnet 192.168.255.231 3306
   # 但是在没有netstat 命令的机器上可以使用curl 替换
   /> curl -vv telnet//:192.168.255.231:3306
   ```

9. 将用户添加到组中

   ```bash
   /> usermod -g mysql yasin
   # 查看用户所属组
   /> groups yasin
   ```

10. yum 查找要安装软件的版本有哪些

    ```bash
    yum list --showduplicates docker-ce
    ```

11. yum 默认安装软件版本信息

    ```bash
    yum info docker-ce
    ```

12. 下载并添加yum源

    ```bash
    yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    ```

13. 启动指定yum仓库

    ```bash
    yum-config-manager --enable docker-ce-nightly
    ```

14. 查看包依赖

    ```bash
    yum deplist docker-ce
    ```

15. 全量下载包依赖

    ```
    repotrack docker-ce
    ```

16. 增量下载包依赖（更加机器已安装）

    ```bash
    yumdownloader --downloadonly --resolve docker-ce
    ```

    

