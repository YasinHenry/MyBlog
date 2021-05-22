**0. Hive源码包下载**

http://mirror.bit.edu.cn/apache/hive/

**1. 下载软件包**

```
wget http://mirror.bit.edu.cn/apache/hive/hive-2.3.3/apache-hive-2.3.3-bin.tar.gz

tar zxvf apache-hive-2.3.3-bin.tar.gz
```

**2. 创建HDFS目录**

```
hadoop fs -mkdir -p /data/hive/warehouse 

hadoop fs -mkdir -p /data/hive/tmp

 hadoop fs -mkdir -p /data/hive/log 

hadoop fs -chmod -R 777 /data/hive/warehouse 

hadoop fs -chmod -R 777 /data/hive/tmp

hadoop fs -chmod -R 777 /data/hive/log
```

**创建文件系统目录**

`mkdir /data/hive/tmp`

**3. 修改Hive配置文件**

```
cd apache-hive-2.3.3-bin/conf

cp hive-default.xml.template hive-site.xml
```

**vim hive-site.xml**

```
<configuration>

​    <property>          <name>hive.exec.scratchdir</name>          <value>/data/hive/tmp</value>      </property> 

​    <property>        <name>hive.querylog.location</name>        <value>/data/hive/log/hadoop</value>    </property> 

​    <property>        <name>javax.jdo.option.ConnectionURL</name>        <value>jdbc:mysql://master:3306/hive?createDatabaseIfNotExist=true</value>    </property>

​    <property>        <name>javax.jdo.option.ConnectionDriverName</name>        <value>com.mysql.jdbc.Driver</value>    </property>

​    <property>        <name>javax.jdo.option.ConnectionUserName</name>        <value>hive</value>    </property>

​    <property>        <name>javax.jdo.option.ConnectionPassword</name>        <value>hive</value>    </property>

</configuration>
```

把{system:java.io.tmpdir} 改成 /data/hive/tmp

把 {system:user.name} 改成 {user.name}

`cp hive-env.sh.template hive-env.sh vim hive-env.sh` 

```
HADOOP_HOME=/usr/local/src/hadoop-2.6.5

HIVE_CONF_DIR=/usr/local/src/apache-hive-2.3.3-bin/conf

HIVE_AUX_JARS=/usr/local/src/apache-hive-2.3.3-bin/lib
```

**4.  增加环境变量**

\#Master、Slave1、Slave2

`vim ~/.bashrc`

```
HIVE_HOME=/usr/local/src/apache-hive-2.3.3-bin

PATH=$HIVE_HOME/bin:$PATH
```

\#刷新环境变

`source ~/.bashrc`

**5. 安装MySQL**

\#Master

```
yum -y install mysql-server

chkconfig --add mysql

service mysqld start
```

\#配置MySQL Root用户密码

```
mysqladmin -uroot password hadoop

grant all on \*.\* to 'hive'@'%' identified by 'hive';

flush privileges;
```

**6. 安装MySQL连接工具**

\#Master

1）下载安装包

```
wget https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.44.tar.gz

tar zxvf mysql-connector-java-5.1.44.tar.gz
```

2）复制连接库文件

`cp mysql-connector-java-5.1.44/mysql-connector-java-5.1.44-bin.jar /usr/local/src/apache-hive-2.3.3-bin/lib`

**7. 拷贝安装包**

```
scp -r /usr/local/src/apache-hive-2.3.3-bin root@slave1:/usr/local/src/apache-hive-2.3.3-bin

scp -r /usr/local/src/apache-hive-2.3.3-bin root@slave1:/usr/local/src/apache-hive-2.3.3-bin
```

**8. 启动HiveServer（WebUI）**

`hiveserver2 &`

**9. 启动Hive服务**

`hive`