# 	dubbo 开发中需要用到的直连提供者和只订阅

[toc]

> 为方便开发测试，经常会在线下共用一个所有服务可用的注册中心，这时，如果一个正在开发中的服务提供者注册，可能会影响消费者不能正常运行。
>
> 可以让服务提供者开发方，只订阅服务(开发的服务可能依赖其它服务)，而不注册正在开发的服务，通过直连测试正在开发的服务。

. 引用官网的一张图：

![image-20210526205413182](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/dubbo%20%E5%BC%80%E5%8F%91%E4%B8%AD%E9%9C%80%E8%A6%81%E7%94%A8%E5%88%B0%E7%9A%84%E7%9B%B4%E8%BF%9E%E6%8F%90%E4%BE%9B%E8%80%85%E5%92%8C%E5%8F%AA%E8%AE%A2%E9%98%85.assets/2021/05/26/20-54-37-e1567cae82eaffefbb49f9f90d80175c-image-20210526205413182-36aa2e.png)

## 只订阅

> 只订阅不注册

对于开发中的提供者使用禁用注册配置，有以下几种：

```xml
<dubbo:registry address="10.20.153.10:9090" register="false" />
```

```xml
 <dubbo:registry address="10.20.153.10:9090?register=false" />
```

## 直连提供者

> 在开发及测试环境下，经常需要绕过注册中心，只测试指定服务提供者，这时候可能需要点对点直连，点对点直连方式，将以服务接口为单位，忽略注册中心的提供者列表，A 接口配置点对点，不影响 B 接口从注册中心获取列表。
>
> 针对上面只订阅的服务提供者我们就可以使用直连提供者方式连接调用服务提供者的服务测试

直连提供者提供的服务配置有以下几种：

1. 通过 XML 配置

>  如果是线上需求需要点对点，可在 `` 中配置 url 指向提供者，将绕过注册中心，多个地址用分号隔开，配置如下：

```xml
<dubbo:reference id="xxxService" interface="com.alibaba.xxx.XxxService" url="dubbo://localhost:20890" />
```

2. 通过 -D 参数指定

> 在 JVM 启动参数中加入-D参数映射服务地址，如：

```sh
java -Dcom.alibaba.xxx.XxxService=dubbo://localhost:20890
```

> key 为服务名，value 为服务提供者 url，此配置优先级最高，`1.0.15` 及以上版本支持

3. 通过文件映射(**开发中推荐**,可以统一管理，并且可以忽略版本控制，以免配置在xml中大意提交到代码库影响线上服务)

> 如果服务比较多，也可以用文件映射，用 `-Ddubbo.resolve.file` 指定映射文件路径，此配置优先级高于 `` 中的配置 [^3]，如：

```sh
java -Ddubbo.resolve.file=xxx.properties
```

> 然后在映射文件 `xxx.properties` 中加入配置，其中 key 为服务名，value 为服务提供者 URL：

```fallback
com.alibaba.xxx.XxxService=dubbo://localhost:20890
```

> `1.0.15` 及以上版本支持，`2.0` 以上版本自动加载 ${user.home}/dubbo-resolve.properties文件，不需要配置

