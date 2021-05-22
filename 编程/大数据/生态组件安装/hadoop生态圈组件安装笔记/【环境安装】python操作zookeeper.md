#### 1. 环境

名称 | 版本
---|---
centos | 7.5
python | 2.7.5
zookeeper | 3.4.10

#### 2. 安装步骤
1. 首先，安装要依赖的zookeeper的c的客户端。
    ```linux
    cd path/zookeeper/src/c
    ./configure
    ```
    <font color=red>如果有以下报错信息：</font>
    ```
    (py2) [root@master c]# ./configure 
    checking for doxygen... no
    checking for perl... /usr/bin/perl
    checking for dot... no
    checking for a BSD-compatible install... /usr/bin/install -c
    checking whether build environment is sane... yes
    checking for gawk... gawk
    checking whether make sets $(MAKE)... yes
    checking for cppunit-config... no
    checking for Cppunit - version >= 1.10.2... no
    checking for generated/zookeeper.jute.c... yes
    checking for generated/zookeeper.jute.h... yes
    checking for gcc... no
    checking for cc... no
    checking for cc... no
    checking for cl... no
    configure: error: no acceptable C compiler found in $PATH
    See `config.log' for more details.
    ```
    <font color=red>执行以下命令：</font>
    ```
    yum -y install gcc*
    ./configure
    make
    make install
    ```
2. 安装zkpython，通过pip和源码方式安装
    1. pip安装：
        ```linux
        pip install zkpython
        ```
    2. 源码安装：
    首先进入到：https://pypi.org/search/?q=zkpython 下载源码
        ```linux
        解压之后进入目录执行以下命令
        python steup.py install
        ```
3. 添加环境变量：
    ```linux
    export LD_LIBRARY_PATH=/usr/local/lib
    ```
    **如果不添加环境变量，在import zookeeper包的时候会报错：**
    ```python
    >>> import zookeeper
    Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
    ImportError: libzookeeper_mt.so.2: cannot open shared object file: No such file or directory
    ```
#### 参考资料
https://www.jianshu.com/p/11199dd5487e

https://www.cnblogs.com/fusx/p/10599448.html

https://www.cnblogs.com/mangoVic/p/6428369.html
#### 错误信息：
gcc错误：[参考链接1](https://blog.csdn.net/qq_34485930/article/details/80934025)，[参考链接2](https://blog.csdn.net/hongweigg/article/details/72957213)

    
    
<br>
<br>
<br>
<br>
Author:z2615@163.com