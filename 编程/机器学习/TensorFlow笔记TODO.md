先说一下准确的安装顺序（环境是linux）：
1、如果你用anaconda 管理python环境，安装：
	(1) 官网下载anaconda 安装脚本：
		此处附上地址：https://www.continuum.io/downloads#linux
		提示：根据你的操作系统是32 bit还是64 bit 和 python是3.x 还是2.x 自行选择下载anaconda的版本.
	(2) 安装anaconda：
		$ bash Anaconda3-4.4.0-Linux-x86.sh  
		提示：根据anaconda脚本的名字自行替换。
	(3) 由于anaconda 库在美国，下载python安装包比较慢，幸好清华大学提供国内的包源，自然是设置国内anaconda的库地址啦：
		# 添加Anaconda的TUNA镜像
		conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
		# TUNA的help中镜像地址加有引号，需要去掉
		
		# 设置搜索时显示通道地址
		conda config --set show_channel_urls yes
	OK，anaconda 算是安装好了，还附带了给你安装了一个默认的python，环境名字是root。一下命令可以看到下载所拥有的python环境：
		conda-env list
2、	编译Python，并替换anaconda root环境的python
	(1)编译Python
		# anaconda 中root环境的python 版本是 3.6.1，所以去Python官网下载对应的python版本 Python3.6.1 的源码，并进入解压目录：
		$ tar -zxvf Python36.gzip && cd Python36 && ./configure --cache-file=/home/yasin/cache/ --prefix=/home/yasin/Python3.6.1/ --datadir=/home/yasin/software/ && make && make install 
	(2)替换：
		# 把anaconda 中root环境的python 用你自己编译的python执行文件替换掉。
			$ cp anaconda3/bin/python3.5 
			$ cp -f ~/Python3.5.2/bin/python3.5 ~/Python3.5.2/bin/python3.5m ~/Python3.5.2/bin/python3.5-config  ~/anaconda3/bin/
OK,你的python告一段落。

3、 在编译TensorFlow 是需要Google的一个编译工具bazel，如果没有适合你的二进制文件，那么你就要自己编译安装啦。
	(1) 下载bazel 0.4.0 和 >= 0.4.3 的两个版本。
		github 地址 https://github.com/bazelbuild/bazel
	(2) 解压 bazel-0.4.0,并安装：
		set -x && unzip bazel-0.4.0.zip && cd bazel-0.4.0 && bash ./compile.sh
		# 以上命令完成之后在当前目录的output/ 目录下就有了编译好的bazel脚本。
		mkdir ~/bin/ && cp ~/bazel-0.4.0/output/bazel ~/bin/ && tee -a ~/.bashrc <<-EOF \
			export PATH=$PATH:~/bin \
			EOF
		# OK，现在把bazel copy 到了~/bin/ 目录下并设置了环境变量中
		$ source ~/.bashrc 
		# 使之生效。
	(3) 编译TensorFlow-1.0.0 依赖bazel的最低版本是0.4.3，所以刚才安装的0.4.0只是个垫脚石，是为编译bazel-0.4.3 而准备的。
		 # 解压 bazel-0.4.3 并编译bazel-0.4.3
		 $ set -x && unzip bazel-0.4.3 && cd bazel-0.4.3 && bazel build //scripts:bazel-complete 
		 $ mv bazel-bin/scripts/bazel-complete.bash ~/bin/
OK bazel 也算是告一段落啦

4、TensorFlow 编译：
	1、配置：
		下载、解压、进入到目录下就不说啦，这些简单的命令应该都会吧~
		# 配置：
		$ ./configure
		根据提示，选择你是否安装，如果没有特殊需求，直接按默认来就行，遇到提问就回车。
	2、编译：
		$ bazel build --copt=march=native -c opt //tensorflow/tools/pip_package:build_pip_package
		# 3000多个任务，需要等一段时间喽
	3、生成whl文件，用于python安装：
		bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
		.... 等待 。。。
	4、 在/tmp/tensorflow_pkg/ 目录下就有你要的tensorflow 的 whl文件了
	5、 安装：
		$ pip install tensorflow-1.0.0rc0-cp35-cp35m-linux_xi386.whl
