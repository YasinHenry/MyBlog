# hive 问题集



[TOC]

1. ## hive 和 mysql 安装并且配置完成hive的配置文件后 出现的一些问题

   > 我为hive 创建了新的用户(user-hive)及库(db-hive)

   ### 错误信息1：

   触发点：

   ```bash
   /> hive
   hive> show database;
   ```

   报错信息：

   > 
   >
   > FAILED: SemanticException org.apache.hadoop.hive.ql.metadata.HiveException: java.lang.RuntimeException: Unable to instantiate org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient 

   ### 错误信息2：

    触发点：

   ```
   /> hive --service metastore &
   ```

   报错信息：

   > > hive报错FAILED: SemanticException org.apache.hadoop.hive.ql.metadata.HiveException:
   >
   > > hMetaException(message:Version information not found in metastore. )   

   ### 解决问题

   1. mysql 远程连接

   > mysql 用户无法远程登录
   >
   > 1. `create user 'user-hive'@'%' identified  by '123456'; `
   >
   > 尝试使用 `mysql -h ip -uuser-hive -p` 登录，如果不行请再把登录权限指定到客户机的ip上`create user 'user-hive'@'[ip]' identified  by '123456'; ` 把[ip]换成hive安装的ip地址。
   >
   > 2. 把db-hive 数据库授权给db-hive用户
   >
   >    `GRANT ALL PRIVILEGES ON db-hive.* TO 'user-hive'@'[ip]' WITH GRANT OPTION;`  把[ip]换成上面创建的用户的ip
   >
   > 3. 直到 `mysql -h ip -uuser-hive -p`  命令可以登录问题解决

   2. hive 初始化

      > 指定hive 存储metastore 使用的数据库(我们用的是mysql)
      >
      > `schematool -initSchema -dbType mysql    `

   3. 启动hive 服务

      `hive --service metastore &`

      > 再次尝试触发问题命令，看是否解决问题。

2. ## hive 配置中使用的mysql l链接驱动版本问题 （mysql-connector-java-*.jar )

   > 我的数据库是5.6.51, 问题出现时使用的mysql驱动是mysql-connector-java-5.1.9.jar

   ### 错误信息1：

   触发点：

   ```bash
   hive/> show databases;
   hive/> drop table [table_name];
   hive/> load data inpath "data_path" overwrite into table [table_name]
   /> hive --service metastory
   ```

   报错信息1：

   > MySQL server version for the right syntax to use near OPTION SQL_SELECT_LIMIT=DEFAULT' at line 1

   报错信息2：

   >  FAILED: SemanticException Unable to fetch table article. java.lang.ArrayIndexOutOfBoundsException: 125

   ### 解决问题

   报错信息1解：

   > 是mysql 驱动 比 mysql数据库版本低导致的问题，在低版本数据库中可以执行sql命令（导致此问题是我使用了mysql-connector-java-5.1.9.jar）
   >
   > ```
   > mysql/> SET OPTION SQL_SELECT_LIMIT=DEFAULT
   > ```
   >
   > 所以在低版本驱动连接数据库执行sql前会执行这样一个命令，高版本数据库已经废弃了此命令的支持，只需要把驱动升级到此数据库版本支持的版本即可

   报错信息2解：

   > 是mysql 驱动 比 mysql数据库版本高导致的问题，具体什么原理我没有细究，只需要把驱动版本降到数据库版本支持的版本即可。
   >
   > （导致此问题是我更换了mysql-connector-java-6.0.2.jar，以为驱动文件会向下兼容mysql版本是我太天真了）

   > 最后把mysql 数据库驱动版本更换为了mysql-connector-java-5.1.49-bin.jar, 把这个问题修改了发下在hive中执行show tables;、 show databases ; 这类命令都快了许多。

3. ## 使用load data [local] inpath "<dataPath>" [overwrite] into table <bucketTableName>; 导入数据到==分桶表==中时报错

   

   ### 错误信息：

   触发点：

   ```
   hive/> load data [local] inpath "<dataPath>" [overwrite] into table <bucketTableName>;
   ```

   报错信息：

   > hive/> FAILED: SemanticException Please load into an intermediate table and use 'insert... select' to allow Hive to enforce bucketing. Load into bucketed tables are disabled for safety reasons. If you know what you are doing, please sethive.strict.checks.bucketing to false and that hive.mapred.mode is not set to 'strict' to proceed. Note that if you may get errors or incorrect results if you make a mistake while using some of the unsafe features.

   ### 解决问题

   ```bash
   # 默认分桶检查是严格模式，设置为非严格模式
   # 解1
   # 根据上面报错信息提示需要创建一张中间表，把用loda data inpath语句把数据先导入到中间表，再使用insert [overwrite] table <bucketTableName> select <filed> from <tableName>; 导入到分桶表中；
   hive/> insert [overwrite] table <bucketTableName> select <filed> from <tableName>;
   # 解2
   hive/> set hive.strict.checks.bucketing = false; 
   ```

4. ## 执行设置开启分桶模式报错

   ### 错误信息：

   触发点：

   ```bash
   hive/> set hive.enforce.bucketing = true;
   ```

   报错信息：

   > Query returned non-zero code: 1, cause: hive configuration hive.enfore.bucketing does not exists.
   >
   > 此配置已经不再使用了，会导致hql 语句未执行

   ### 解决问题

   > 默认分桶模式是开启的无需再次开启

   

   

   ### 错误信息：

   触发点：

   报错信息：

   ### 解决问题

