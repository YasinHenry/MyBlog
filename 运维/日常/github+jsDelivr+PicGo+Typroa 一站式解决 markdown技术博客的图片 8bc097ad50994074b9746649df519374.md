# github+jsDelivr+PicGo+Typroa 一站式解决 markdown技术博客的图片云存储

# 什么是图床？

简单来讲，图床就是一个在网上存储图片的地方（其返回给你一个 `URL` 进行获取图片），目的是为

了节省服务器空间，加快图片打开速度。

# JsDelivr又是什么？

从他的官网可知，他是开源CDN提供商（免费，快速且可靠）,并且 `works in China` (也就是不会出现墙的问题)，支持给Github、WordPress、NPM免费提供CDN加速

这么一看，这不是正合适我们的需求吗，免费、快速并且稳定的`CDN`加速服务

所以，我们就是用他来配置我们图床的加速访问

> 使用方法：https://cdn.JsDelivr.net/gh/你的用户名/你的仓库名@发布的版本号/文件路径，版本号不是必需的，是为了区分新旧资源，如果不使用版本号，将会直接引用最新资源。

# 搭建

其实从上面就知道，我们可以直接通过 `JsDelivr` 访问我们自己 `Github` 仓库的资源了，那么我们能不能通过一些工具，来提高我们的生产力呢？答案是，肯定有的，接下来我们就一步一步的提高我们的生产力

## 创建新项目

登录/注册Github，新建一个仓库，填写好仓库名，仓库描述，并且一定的是公开项目，不能是私有的

![https://cdn.JsDelivr.net/gh/GATING/blog_imgs@master/2020-01-12/figureBed01.jpg](https://cdn.JsDelivr.net/gh/GATING/blog_imgs@master/2020-01-12/figureBed01.jpg)

## 生成Token

先点击头像的下拉菜单，并选择 `Settings`

![https://cdn.JsDelivr.net/gh/GATING/blog_imgs@master/2020-01-12/figureBed02.jpg](https://cdn.JsDelivr.net/gh/GATING/blog_imgs@master/2020-01-12/figureBed02.jpg)

选择 `Developer settings`

![https://cdn.JsDelivr.net/gh/GATING/blog_imgs@master/2020-01-12/figureBed03.jpg](https://cdn.JsDelivr.net/gh/GATING/blog_imgs@master/2020-01-12/figureBed03.jpg)

选择 `Personal access tokens`

![https://cdn.JsDelivr.net/gh/GATING/blog_imgs@master/2020-01-12/figureBed04.jpg](https://cdn.JsDelivr.net/gh/GATING/blog_imgs@master/2020-01-12/figureBed04.jpg)

选择 `Generate new token`，并填写好 `Note`，勾上 `repo`，最底下点击 `Generate new token` 生成所需要的token

![https://cdn.JsDelivr.net/gh/GATING/blog_imgs@master/2020-01-12/figureBed05.jpg](https://cdn.JsDelivr.net/gh/GATING/blog_imgs@master/2020-01-12/figureBed05.jpg)

这个token只会显示一次，自己先保存下来 （如果忘记了，重复上面一步，生成新的token）

![https://cdn.JsDelivr.net/gh/GATING/blog_imgs@master/2020-01-12/figureBed06.jpg](https://cdn.JsDelivr.net/gh/GATING/blog_imgs@master/2020-01-12/figureBed06.jpg)

## 使用PicGo上传图片

读到到了这里，你会发现我们只是创建了一个Github仓库，压根没有提高什么生产力= =。

骚年，别着急，接下来我们使用 [PicGo](https://github.com/Molunerfinn/picgo/releases) 这个工具来配置我们的 `Github` 图床啦

打开软件，下载安装`GitHubPlus`，配置上我们刚创建的仓库名、分支和Token，并设置图片在仓库的存储路径，以及自定义url

![Untitled](https://cdn.JsDelivr.net/gh/YasinHenry/MyBlog/imgs/2021/05/17/Untitled.png)

自定义域名则配置成 `https://cdn.JsDelivr.net/gh/你的用户名/你的仓库名/` ，这里就方便你在相册中复制你图床的链接

> ps: 上传如果需要压缩的话，推荐使用 TinyPNG 压缩之后，在上传哦

## PicGo整合Typora实现图片自动上传

typroa 设置 

[https://support.typora.io/Upload-Image/#validate-image-uploader](https://support.typora.io/Upload-Image/#validate-image-uploader)

typora官方文档

![Untitled 1](github+jsDelivr+PicGo+Typroa%20%E4%B8%80%E7%AB%99%E5%BC%8F%E8%A7%A3%E5%86%B3%20markdown%E6%8A%80%E6%9C%AF%E5%8D%9A%E5%AE%A2%E7%9A%84%E5%9B%BE%E7%89%87%208bc097ad50994074b9746649df519374.assets/Untitled%201-1621259532172.png)