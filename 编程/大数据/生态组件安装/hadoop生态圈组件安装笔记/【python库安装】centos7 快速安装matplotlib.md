#### Tips
可以通过
```
yum search matplotlib
```
安装，迅速便捷~~~

#### 步骤
1. 第一步 
    ```linux
    yum search matplotlib
    ```
    返回结果：
    ```
    [root@master roi_auc_test]# yum search matplotlib
    已加载插件：fastestmirror, langpacks
    Loading mirror speeds from cached hostfile
     * base: mirrors.zju.edu.cn
     * extras: mirror.lzu.edu.cn
     * updates: mirrors.neusoft.edu.cn
    ============================= N/S matched: matplotlib =============================
    python-matplotlib-doc.x86_64 : Documentation files for python-matplotlib
    python-matplotlib-qt4.x86_64 : Qt4 backend for python-matplotlib
    python-matplotlib-tk.x86_64 : Tk backend for python-matplotlib
    python-matplotlib.x86_64 : Python 2D plotting library
    
      名称和简介匹配 only，使用“search all”试试。
    ```
2. 第二步：选择最后一个安装：
    ```
    yum install python-matplotlib.x86_64
    ```
    它会将所有的依赖安装上~~~

#### tips
  不知道安装其他的时候能不能用这个方法，没试验过~~