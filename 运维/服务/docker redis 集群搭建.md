# docker redis 集群搭建

> 本教程使用官方redis 镜像+docker-compose 完成整个redis集群的搭建，之所以使用docker-compose 是因为只需要写好配置文件部署执行方便

> [项目位置](https://github.com/YasinHenry/DockerRedisCluster.git)

[toc]



## 省略步骤

> 请参考docker官方文档

1. docker 安装
2. docker compose 安装



## 正式开始

> 说白了都是配置文件
>
> 为了下面不迷路，先把配置的目录结构贴上 ==不要急着建目录结构，大多目录后面我有脚本直接生成==，下面高亮的为目录：
>
> 1. <img src = "https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/docker%20redis%20%E9%9B%86%E7%BE%A4%E6%90%AD%E5%BB%BA.assets/2021/05/18/16-03-38-1e5d58b159de89339a974bc893f22aa2-image-20210518160104383-7fb608.png" align="left">
>
> ​	redis-cluster.tmpl
>
> ​	docker-compose.yml



> 好了，以上就是这次集群的目录结构，解释一下：
>
> 1. redis-cluster 目录不用说了是我们工作空间
>
> 2. data 目录是所有redis 节点配置文件所以在目录
>
> 3. data 目录下的700x 目录是针对单个节点的配置所在目录，至于700x 是redis 服务的端口。端口目录下的 conf 目录下存了当前redis 节点的真实配置文件。至于端口下的data目录是我docker volume 映射的目录，这个当然你随便。
>
> 4. redis-cluster.tmpl 为redis 节点的模板文件
>
> 5. 至于docker-compose.yml 文件就不必说了这个是docker-compose 启动服务的配置文件



1. ### 首先新建了一个工作目录 ***redis-cluster*** 

> 由于我实现redis 集群用了6台redis 节点 ，每台都要写配置文件总不方便
>
> 所以
>
> 首先为redis 配置文件文件创建了一个模板 我命名为  *redis-cluster.tmpl*  以下内容：

```conf
##节点端口
port ${PORT}                                       
##开启集群模式
protected-mode no                                  
##cluster集群模式
cluster-enabled yes                                
##集群配置名
cluster-config-file nodes.conf          
##超时时间           
cluster-node-timeout 5000   
##实际为各节点网卡分配ip                      
cluster-announce-ip 172.19.0.${IPEND}           
##节点映射端口       
cluster-announce-port ${PORT}           
##节点总线端口           
cluster-announce-bus-port 1${PORT}  
##持久化模式               
appendonly yes    
```

> 这里有个配置需要解释一下：cluster-announce-ip  这个参数的值 172.19.0.${IPEND}  不是我随便写的，这个是取自docker service 使用的network 的网关地址。如果你无法确定 请使用``docker inspect <network-name>`   查看。 



2. ### 生成配置

   > 使用上面模板加上如下脚本来生成我们需要的redis 各个节点的目录和配置，你可以把下面脚本写进xx.sh 文件放到redis-cluster 工作空间执行

   ```bash
   #!/bin/bash
   for port in `seq 7000 7005`; do 
     mkdir -p ./data/${port}/conf && PORT=${port} IPEND=17${port:0-1:1} envsubst < ./redis-cluster.tmpl > ./data/${port}/conf/redis.conf && mkdir -p ./data/${port}/data; 
   done
   ```

   到此开始我们展示的目录及除了 ==docker-compose.yml== 文件都已经全了

   

   3. ### 写 docker-compose.yml 文件

      ```yaml
      version: '3'
      services:
        redis-7000: 
          image: redis:latest
          container_name: redis-7000
          volumes: 
            - ./data/7000/conf/redis.conf:/usr/local/etc/redis/redis.conf
            - ./data/7000/data:/data
            - ./data/7000/logs:/usr/local/redis/logs
          command: redis-server /usr/local/etc/redis/redis.conf --requirepass yasin
          ports: 
            - "7000:7000"
            - "17000:17000"
          restart: always
          networks: 
            redis-net:
              ipv4_address: 172.19.0.170
          logging:  
            driver: "json-file"
            options: 
              max-size: "1m"
      
      
        redis-7001: 
          image: redis:latest
          container_name: redis-7001
          volumes: 
            - ./data/7001/conf/redis.conf:/usr/local/etc/redis/redis.conf
            - ./data/7001/data:/data
            - ./data/7001/logs:/usr/local/redis/logs
          command: redis-server /usr/local/etc/redis/redis.conf --requirepass yasin
          ports: 
            - "7001:7001"
            - "17001:17001"
          restart: always
          networks:  
            redis-net:
              ipv4_address: 172.19.0.171
          logging: 
            driver: "json-file"
            options: 
              max-size: "1m"   
      
      
        redis-7002: 
          image: redis:latest
          container_name: redis-7002
          volumes: 
            - ./data/7002/conf/redis.conf:/usr/local/etc/redis/redis.conf
            - ./data/7002/data:/data
            - ./data/7002/logs:/usr/local/redis/logs
          command: redis-server /usr/local/etc/redis/redis.conf --requirepass yasin
          ports: 
            - "7002:7002"
            - "17002:17002"
          restart: always
          networks: 
            redis-net:
              ipv4_address: 172.19.0.172
          logging: 
            driver: "json-file"
            options: 
              max-size: "1m" 
      
      
        redis-7003: 
          image: redis:latest
          container_name: redis-7003
          volumes: 
            - ./data/7003/conf/redis.conf:/usr/local/etc/redis/redis.conf
            - ./data/7003/data:/data
            - ./data/7003/logs:/usr/local/redis/logs
          command: redis-server /usr/local/etc/redis/redis.conf --requirepass yasin
          ports: 
            - "7003:7003"
            - "17003:17003"
          restart: always
          networks: 
            redis-net:
              ipv4_address: 172.19.0.173
          logging: 
            driver: "json-file"
            options: 
              max-size: "1m" 
      
      
        redis-7004: 
          image: redis:latest
          container_name: redis-7004
          volumes: 
            - ./data/7004/conf/redis.conf:/usr/local/etc/redis/redis.conf
            - ./data/7004/data:/data
            - ./data/7004/logs:/usr/local/redis/logs
          command: redis-server /usr/local/etc/redis/redis.conf --requirepass yasin
          ports: 
            - "7004:7004"
            - "17004:17004"
          restart: always
          networks: 
            redis-net:
              ipv4_address: 172.19.0.174
          logging: 
            driver: "json-file"
            options: 
              max-size: "1m" 
      
      
        redis-7005: 
          image: redis:latest
          container_name: redis-7005
          volumes: 
            - ./data/7005/conf/redis.conf:/usr/local/etc/redis/redis.conf
            - ./data/7005/data:/data
            - ./data/7005/logs:/usr/local/redis/logs
          command: redis-server /usr/local/etc/redis/redis.conf --requirepass yasin
          ports: 
            - "7005:7005"
            - "17005:17005"
          restart: always
          networks: 
            redis-net:
              ipv4_address: 172.19.0.175
          logging: 
            driver: "json-file"
            options: 
              max-size: "1m" 
           
      
      networks:
       redis-net:
        external: true
        
      ```

      

>  --requirepass yasin  这个是我为每个redis node 设置了 密码 yasin  ,不需要可以去掉。
>
> ipv4_address  这里的ip地址一定要与redis.conf 中的地址一致.
>
> external: true  这里external 值为true 是我事前创建了``docker network create --driver bridge redis-net ``   如果是Windows 机器可能会失败 可以再尝试`docker network create --driver nat redis-net`  

4. ### 创建并启动容器

   好了，配置文件准备就绪就让我们看一下效果吧，在我们的工作空间下执行以下命令来创建我们的6台 docker redis 服务：

   ```
   docker-compose up
   ```

5. ### 组建集群

> 服务起来之后剩下的事情就是让6台redis 感知到彼此,进入到其中一台容器

```bash
docker exec -it redis-7000 bash
```

(==容器内执行==)
```bash
for N in `seq 0 5` ; do 
	redis-cli -h 172.19.0.170 -p 7000 -a yasin cluster meet 172.19.0.17${N} 700${N};
done
```

> ==teps:== 我在执行到这一步的时候吃了大亏，按理说只要一台节点去感知了其他节点其他节点都会自动相互感知，但是当时执行到这一步时，没有执行上面命令的节点死活感知不到其他节点。问题在于reds 的配置文件里我把 ==cluster-announce-ip 172.19.0.${IPEND}== 写死为 ==cluster-announce-ip 0.0.0.0==  导致其他节点一直在执行 ：
>
> cluster meet 0.0.0.0 7000 
>
> cluster meet 0.0.0.0 7001
>
> cluster meet 0.0.0.0 7002
>
> cluster meet 0.0.0.0 7003
>
> cluster meet 0.0.0.0 7004
>
> cluster meet 0.0.0.0 7005
>
> 其中一台节点怎么可能同时用于700x的所有redis 端口呢！

检查一下所有节点是否都感知到了彼此：在每台节点执行如下命令 打印出6台节点的信息记录下每行的id （==节点标识==），很重要下面要用 

(==容器内执行==)

```bash
redis-cli -h 172.19.0.170 -p 7000 -a yasin cluster nodes
```

到此redis 集群搭建完成



6. ### 分配槽点

> 6 个节点，我们选出端口为7000、7001、7002 三台为master 节点 ，并且为他们分配槽点
>
> (==容器内执行==)

```bash
redis-cli -h 172.19.0.170 -p 7000 -a yasin  CLUSTER ADDSLOTS {0,5461}
redis-cli -h 172.19.0.171 -p 7001 -a yasin  CLUSTER ADDSLOTS {5462,10922}
redis-cli -h 172.19.0.171 -p 7001 -a yasin  CLUSTER ADDSLOTS {10923,16383}
```



7. ### 分配slave

(==容器内执行==) 这里就用到了上面记录的 节点标识

```bash
# 此命令是在 从redis节点内执行 关联到 主redis 的节点标识
# 主 redis-7000 从 redis-7003
/usr/local/bin/redis-cli -h 172.19.0.173 -p 7003 -a yasin CLUSTER REPLICATE 5631cd7205b964c0c848ddc7292835fa8a4df57c
# 主 redis-7001 从 redis-7004
/usr/local/bin/redis-cli -h 172.19.0.174 -p 7004 -a yasin CLUSTER REPLICATE d0423573bfe628fb03cee2feead667ef5679c17d
# 主 redis-7002 从 redis-7005
/usr/local/bin/redis-cli -h 172.19.0.175 -p 7005 -a yasin CLUSTER REPLICATE 8563d43bf400b6435a921f4783420cca02fa2d5a
```



8. ### 集群密码

   如果需要可以为集群设置密码(==容器内执行==  密码yasin

```bash
for n in `seq 0 5` ; do 
	# 为每个节点设相同密码
	redis-cli -h 172.19.0.17${n} -p 700${n} -a yasin config set requirepass yasin;
	# 为slave节点设置主节点的密码，可能用于同步主节点数据验证使用(我这里为所有节点都设置了)
	redis-cli -h 172.19.0.17${n} -p 700${n} -a yasin config set masterauth yasin;
done
```



9. ### 验证、结束

到目前redis cluster 搭建结束，试一下集群连接 注意命令中的 `-c` 是用于连接集群的。

```bash
redis-cli -h -c 172.19.0.170 -p 7000 -a yasin set name 张三
```

```bash
for n in `seq 0 5` ; do 
	redis-cli -h -c 172.19.0.17${n} -p 700${n} -a yasin get name 张三
done
```