5、 运行试试:
	$ python -c "import tensorflow"
	OH，my god!god!god! 寂然有个错！......
	ERROR : " ImportError: cannot import name 'pywrap_tensorflow' "
	这是什么鬼，难道我编译错了不成！
	在网上搜了一下，原来需要退出编译目录(你解压文件的目录)tensorflow-1.0.0rc.
	OK，$ cd ~
	再试一下：python -c "import tensorflow"
	OH，fuck!fuck!fuck!fuck!fuck!fuck!......
	ERROR : " F tensorflow/core/platform/cpu_feature_guard.cc:35] The TensorFlow library was compiled to use SSE instructions, but these aren't available on your machine.
Aborted (core dumped) "
	扔了一堆洋文，python溜之大吉啦！fuck you mather Python!
	这段话大体意思是，我用SSE编译了tensorflow ,但是我的机器不支持！
	解决方法：
		编译用$ bazel build -c opt //tensorflow/tools/pip_package:build_pip_package 替换 $ bazel build --copt=march=native -c opt //tensorflow/tools/pip_package:build_pip_package


趟过的坑：

1、用anaconda 安装 python 环境埋下的坑：
	1、anaconda 下载的是最新版本的，最新版本默认的环境即anaconda root 环境是python3.6,而anaconda root 环境的python是编译好的。
	   报错：gcc=4.9、g++=4.9("/lib/libstdc++.so.6:version 'CXXABI 1.3.8' not found"
	   错误出现时：$ python -c "import tensorflow"
	   分析原因：1、tensorflow-rc1.0.0 运行时环境需要 gcc,g++ version >= 4.9 
				 2、anaconda 默认安装的 python3.6 编译时的gcc ，g++ 版本是 4.4.7（进入python 交互终端会看到） <这是也是系统gcc,g++的最低版本才可以运行的python> 
		解决目标：1、还用ananconda 管理python环境
				  2、支持tensorflow 的python 环境用于anaconda 默认的
		解决以上两个问题网络搜索得到的启示：
				1、把anaconda root python环境升降版本：
					(1) 首先确定你的conda是最新版本：
						$ conda update conda
					(2)升/降 pythoon的版本：
						$ conda install python=3.5
					警告：当时用pip安装的包自然也要从新pip安装，难免还会有一部分包报错（e.g., because some package is not built for Python 3.5）。
				2、 配置anaconda 指定默认环境（然并卵）：
					(1) 在当前anaconda 环境下再次创建一个环境：
						$ conda create --name=python35 anaconda python=3.5
					(2) 设置anaconda 默认 python
						 $ conda config --set core.default_env=python35
					参考文档：https://github.com/conda/conda/wiki/CEP-1:-Replacing-root-environment-with-default-environment
		参照现实问题拟定解决方案：
				基于上述方案一：
					根据我们的需求，我们不需要神降级，只需要让anaconda 支持我们编译的python就行了。
					方法：把本地编译的python下的bin覆盖anaconda root环境的bin 目录：
					前提：anaconda root 的python版本 需 与本地编译的python版本一样。
					实际中的困难：发现用cp -f 把 anaconda 下的bin 文件用 native builed python 下的 bin/* 覆盖会导致conda 命令不支持
					最终解决：把本地编译的python 下的bin目录中的 ~/Python3.5.2/bin/python3.5 ~/Python3.5.2/bin/python3.5m ~/Python3.5.2/bin/python3.5-config 覆盖到anaconda root python 的bin 下即可。
				基于上述方案二:
					只需在方案基础上把 bin 下的python3.5 、python3.5m 、python3.5-config 用本地编译的替换就OK啦
					实际操作：上述方案根本就不支持，不支持语句：$ conda config --set core.default_env=python35, 原因没有参数core.default_env
		参考：1、https://stackoverflow.com/questions/20357033/how-to-fix-program-name-usr-lib-x86-64-linux-gnu-libstdc-so-6-version-cxx 
			  2、https://gcc.gnu.org/onlinedocs/libstdc++/faq.html#faq.how_to_set_paths
		看了参考理解上的错误：
			  1、误以为把系统gcc、g++版本升级到>=4.9(实际是编译python时的系统版本)

2、 编译安装bazel 遇到的坑：
	1、编译不通：
		根据官方文档：https://docs.bazel.build/versions/master/install-compile-source.html
		1、安装上openjdk8
		2、下载bazel 源码：我直接下载了最新版本
		3、解压并进入解压目录执行：bash ./compile.sh 
		错误提示：执行时bash ./compile.sh 
			" ERROR: Must specify PROTOC if not bootstrapping from the distribution artifact "
		 原因:
			需要依赖 protoc
		 理解上的错误：
			安装protoc 并配置环境变量
			重试：
				错误提示：
					" ERROR: Must specify GRPC_JAVA_PLUGIN if not bootstrapping from the distribution artifact "
					这是什么鬼，网上继续搜，这是在错误的道路上越走越远啊，坑越来越深啦！！！果然放弃，重新开始。
		在第一个错误提示发现：
			 " To build a developer version of bazel, do $ bazel build //src:bazel	"
			我查：什么鬼，本机低版本的bazel都没有啊！！
		最终解决：已经找不到的一个参考，大体是这样说的：
			bazel 0.4.4的版本支持使用 bash compile.sh 来编译安装；
			~~~ 终于找到回家的路啦 。。。。
			下载，解压，执行，设置环境变量。果然没骗我，哈哈哈哈.....
		升级bazel的坑：
			于是下载自己需要的bazel 版本源码包：
				解压，执行 ：
				$ bazel build //src:bazel
				要泪奔啦，编译到时可以，只是不能用啊。
				这里耗时不少，最终解决方法闪亮登场： https://docs.bazel.build/versions/master/install.html
				我查查：
					If you built Bazel from source, the bash completion target is in the //scripts package:
					Build it with Bazel: bazel build //scripts:bazel-complete.bash.
					Copy the script bazel-bin/scripts/bazel-complete.bash to one of the locations described above.
				我英文不好，只能说 上面$ bazel build //src:bazel是什么鬼。还好最终解决啦。

3、 使用tensorFlow 遇到的坑：
	上面这么多坑，也想你会想下面TensorFlow 还有更大的坑等着你呢。非也，非也 ， 有了以上坑的铺垫，tensorflow 编译的异常顺利，最终生成whl文件
	不过还是有坑在运行时等着我呢：
		错误出现时：$ python -c "import tensorflow"
		报错信息：
			" F tensorflow/core/platform/cpu_feature_guard.cc:35] The TensorFlow library was compiled to use SSE instructions, but these aren't available on your machine.
			Aborted (core dumped) "
			扔了一堆洋文，python溜之大吉啦！fuck you mather Python!
			这段话大体意思是，我用SSE编译了tensorflow ,但是我的机器不支持！
		网上搜到的答案：https://github.com/tensorflow/tensorflow/issues/7778
			import os
			os.environ['TF_CPP_MIN_LOG_LEVEL']='2'
			import tensorflow as tf
			
			or if you're on a Unix system simply do export TF_CPP_MIN_LOG_LEVEL=2.
			但是用着此处无济于事。
		思路：我是不是可以在编译时就不使用SSE呢。
		回忆：
			在tensorflow 解压文档目录内 执行 ./configure 时有提醒是否做优化，当时选的默认根据本地系统自动选择的。
			" Please specify optimization flags to use during compilation [Default is -march=native]: "
			而我们在编译时又再次选择了：
			" $ bazel build --copt=march=native -c opt //tensorflow/tools/pip_package:build_pip_package " 此处：--copt=march=native 
		最终解决：编译时把--copt=march=native  去掉就可以啦：
		$ bazel build -c opt //tensorflow/tools/pip_package:build_pip_package
		
					
		
		