# 本地yum源及局域网yum源
> 这东西不常用，忘得快，但是每次用都要网上查好多，感觉没一个写的全的，索性这次搭建的时候写了此笔记

[TOC]


## 配置本地yum源，网络源
### 备份默认yum源
```bash
\> tar -cf ~/yun.repos.d.tar yum.repos.d
\> rm -f /etc/yum.repos.d/*
```
### 替换yum 源
> 根据系统下载阿里或163 yum源配置
>
> > 详见：阿里云官方教程：[http://mirrors.aliyun.com](http://mirrors.aliyun.com/)
> >
> > ```properties
> > 		163官方教程：[http://mirrors.163.com/.help/centos.html](http://mirrors.163.com/.help/centos.html)
> > ```
>
> 阿里
>
> > \# CentOS 5
> > ```wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo ```
>
> >  \# CentOS 6
> >  ```wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo ```
>
> > \# CentOS 7
> > ```wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo ```
>
> 163
>
> > \# CentOS 5
> > ```wget -O /etc/yum.repos.d/CentOS5-Base-163.repo http://mirrors.163.com/.help/CentOS5-Base-163.repo```
>
> > \# CentOS 6
> > ```wget -O /etc/yum.repos.d/CentOS6-Base-163.repo http://mirrors.163.com/.help/CentOS6-Base-163.repo```
>
> > \# CentOS 7
> > ```wget -O /etc/yum.repos.d/CentOS7-Base-163.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo```

### 重载yum信息缓存
```bash
\> yum clean all
\> yum repolist
\> yum makecache
```

## 离线(本地)yum源

### 上传镜像文件到本地目录

```bash
#只要开启了sshd即可使用sftp登录上传文件
\> sftp user@192.168.2.2
\> put CentOS-7-x86_64-Everything-1503-01.iso
```

### 创建镜像文件挂载目录，挂载镜像

```bash
\> mkdir /media/CentOS7
\> mount -t iso9660 -o loop /usr/local/src/CentOS-7-x86_64-Everything-1503-01.iso /media/CentOS7
# 配置开机自动挂载,下次开机备用
\> vi /etc/fstab
# 插入最低行
\> /usr/local/src/CentOS-7-x86_64-Everything-1503-01.iso /media/CentOS7 iso9660 defaults,ro,loop 0 0
# 测试开机是否能挂载成功
\> mount -a
```
> **tip**
> 	如果因为不能挂载会导致无法顺利开机，需进入单人维护模式,执行下面命令
> 	\\> mount -n -o remount,rw /

### 编辑文件/etc/yum.repos.d/centos7-media.repo
```properties
\> vi /etc/yum.repos.d/centos7-media.repo
[centos7-media]
name=centos7
baseurl=file:///media/CentOS7
enabled=1
gpgcheck=0
gpgkey=file:///media/CentOS7/RPM-GPG-KEY-CentOS-7
```
### 重载yum信息缓存
```
\> yum clean all
\> yum repolist
\> yum makecache
```


## 修改yum源的优先级
> 当既有本地源又有网络源的时候，我们安装软件的时候当然希望按着本地yum源去安装，当找不到安装包的时候在用网络软安装，那么这里就涉及了一个优先级的问题。
>

### 查看是否安装了优先级的插件
```\>  rpm -qa | grep yum-plugin-```
yum-plugin-fastestmirror-1.1.30-37.el6.noarch

> 我们看没有安装yum-plugin-priorities.noarch、yum-plugin-priorities.noarch这些插件,若没有安装执行下面安装命令
>
> ``` \> yum install yum-plugin-priorities.noarch -y```
>
> ``` \> yum install yum-plugin-fastestmirror.noarch -y```
>
> 查看插件是否可用
> ```\> cat /etc/yum/pluginconf.d/priorities.conf```
>
> [root@client yum.repos.d]# cat /etc/yum/pluginconf.d/priorities.conf
> [main]
> \# 1表示可用，0为禁用 
> enabled = 1

### 修改本地yum源优先使用

``` \> vi /etc/yum.repos.d/CentOS-Media.repo ```
> 添加priority=1，数字越小优先级越高，也可以修改网络源的priority的值



==先写到这里==
下面要参照[CentOS7下的YUM源服务器搭建详解](https://blog.csdn.net/u012402276/article/details/53158682)
和 [CentOS7搭建YUM源](https://www.jianshu.com/p/bd81e449068a)
不想用vsftpd 提供服务

## 自定义YUM源
> 查看安装createrepo (建仓工具)
> ```\> rpm -qa|grep createrepo```
> 没有安装需要安装：
> ``` \> yum -y install createrepo```


## 局域网YUM源
> 查看安装vsftpd
>
> ```
> \> rpm -qa|grep vsftp
> \> yum -y install vsftpd
> ```
>

### 配置vsftpd
```\> vi /etc/vsftpd/vsftpd.conf```