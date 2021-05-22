## 小文件

> 小于hdfs block 块的大小的文件定义为小文件
>
> 在上次源文件是我们可以减少小文件的。
>
> 在mr 运行是会产生大量小文件，那么在mr 时如何减少小文件的产生呢。
>
> 很多数据开发人员大多在同一个hadoop 平台上跑任务，当同时产生的小文件过多会导致master 瞬间崩溃。

> 小文件危害：
>
> > 1. 导致master 管理难度升级（内存存了大量小文件元数据）
> > 2. 小文件导致hadoop 会为每个小文件启动一个MR。
> > 3. 虽然配置了HA,但是面对小文件也束手无策



> 解决小文件问题：
>
> 1. 输入的小文件
>
>    ​	把小文件合并为大文件。
>
> 2. Mapper 节点输出序列文件
>
>    > ```java
>    > //输入为seq
>    > job.setInputFormatClass(SequenceFileInputFormat.class)
>    > //输出为seq
>    > job.setOutputFormatClass(SequenceFileOutputFormat.class);
>    > SequenceFileOutputFormat.setOutputCompressionType(job.SequenceFile.Compression.NON);// 不压缩,也可以压缩压缩后mr 在读取时是不可分的。
>    > ```
>
> 3.  
>
>    
>
>    

