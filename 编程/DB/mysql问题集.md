# linux 日常问题

1. mysql 安装

   > 使用yum install mysql-server 安装mysql 后 mysql可以启动并通过mysql 命令可以直接进入mysql CTL 。在mysql CTL 查看``show databases;` 无法看到mysql 数据库。使用`mysql -uroot -p`  无法登录报 ==**Can't connect to local MySQL server through socket '/var/lib/mysql/mysql.soc**==  查看==/etc/my.cnf== 文件 ==socket=/var/lib/mysql/mysql.sock==  （有人说socket 配置到了 /tmp/mysql.sock 下,建个软连接或者修改到此路径即可）配置是正确的，然后我们去指定的路径下看一下此文件是否存在，或者使用 `find / -name 'mysql.sock'` 找一下此文件在哪里。可惜这次问题是整个系统中都没有存在这样的文件。针对这个问题如果是新安装的mysql下面我使用了这样的处理方式
   >
   > ```bash
   > # 关闭mysql 数据库
   > /> systemctl stop mysqld
   > # 删除/var/lib/mysql下的所有文件(如果没把握记得本分)
   > /> rm -fr /var/lib/mysql/*
   > # 删除锁定文件
   > /> rm /var/lock/subsys/mysqld
   > # 杀死所有mysqld进程
   > />  killall mysqld 
   > # (启动mysql服务。
   > /> systemctl start mysqld
   > 
   > 本次操作对我最重要的是rm -fr /var/lib/mysql/*
   > 也许我的操作有问题，我在安装数据库服务器上直接使用`mysql` 登录的，后来发现使用`mysql -uroot -p`(默认是没有密码的)，让输入密码直接回车。这样子`show databases;` 时就看到mysql 数据库了。
   > ```
   >
   > 

