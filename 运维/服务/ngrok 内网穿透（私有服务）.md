[toc]

# 准备事项
> 本着玩玩的态度，下面需要的服务器、域名、dns解析、证书能不花一分钱就节约咱兜里的一分钱，毕竟大家挣钱都不容易

## 搞个免费的有公网 ip 地址的服务器
> 网上搜了搜正好腾讯云搞活动，可以申请一个1核1G 的云虚拟服务器，虽然时限只有半个月，足矣！
> 不知道现在有没有活动，这里留个地址：[腾讯云](https://cloud.tencent.com/login) 
> 大家都是中国人都认识汉字自己注册账号和领取/购买服务器得嘞！
>下面刘几张截图以免找不到位置

1. 登录腾讯云领取/购买服务器后硬是没找到我的服务器实例在哪里，主要是没有选对服务器实例所在城市，看下图带数字的城市。下图标识以下：系统是CentOS 7 的。

![image-20210303165257147](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-53-35-59cd0d76b99bcac6f53bfb1daaf72775-image-20210303165257147-5cbc1c.png)


## 搞个免费的域名
> 之前有用过花生壳域名内网穿透时免费送的一个域名，登录花生壳发现需要实名实名不了不能使用了。
> 网上搜了搜，发现了更好的 [freenom](https://my.freenom.com/clientarea.php) 里面有很多免费的和实惠的域名可以使用。
进入网址找了好多地方硬是没找到注册入口，非人性啊！下面贴图标识以下：

![image-20210303170700512](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-53-55-f5fc6ed68976d6c02280f2840ab99b8b-image-20210303170700512-5dcc3a.png)

向下滑到底部：

![image-20210303170756419](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-54-14-69e104b25133ab971507d40bd7f7dae2-image-20210303170756419-8d5c7b.png)


> ==tip:== 
>
> 1. freenom免费域名最多一次申请一年，一年后要用再续。
> 2. freenom免费域名访问流量太大会被回收。
> 2. freenom免费域名长时间无访问流量会被回收。

[还不清楚怎么获取免费域名的请移步](https://coderschool.cn/2197.html)



## 搞个免费的DNS解析
正好发现腾讯云有免费的DNS解析可以薅羊毛：

![image-20210304091715697](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-56-24-1342f26312015d468f5f2e4f68d6fb6f-image-20210304091715697-841a24.png)

点进添加的域名后可以添加记录：

![image-20210304091955196](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-56-34-21fd4f72536d6937a23ef3733a080764-image-20210304091955196-ab815d.png)

记录以下第一条和第二条中的记录值：我的是 litchi.dnspod.net 、cyclamen.dnspod.net 先后顺序不要搞错，接下来要用到。

回到我们申请域名的freenom网站：

![image-20210304103137965](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-56-48-1c5f0c4fd544d6c332b999f3e064d57a-image-20210304103137965-6401a8.png)![image-20210304103212703](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-57-40-5f0cdb1ac29e43983553ad736c85c7df-image-20210304103212703-564c5a.png)

![image-20210304103252336](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-57-47-665ece6227c9feb695bdcfc3d296f115-image-20210304103252336-ec6d3e.png)![image-20210304103332066](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-57-53-badbcbfe84f2b8b3179b074f8473d825-image-20210304103332066-6f20e6.png)

你以为到这里薅羊毛就结束了么？太天真了，我们还可以搞个ssl证书，有用没用先撸了再说：

![image-20210304092941606](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-58-22-0ec736a2f91e8f7fbd924c5b570b6851-image-20210304092941606-23c9ad.png)![image-20210304093239066](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-58-27-e179e4ae4326e91de7bc80ca4ab3f3a0-image-20210304093239066-7f7590.png)

（暗自高兴，却不知危机在慢慢靠近！）



# 进入正题

## 安装编译环境
> 这里所依赖的环境主要是golang 和 git ,因为ngrok 是go语言写的，go 又依赖git 下载开源包。废话不多说，
### golang 环境

1. 下载go 二进制文件包：[linux golang 下载地址](https://dl.google.com/go/go1.16.linux-amd64.tar.gz)
2. 上传到服务器，解压：`tar -zxvf go1.16.linux-amd64.tar.gz`
3. 配置golang环境变量：`vi ~/.bash_rc` 加上下面一段代码：
```
export GIT_HOME=$HOME/git-2.30.1 
GOROOT=$HOME/go
export GOROOT
GOPATH=$HOME/gopath
export GOPATH
PATH=$PATH:$HOME/bin:$GOROOT/bin:$GOPATH/bin:GIT_HOME/bin

```
4. 由于golang 是国外人员开发的语言，所以在使用golang 下载依赖包时特别慢，或者根本就不通。下面需要设置以下代理：
如果您使用的 Go 版本是 Go 1.13 及以上，我们推荐您使用下面的 Go 命令来进行配置：
```
go env -w GOPROXY="https://goproxy.io,direct"
```
但是如果您试用的 Go 版本小于 1.13, 可以按照下面的指引进行配置：：
Mac/Lingx:`export GOPROXY=https://goproxy.io,direct`
Windows:`go env -w GOPROXY="https://goproxy.io,direct"`
如果需要==长期生效==请配置到环境变量中：
Mac/Linux:

```
# 设置你的 bash 环境变量
echo "export GOPROXY=https://goproxy.io,direct" >> ~/.profile && source ~/.profile

# 如果你的终端是 zsh，使用以下命令
echo "export GOPROXY=https://goproxy.io,direct" >> ~/.zshrc && source ~/.zshrc
```
Windows:
> 1. 右键 我的电脑 -> 属性 -> 高级系统设置 -> 环境变量
2. 在 “[你的用户名]的用户变量” 中点击 ”新建“ 按钮
3. 在 “变量名” 输入框并新增 “GOPROXY”
4. 在对应的 “变量值” 输入框中新增 “https://goproxy.io,direct”
5. 最后点击 “确定” 按钮保存设置


可选设置:
```
# 还可以设置不走 proxy 的私有仓库或组，多个用逗号相隔（可选）
go env -w GOPRIVATE=*.corp.example.com,github.com/org_private
```
[这里有更详细的关于新版golang 的信息：包括Go module 功能](https://goproxy.io/zh/docs/introduction.html)

验证：`go version`

```
go version go1.16 linux/amd64
```

### git 环境：

针对于git 我之前也用过，不过这次配置lgit inux 环境 发现据然不像golang 这样下载个二进制包-解压-配置环境变量就能解决的，反正在这里也只是个工具而已没仔细研究，越简单越好，需要了解更多方式配置git 环境请另辟蹊径

CentOS:

安装：

`sudo yum install git-all `

配置：

```bash
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
```

验证：`git --version`

```
git version 1.8.3.1
```




## 证书
> 创建私有 CA ，然后用该 CA 给证书进行签名，这样不就不用花钱了么。上面薅的那个免费的证书等下再说.（坑难以平定，这里花费了不少时间，当时自签名ca证书最终没有解决，希望大神指教）
>
> 下面只是阐述以下我生成证书的经过（不得不赞叹短短的几行代码蕴含着深刻的道理）

```
#!/bin/bash
#私有 CA 签名：
export NGROK_DOMAIN="ngrok.cn"
export CA_DOMAIN="ca.test.website"
# 1.创建 CA 私钥
openssl genrsa -out rootCA.key 2048
# 2.生成 CA 的自签名证书
openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=${CA_DOMAIN}" -days 5000 -out rootCA.pem
## 3.生成需要颁发证书的私钥
openssl genrsa -out device.key 2048
#4.生成要颁发证书的证书签名请求，证书签名请求当中的 Common Name 必须区别于 CA 的证书里面的 Common Name
openssl req -new -key device.key -subj "/CN=${NGROK_DOMAIN}" -out device.csr
## 5.用 2 创建的 CA 证书给 4 生成的 签名请求 进行签名
openssl x509 -req -in device.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out device.crt -days 5000
```

> ==tip==: 这些都是后话
>
> export NGROK_DOMAIN="ngrok.cn"
> export CA_DOMAIN="ca.test.website"
>
> 有人说ca域名和ngrok 服务所在域名一定不要一样，不管一不一样我试了，但是最终都没成功：远程连接 客户端报 reconnection , 服务的日志显示： Failed to read message: remote error: bad certificate ；
>
> 把生成的rootCA.pem 放到客户端覆盖ngrokroot.crt
>
> device.crt、device.key 放到客户端分别覆盖snakeoil.crt、snakeoil.key
>
> 还有人说是因为在copy 证书时客户端位置assets/client/tls有两个证书，copy 却只覆盖了一个，我把两个证书（加上 device.crt覆盖snakeoilca.crt ）放到客户端仍然无济于事
>
> 最终感觉应该是我的证书生成时的问题，对证书熟悉的大神请指正，谢谢。



## 下载ngrok 源码
[官网源码](https://codeload.github.com/inconshreveable/ngrok/zip/1.7.1) 
有人说上面Failed to read message: remote error 的错误是源码导致的，推荐下面的地址（听说是改过的）
[fork modify](https://codeload.github.com/mamboer/ngrok/tar.gz/1.7.1) 说实话试过了不行。
解压`tar -zxvf ngrok-1.7.1.tar.gz`

## 替换源码中的无法找到的依赖包
> 由于ngrok停止维护很长时间，源码中使用的开源依赖包找不到，替换为其他。

打开src/ngrok/log/logger.go文件
将code.google.com/p/log4go 修改为：github.com/alecthomas/log4go
googlecode已经寿终了，我们将依赖的log4go替换成github的版本

## 编译服务端和客户端
等一下在编译之前异动要把咱们刚才生成的证书利用上啊，不然不是白费心血了么：
> ngrok通过bindata将ngrok源码目录下的assets目录（资源文件）打包到可执行文件(ngrokd和ngrok)中 去，assets/client/tls和assets/server/tls下分别存放着用于ngrok和ngrokd的默认证书文件，我们需要将它们替换成我们自己生成的：(因此这一步务必放在编译可执行文件之前)
> 
```
cd ngrok-1.7.1
mv -f rootCA.pem assets/client/tls/ngrokroot.crt
mv -f device.crt assets/server/tls/snakeoil.crt
mv -f device.key assets/server/tls/snakeoil.key
```
好了我们自己生成的证书利用上了（这坑是挖好了，就等着自己踩啦😂）
在编译之前还要说一下使用环境的问题，如果你不是编译系统和使用系统相同记得命令执行时加上下面内容：
在编译客户端的时候需要指明对应的操作系统和构架：

Linux 平台 32 位系统：`GOOS=linux GOARCH=386`
Linux 平台 64 位系统：`GOOS=linux GOARCH=amd64`
Windows 平台 32 位系统：`GOOS=windows GOARCH=386`
Windows 平台 64 位系统：`GOOS=windows GOARCH=amd64`
MAC 平台 32 位系统：`GOOS=darwin GOARCH=386`
MAC 平台 64 位系统：`GOOS=darwin GOARCH=amd64`
ARM 平台：`GOOS=linux GOARCH=arm`

编译:
>有没有release的区别是，包含release的编译结果会把assets目录下的内容包括进去，从而可以独立执行。如果你今后还要更换证书，建议编译不包含release的版本。。首先编译ngrok服务端（ngrokd），默认为Linux版本：

编译服务器端ngrokd：`GOOS=linux GOARCH=amd64 make release-server` 或者 `make release-server` 或者 `make server` 区别上面已经说了。
编译客户端ngrok：`make release-client` 或者 `make client` 区别上面已经说了。

## 配置和运行

### 服务端运行
调试运行：`./ngrokd -httpAddr=":8080" -httpsAddr=":443" --tunnelAddr=":4443" -log-level debug -domain="ngrok.cn"
后台运行：`nohup ./ngrokd -httpAddr=":8080" -httpsAddr=":8081" --tunnelAddr=":4443" -log-level debug -domain="ngrok.cn &`
说明：-domain  参数一定要加，因为默认值是ngrok.com

### 客户端配置和运行
http 、https 端口监控
调试运行：`./ngrok -subdomain demo -config=ngrok.cfg 2080`
后台运行：`nohup ./ngrok -log=stdout -subdomain demo -config=ngrok.cfg 2080 > ngrok.log 2>&1 &`

此处把-log参数指定为stdout，只要加入该项log预设，就不会显示terminal状态图像，[取而代之]显示文本形式的状态日志，从而可以使用nohup和&组合，少了该项是不可以后台运行的。

tcp 协议端口监控（eg:ssh 连接）
调试运行：`./ngrok -log=stdout  -proto tcp 22`
后台运行：`nohup ./ngrok -log=stdout  -proto tcp 22 > ngrok.log 2>&1 &`
不过建立 tcp 通道 每次服务启动隧道端口都会改变，可以使用下面命令去服务端日志中查找：
`tail -n 200 nohup.out|grep 'Url' `
连接隧道：`ssh user@ngrok.cn tunnel_port`
配置文件可以不指定默认是当前用户目录下的 .ngrok 文件
简配置文件的内容：

```
# ngrokd 服务部署的地址
server_addr: "ngrok.cn:4443" 
# 不校验证书
trust_host_root_certs: false
```
详细配置文件：启动方式可以是`ngrok start` 启动所有 or `ngrok start http https openvpn` 指定启动

```yam
server_addr: "ngrok.cn:4443"   //注意域名一定要和服务器端一致
trust_host_root_certs: false
tunnels:
  http:    //名字自己定义
    subdomain: "ngrok"     //映射的域名前缀，根据自己喜好设置，注意需把域名解析到服务器上
    proto:
      http: 80
      
  https:
    subdomain: "ssl"
    proto:
      https: 443
      
  openvpn:
    remote_port: 5555   //映射的端口
    proto:
      tcp: 1194
    
  ssh:
    remote_port: 2222
    proto:
      tcp: 22
```


# 总结
1. 首先要说的就是这个证书的问题，上面一只没有给出解决办法，看客们肯定在想，这个ngrok 服务是不是夭折了。下面我就把我最终的解决方法写一下：
   上面有提到咱们薅了一个免费的ssl 证书对吧，解压后：

![image-20210304121516799](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-58-42-ac4a77cb884b1e6f95f8ea84cbccba39-image-20210304121516799-e7ce05.png)![image-20210304121859340](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-58-47-83763b718ccad230db78cf73a019ca1d-image-20210304121859340-613891.png)


在Apache 下有三个文件，这就是我们要的：

其中1_root_bundle.crt 是CA 根证书要放到客户端的。

2_xxx.crt 是ngrok 签名的证书、3_xxx.key 是ngrok 私钥妥善保管  这两个是要放到服务端得；

```
mv -f 1_root_bundle.crt ngrok-1.7.1/assets/client/tls/ngrokroot.crt
mv -f 2_xxx.crt ngrok-1.7.1/assets/server/tls/snakeoil.crt
mv -f 3_xxx.key ngrok-1.7.1/assets/server/tls/snakeoil.key
```

这样再编译打包我们的  Failed to read message: remote error: bad 问题就解决了（还是要研究以下自签名证书）。



2. 编译时出现如下问题解决：

```
GOOS="" GOARCH="" go get github.com/jteeuwen/go-bindata/go-bindata
bin/go-bindata -nomemcopy -pkg=assets -tags=release \
        -debug=false \
        -o=src/ngrok/client/assets/assets_release.go \
        assets/client/…
make: bin/go-bindata: Command not found
make: *** [client-assets] Error 127
```
go-bindata被安装到了$GOBIN下了，go编译器找不到了。修正方法是将$GOBIN/go-bindata拷贝到当前ngrok/bin下。
$ cp /home/ubuntu/.bin/go14/bin/go-bindata ./bin



3. go 新版本开启module 功能 导致的问题

   > 在编译release-server时，报错go get ngrok/…: malformed module path “ngrok”: missing dot in first path element
   > make: *** [deps] 错误 1，从报错内容来看，是把ngrok文件夹当成了远程包去下载了，但ngrok是src目录下的本地代码包。于是我查看了一下makefile文件，找到编译报错那个指令

   

   ![image-20210304144447296](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/ngrok%20%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F%EF%BC%88%E7%A7%81%E6%9C%89%E6%9C%8D%E5%8A%A1%EF%BC%89.assets/2021/05/18/14-58-53-788f287a232484ad76abce537003f708-image-20210304144447296-137e68.png)

   

开始以为是ngrok的路径不正确导致的，但当我将src/ngrok软链到GOPATH目录下，还是不起作用，于是我重新在网上查询了这个错误的原因，大部分的出现这个报错原因是从GOROOT和GOPATH下都没有找到这个代码包，所以默认去网上下载 。这也能解释的通为什么去执行go get命令了。

既然不是代码包路径问题，而且会自动go get, 让我联想到了是不是go mod的问题，于是我尝试把GO111MODULE参数设置为off,果然有效，可以正常编译了。

```
go -w env GO111MODULE=off
```

