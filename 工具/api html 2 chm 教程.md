# 生成chm 接口文档：

**前提概述**：
> 此方法为组合方式，我也想简单直接用一个工具搞定就行了，比如javadoc2chm、jd2chm、javadoc2help。这些工具我都试过，但是总不合人意，javadoc2chm 生成得中文乱码、jd2chm 生成得不带索引(听说有个jd2chm version 0.34 是某个大神改过的没有找到下载路径)、javadoc2help 需要配置HTML help workshop路径，但是官方文档又没说是配到目录还是配到某个文件（配到目录试了不管用，配到执行文件hhw.exe 也是不管用）。索性就把javadoc2help 和HTML help workshop 联合使用了，就是麻烦点效果比上面单独拿出来么个都强太多了。当然如果你不嫌麻烦可以只是用HTML help workshop，也是可以得。
> 如果哪个大神找到了使用一个工具就可以简单的生成CHM文档的请告诉我，感激涕零！

**废话少说，上来就干：**​	

> 我的源文档是[hutool](https://apidoc.gitee.com/loolly/hutool/)

> 前提是你要安装了mavn 

  1. 从github[下载]()hutool源码。

  2. 如果项目是多模块，`mvn javadoc:javadoc `命令只会把生成得java doc 放到各自得target 下，不符合要求。要把各个模块生成得接口文档要放到统一的位置。

     可以在父模块下使用`mvn javadoc:aggregate` 执行完成在父模块得target 下就可以找到你要得文档了。

  3. 文档有了，进入关键环节：下载javadoc2help  
        	执行 `java -jar lib/Javadoc2Help.jar -chm -src [文档所在目录] -dest [copy/生成文件位置]`
        	你会发现 生成文件位置 会有三个文件：`*.hhc 、*.hhk、*.hhp`

       ​    `hhk` 文件是索引文件，

       ​	`hhc` 是HTML help workshop  的项目文件，可以用HTML help workshop 打开。

       ​	`hhp`是目录文件。

       这三个文件需要修改的是`hhk` 文件。所以打开`allclasses-frame.html` 修改格式如`*.hhk` 的格式。
```xml
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<HTML>
	<HEAD>
		<meta name="GENERATOR" content="Microsoft&reg; HTML Help Workshop 4.1">
			<!-- Sitemap 1.0 -->
		</HEAD>
		<BODY>
			<UL>
				<LI>
					<OBJECT type="text/sitemap">
						<param name="Name" value="index">
							<param name="Name" value="index">
								<param name="Local" value="Desktop\hutool-5-master\target\site\apidocs\allclasses-noframe.html">
								</OBJECT>
							</UL>
						</BODY>
					</HTML>
					<param name="Name" value="index">
						<!--这个标签的value 值就是索引中的搜索关键字，也是显示名及java的类名。-->
```
**以下贴出修改后的部分：**

```xml
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<HTML>
	<HEAD>
		<meta name="GENERATOR" content="Microsoft&reg; HTML Help Workshop 4.1">
			<!-- Sitemap 1.0 -->
		</HEAD>
		<BODY>
			<ul>
				<li>
					<OBJECT type="text/sitemap">
						<param name="Local" value="cn/hutool/setting/AbsSetting.html">
							<param name="Name" value="AbsSetting">
							</OBJECT>
						</li>
						<li>
							<OBJECT type="text/sitemap">
								<param name="Local" value="cn/hutool/crypto/asymmetric/AbstractAsymmetricCrypto.html">
									<param name="Name" value="AbstractAsymmetricCrypto">
									</OBJECT>
								</li>
								<li>
									<OBJECT type="text/sitemap">
										<param name="Local" value="cn/hutool/cache/impl/AbstractCache.html">
											<param name="Name" value="AbstractCache">
											</OBJECT>
										</li>
										<li>
											<OBJECT type="text/sitemap">
												<param name="Local" value="cn/hutool/captcha/AbstractCaptcha.html">
													<param name="Name" value="AbstractCaptcha">
													</OBJECT>
												</li>
												<li>
													<OBJECT type="text/sitemap">
														<param name="Local" value="cn/hutool/core/convert/AbstractConverter.html">
															<param name="Name" value="AbstractConverter">
															</OBJECT>
														</li>
```

> 原来的表头换了，标签改了。使用正则很好改的。记得这个文件内容改好把文件后缀名改为hhk

4. 使用HTML help workshop 打开`*.hhc` 文件 ,点击索引标签打开一个已有的索引文件（就是刚我们说修改的那个文件）
5. 接下来点击`project` 下的`change project opetion` 修改Language 为中文，Font 的编码为GB2312 。
   最后save all file and compile 。等待。。。。。。。

6. 最后去指定的目录就会找到你等待已久的文件喽。



**补充：**

> 中间差个小细节：生成chm 文件后发现有中文乱码（虽然在HTML help workshop改过编码），原因是javadoc2help 在执行中copy html 文件中出现了问题，所以在执行完第2步，javadoc2help 那个命令后手动把html copy 到目标目录，完美解决中文乱码。


