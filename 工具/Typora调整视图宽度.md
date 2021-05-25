# Typora 调整视图宽度

> 屏幕这么大，调整Typora 最大化两边仍然有很大一部分不能使用的部分，实在难受。下面我教大家调整Typora 的视图宽度

1. 依次点击Typora 窗口的： 文件 ->  偏好设置 -> 外观 -> 打开主题文件夹

   如下是点击后打开的系统文件夹：

   ![image-20210525093213559](https://i.loli.net/2021/05/25/SI1HPqKzMmCG3ao.png)

如果你现在用的主题是Cobalt (可以在Typora 窗口的 “视图”查看)，那么可以创建一个`cobalt.user.css` 文件，文件内容如下：

```css
/* 调整视图正文宽度 */
#write{
    max-width: 90%;
}

/* 调整源码正文宽度 */
#typora-source .CodeMirror-lines {
    max-width: 90%;
}

/* 调整输出 PDF 文件宽度 */
@media print {
    #write{
        max-width: 95%;
    }
    @page {
        size: A3;
    }
}

/* 调整正文字体,字体需单独下载 */
body {
    font-family: IBM Plex Sans;
}
```

保存就可以了。