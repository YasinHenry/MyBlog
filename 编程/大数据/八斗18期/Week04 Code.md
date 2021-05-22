## 案例

[toc]

1. ### 案例一：WordCount

   > 

```java
package com.yasin.hadoop;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 15:33
 */
public class WordCountDriver {
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);
        job.setJarByClass(WordCountDriver.class);

        job.setMapperClass(WordCountMapper.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(LongWritable.class);

        job.setReducerClass(WordCountReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(LongWritable.class);

        job.setCombinerClass(WordCountCombiner.class);

        FileInputFormat.setInputPaths(job, new Path(args[0]));

        if (HdfsUtils.testExist(conf, args[1])) {
            HdfsUtils.rmDir(conf, args[1]);
        }
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        job.waitForCompletion(true);
    }
}

```

```java
package com.yasin.hadoop;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 15:29
 */
public class WordCountMapper extends Mapper<LongWritable,Text,Text,LongWritable> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String lineText = value.toString();
        String[] words = lineText.split(" ");
        for (String word : words) {
            context.write(new Text(word),new LongWritable(1));
        }
    }
}

```

```java
package com.yasin.hadoop;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;
import java.util.Iterator;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 15:31
 */
public class WordCountReducer extends Reducer<Text,LongWritable,Text,LongWritable> {
    @Override
    protected void reduce(Text key, Iterable<LongWritable> values, Context context) throws IOException, InterruptedException {
        Iterator<LongWritable> iterator = values.iterator();
         long count = 0;
        while (iterator.hasNext()){
            LongWritable next = iterator.next();
            count += next.get();
        }
        context.write(new Text(key),new LongWritable(count));
    }
}

```

```java
package com.yasin.hadoop;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 18:31
 */
public class WordCountCombiner extends Reducer<Text,LongWritable,Text,LongWritable> {
    @Override
    protected void reduce(Text key, Iterable<LongWritable> values, Context context) throws IOException, InterruptedException {
        Long count = 0L;
        for (LongWritable value : values) {
            count+=value.get();
        }
        context.write(key,new LongWritable(count));
    }
}

```

### 案例二：数据去重

```java
package com.yasin.hadoop;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * Hello world!
 */
public class DataDuplicateDriver {
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);
        job.setJarByClass(DataDuplicateDriver.class);

        job.setMapperClass(DataDuplicateMapper.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(NullWritable.class);

        job.setReducerClass(DataDuplicateReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(NullWritable.class);

        job.setCombinerClass(DataDuplicateCombiner.class);

        FileInputFormat.setInputPaths(job,new Path(args[0]));
        if (HdfsUtils.testExist(conf,args[1])) {
            HdfsUtils.rmDir(conf,args[1]);
        }
        FileOutputFormat.setOutputPath(job,new Path(args[1]));
        job.waitForCompletion(true);

    }
}

```

```java
package com.yasin.hadoop;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 18:57
 */
public class DataDuplicateMapper extends Mapper<LongWritable,Text,Text,NullWritable> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        context.write(value,NullWritable.get());
    }
}

```

```java
package com.yasin.hadoop;

import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 19:03
 */
public class DataDuplicateReducer extends Reducer<Text,NullWritable,Text,NullWritable> {

    @Override
    protected void reduce(Text key, Iterable<NullWritable> values, Context context) throws IOException, InterruptedException {
        context.write(key,NullWritable.get());
    }
}

```

```java
package com.yasin.hadoop;

import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 19:20
 */
public class DataDuplicateCombiner extends Reducer<Text,NullWritable,Text,NullWritable> {

    @Override
    protected void reduce(Text key, Iterable<NullWritable> values, Context context) throws IOException, InterruptedException {
        context.write(key,NullWritable.get());
    }
}

```

### 案例三：分组求平均值

```java
package com.yasin.hadoop;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * Hello world!
 */
public class AvgDriver {
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);
        job.setJarByClass(AvgDriver.class);

        job.setMapperClass(AvgMapper.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(LongWritable.class);

        job.setReducerClass(AvgReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        FileInputFormat.setInputPaths(job,new Path(args[0]));

        if (HdfsUtils.testExist(conf,args[1])) {
            HdfsUtils.rmDir(conf,args[1]);
        }
        FileOutputFormat.setOutputPath(job,new Path(args[1]));
        job.waitForCompletion(true);

    }
}

```

```java
package com.yasin.hadoop;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 19:29
 */
public class AvgMapper extends Mapper<LongWritable,Text,Text,LongWritable> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String[] line = value.toString().split(" ");
        context.write(new Text(line[0]),new LongWritable(Long.parseLong(line[1])));
    }
}

```

```java
package com.yasin.hadoop;

import com.google.common.collect.Lists;
import org.apache.commons.collections.ListUtils;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 19:37
 */
public class AvgReducer extends Reducer<Text,LongWritable,Text,Text> {
    @Override
    protected void reduce(Text key, Iterable<LongWritable> values, Context context) throws IOException, InterruptedException {
        System.out.println(key.toString());
        double count = 0D;
        ArrayList<Long> valuesList = Lists.newArrayList();
        for (LongWritable value : values) {
            count+=value.get();
            valuesList.add(value.get());
        }
        List<Long> sortList = valuesList.stream().sorted().collect(Collectors.toList());
        System.out.println(sortList);
        int size = valuesList.size();
        double avg = count/ size;
        System.out.println("avg="+avg);
        double middle;
        if ((size%2)==0) {
            middle = (sortList.get(size/2)+sortList.get(size/2-1))/2;
        }else{
            middle = sortList.get((size-1)/2);
        }

        System.out.println("middle="+middle);

        sortList.remove(sortList.get(0));
        sortList.remove(sortList.size()-1);
        count = 0D;
        for (Long aLong : sortList) {
            count+=aLong;
        }
        double cutAvg = count/sortList.size();
        System.out.println("cutAvg="+cutAvg);
        String out = avg + " " + cutAvg + " " + middle;
        context.write(key,new Text(out));

    }
}

```

### 案例四：求最大最小值

```java
package com.yasin.hadoop;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * Hello world!
 */
public class MinMaxDriver {
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);
        job.setJarByClass(MinMaxDriver.class);

        job.setMapperClass(MinMaxMapper.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(IntWritable.class);

        job.setReducerClass(MinMaxReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);

        FileInputFormat.setInputPaths(job,args[0]);
        if (HdfsUtils.testExist(conf,args[1])) {
            HdfsUtils.rmDir(conf,args[1]);
        }
        FileOutputFormat.setOutputPath(job,new Path(args[1]));

        job.waitForCompletion(true);
    }
}

```

```java
package com.yasin.hadoop;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 10:10
 */
public class MinMaxMapper extends Mapper<LongWritable,Text,Text,IntWritable> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String valueStr = value.toString();
        String year = valueStr.substring(8, 12);
        String temperature = valueStr.substring(18, 22);
        context.write(new Text(year),new IntWritable(Integer.parseInt(temperature)));
    }
}

```

```java
package com.yasin.hadoop;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 10:20
 */
public class MinMaxReducer extends Reducer<Text,IntWritable,Text,IntWritable> {

    @Override
    protected void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
        int max =0 ;
        int min = Integer.MAX_VALUE;
        for (IntWritable value : values) {
            max = value.get()>max? value.get():max;
            min = value.get()<min? value.get():min;
        }
        context.write(key,new IntWritable(max));
    }
}

```

### 案例五：序列化机制

```java
package com.yasin.hadoop;

import com.yasin.hadoop.domain.FlowBean;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * Hello world!
 */
public class AvroDriver {
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);
        job.setJarByClass(AvroDriver.class);

        job.setMapperClass(AvroMapper.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(FlowBean.class);

        job.setReducerClass(AvroReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(FlowBean.class);

        FileInputFormat.setInputPaths(job,new Path(args[0]));
        if (HdfsUtils.testExist(conf,args[1])) {
            HdfsUtils.rmDir(conf,args[1]);
        }
        FileOutputFormat.setOutputPath(job,new Path(args[1]));
        job.waitForCompletion(false);
    }
}

```

```java
package com.yasin.hadoop;

import com.yasin.hadoop.domain.FlowBean;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 10:53
 */
public class AvroMapper extends Mapper<LongWritable,Text,Text,FlowBean> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String[] line = value.toString().split(" ");
        FlowBean flowBean = new FlowBean();
        flowBean.setPhone(line[0]);
        flowBean.setAddress(line[1]);
        flowBean.setName(line[2]);
        flowBean.setConsum(Long.parseLong(line[3]));
        context.write(new Text(flowBean.getPhone()),flowBean);
    }
}

```

```java
package com.yasin.hadoop;

import com.yasin.hadoop.domain.FlowBean;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 10:53
 */
public class AvroReducer extends Reducer<Text,FlowBean,Text,FlowBean> {
    @Override
    protected void reduce(Text key, Iterable<FlowBean> values, Context context) throws IOException, InterruptedException {
        FlowBean flowBean = new FlowBean();
        for (FlowBean value : values) {
            flowBean.setConsum(flowBean.getConsum()+value.getConsum());
            flowBean.setAddress(value.getAddress());
            flowBean.setName(value.getName());
            flowBean.setPhone(value.getPhone());
        }
        context.write(key,flowBean);
    }
}

```

```java
package com.yasin.hadoop.domain;

import lombok.Getter;
import lombok.Setter;
import org.apache.hadoop.io.Writable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 10:55
 */

@Getter
@Setter
public class FlowBean implements Writable {
    private String phone;
    private String address;
    private String name;
    private long consum;


    @Override
    public void write(DataOutput dataOutput) throws IOException {
        dataOutput.writeUTF(this.phone);
        dataOutput.writeUTF(this.address);
        dataOutput.writeUTF(this.name);
        dataOutput.writeLong(this.consum);
    }

    @Override
    public void readFields(DataInput dataInput) throws IOException {
        this.phone = dataInput.readUTF();
        this.address = dataInput.readUTF();
        this.name = dataInput.readUTF();
        this.consum = dataInput.readLong();
    }

    @Override
    public String toString() {
        return "FlowBean{" +
                "phone='" + phone + '\'' +
                ", address='" + address + '\'' +
                ", name='" + name + '\'' +
                ", consum=" + consum +
                '}';
    }
}

```

### 案例六：分区

```java
package com.yasin.hadoop;

import com.yasin.hadoop.domain.FlowBean;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 15:33
 */
public class PartitionDriver {
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);
        job.setJarByClass(PartitionDriver.class);

        job.setMapperClass(PartitionMapper.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(FlowBean.class);

        job.setReducerClass(PartitionReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(FlowBean.class);

        job.setNumReduceTasks(4);
        job.setPartitionerClass(PartitionPartitioner.class);

        FileInputFormat.setInputPaths(job, new Path(args[0]));

        if (HdfsUtils.testExist(conf, args[1])) {
            HdfsUtils.rmDir(conf, args[1]);
        }
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        job.waitForCompletion(true);
    }
}

```

```java
package com.yasin.hadoop;

import com.yasin.hadoop.domain.FlowBean;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 15:22
 */
public class PartitionMapper extends Mapper<LongWritable,Text,Text,FlowBean> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String[] line = value.toString().split(" ");
        FlowBean flowBean = new FlowBean();
        flowBean.setPhone(line[0]);
        flowBean.setAddress(line[1]);
        flowBean.setName(line[2]);
        flowBean.setConsum(Long.parseLong(line[3]));
        context.write(new Text(flowBean.getPhone()),flowBean);
    }
}

```

```java
package com.yasin.hadoop;

import com.yasin.hadoop.domain.FlowBean;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Partitioner;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 15:23
 */
public class PartitionPartitioner extends Partitioner<Text,FlowBean> {

    @Override
    public int getPartition(Text text, FlowBean flowBean, int i) {
//        return (flowBean.getAddress().hashCode()&Integer.MAX_VALUE)%i;
        if ("bj".equals(flowBean.getAddress())) {
            return 0;
        }
        if ("sh".equals(flowBean.getAddress())) {
            return 1;
        }
        if ("sz".equals(flowBean.getAddress())) {
            return 2;
        }else {
            return 3;
        }
    }
}

```

```java
package com.yasin.hadoop;

import com.yasin.hadoop.domain.FlowBean;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 15:22
 */
public class PartitionReducer extends Reducer<Text,FlowBean,Text,FlowBean> {
    @Override
    protected void reduce(Text key, Iterable<FlowBean> values, Context context) throws IOException, InterruptedException {
        FlowBean flowBean = new FlowBean();
        for (FlowBean value : values) {
            flowBean.setConsum(flowBean.getConsum()+value.getConsum());
            flowBean.setAddress(value.getAddress());
            flowBean.setName(value.getName());
            flowBean.setPhone(value.getPhone());
        }
        context.write(key,flowBean);
    }
}

```

```java
package com.yasin.hadoop.domain;

import lombok.Getter;
import lombok.Setter;
import org.apache.hadoop.io.Writable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 10:55
 */

@Getter
@Setter
public class FlowBean implements Writable {
    private String phone;
    private String address;
    private String name;
    private long consum;


    @Override
    public void write(DataOutput dataOutput) throws IOException {
        dataOutput.writeUTF(this.phone);
        dataOutput.writeUTF(this.address);
        dataOutput.writeUTF(this.name);
        dataOutput.writeLong(this.consum);
    }

    @Override
    public void readFields(DataInput dataInput) throws IOException {
        this.phone = dataInput.readUTF();
        this.address = dataInput.readUTF();
        this.name = dataInput.readUTF();
        this.consum = dataInput.readLong();
    }

    @Override
    public String toString() {
        return "FlowBean{" +
                "phone='" + phone + '\'' +
                ", address='" + address + '\'' +
                ", name='" + name + '\'' +
                ", consum=" + consum +
                '}';
    }
}

```

### 案例七：归约 combiner

```java
// 参照案例一 
```

### 案例八

```java
package com.yasin.hadoop.hadoop.domain;

import lombok.Getter;
import lombok.Setter;
import org.apache.hadoop.io.WritableComparable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 18:42
 */
@Getter
@Setter
public class Movie implements WritableComparable<Movie> {

    private String name;
    private int hot;

    @Override
    public int compareTo(Movie o) {
        return this.hot-o.hot;
    }

    @Override
    public void write(DataOutput dataOutput) throws IOException {
        dataOutput.writeUTF(this.name);
        dataOutput.writeInt(this.hot);
    }

    @Override
    public void readFields(DataInput dataInput) throws IOException {
        this.name = dataInput.readUTF();
        this.hot = dataInput.readInt();
    }

    @Override
    public String toString() {
        return "Movie{" +
                "name='" + name + '\'' +
                ", hot=" + hot +
                '}';
    }
}

```



#### （1）：排序

```java
package com.yasin.hadoop.hadoop.sort;

import com.yasin.hadoop.HdfsUtils;
import com.yasin.hadoop.hadoop.domain.Movie;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 15:33
 */
public class SortDriver {
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);
        job.setJarByClass(SortDriver.class);

        job.setMapperClass(SortMapper.class);
        job.setMapOutputKeyClass(Movie.class);
        job.setMapOutputValueClass(NullWritable.class);

        FileInputFormat.setInputPaths(job, new Path(args[0]));

        if (HdfsUtils.testExist(conf, args[1])) {
            HdfsUtils.rmDir(conf, args[1]);
        }
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        job.waitForCompletion(true);
    }
}

```

```java
package com.yasin.hadoop.hadoop.sort;

import com.yasin.hadoop.hadoop.domain.Movie;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 15:29
 */
public class SortMapper extends Mapper<LongWritable,Text,Movie,NullWritable> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String lineText = value.toString();
        String[] words = lineText.split(" ");
        Movie movie = new Movie();
        movie.setName(words[0]);
        movie.setHot(Integer.parseInt(words[1]));
        context.write(movie,NullWritable.get());
    }
}

```

#### （2）：全排

```java
package com.yasin.hadoop.hadoop.totlesort;

import com.yasin.hadoop.HdfsUtils;
import com.yasin.hadoop.hadoop.domain.Movie;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.lib.TotalOrderPartitioner;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 15:33
 */
public class TotalSortDriver {
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);
        job.setJarByClass(TotalSortDriver.class);

        job.setMapperClass(TotalSortMapper.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(IntWritable.class);

        job.setReducerClass(TatolReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);

        job.setNumReduceTasks(4);
        job.setPartitionerClass(TatolPartition.class);

        FileInputFormat.setInputPaths(job, new Path(args[0]));

        if (HdfsUtils.testExist(conf, args[1])) {
            HdfsUtils.rmDir(conf, args[1]);
        }
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        job.waitForCompletion(true);
    }
}

```

```java
package com.yasin.hadoop.hadoop.totlesort;

import com.yasin.hadoop.hadoop.domain.Movie;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 15:29
 */
public class TotalSortMapper extends Mapper<LongWritable,Text,Text,IntWritable> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String lineText = value.toString();
        String[] words = lineText.split(" ");
        for (String word : words) {
            context.write(new Text(word),new IntWritable(1));
        }
    }
}

```

```java
package com.yasin.hadoop.hadoop.totlesort;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 19:10
 */
public class TatolReducer extends Reducer<Text,IntWritable,Text,IntWritable> {
    @Override
    protected void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
        int count=0;
        for (IntWritable value : values) {
            count+=value.get();
        }
        context.write(key,new IntWritable(count));
    }
}

```

```java
package com.yasin.hadoop.hadoop.totlesort;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Partitioner;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 19:29
 */
public class TatolPartition extends Partitioner<Text,IntWritable> {
    @Override
    public int getPartition(Text text, IntWritable intWritable, int i) {
        String str = text.toString();
        if (str.matches("\\d{1}")) {
            return 0;
        }else if (str.matches("\\d{2}")){
            return 1;
        }else if (str.matches("\\d{3}")){
            return 2;
        }else {
            return 3;
        }
    }
}

```

### 案例九：多文件合并

```java
package com.yasin.hadoop;

import com.yasin.hadoop.HdfsUtils;
import com.yasin.hadoop.domain.Score;
import com.yasin.hadoop.domain.TotalScore;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 15:33
 */
public class MutilFileDriver {
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);
        job.setJarByClass(MutilFileDriver.class);

        job.setMapperClass(MutilFileMapper.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(Score.class);

        job.setReducerClass(MutilFileReducer.class);
        job.setOutputKeyClass(TotalScore.class);
        job.setOutputValueClass(NullWritable.class);

        FileInputFormat.setInputPaths(job, new Path(args[0]));

        if (HdfsUtils.testExist(conf, args[1])) {
            HdfsUtils.rmDir(conf, args[1]);
        }
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        job.waitForCompletion(true);
    }
}

```

```java
package com.yasin.hadoop;

import com.yasin.hadoop.domain.Score;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.InputSplit;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 15:29
 */
public class MutilFileMapper extends Mapper<LongWritable,Text,Text,Score> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        FileSplit inputSplit = (FileSplit)context.getInputSplit();
        String course = inputSplit.getPath().getName();

        String lineText = value.toString();
        String[] words = lineText.split(" ");
        Score score = new Score();
        score.setCourse(course);
        score.setMonth(Integer.parseInt(words[0]));
        score.setName(words[1]);
        score.setScore(Float.parseFloat(words[2]));
        context.write(new Text(score.getName()),score);
    }
}

```

```java
package com.yasin.hadoop;

import com.yasin.hadoop.domain.Score;
import com.yasin.hadoop.domain.TotalScore;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 19:10
 */
public class MutilFileReducer extends Reducer<Text,Score,TotalScore,NullWritable> {
    @Override
    protected void reduce(Text key, Iterable<Score> values, Context context) throws IOException, InterruptedException {
        int chinese=0;
        int english=0;
        int math=0;
        for (Score value : values) {
            switch (value.getCourse()){
                case "chinese.txt":
                    chinese+=value.getScore();
                    break;
                case "english.txt":
                    english+=value.getScore();
                    break;
                case "math.txt":
                    math+=value.getScore();
                    break;
                default:
                    break;
            }
        }
        TotalScore score = new TotalScore();
        score.setName(key.toString());
        score.setChineseScore(chinese);
        score.setEngliseScore(english);
        score.setMathScore(math);
        context.write(score,NullWritable.get());
    }
}

```

```java
package com.yasin.hadoop.domain;

import lombok.Getter;
import lombok.Setter;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.io.WritableComparable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 18:42
 */
@Getter
@Setter
public class Score implements Writable {

    private String name;
    private String course;
    private float score;
    private int month;

    @Override
    public void write(DataOutput dataOutput) throws IOException {
        dataOutput.writeUTF(this.name);
        dataOutput.writeUTF(this.course);
        dataOutput.writeFloat(this.score);
        dataOutput.writeInt(this.month);
    }

    @Override
    public void readFields(DataInput dataInput) throws IOException {
        this.name = dataInput.readUTF();
        this.course = dataInput.readUTF();
        this.score = dataInput.readFloat();
        this.month = dataInput.readInt();
    }

    @Override
    public String toString() {
        return "Score{" +
                "name='" + name + '\'' +
                ", course='" + course + '\'' +
                ", score=" + score +
                ", month=" + month +
                '}';
    }
}

```

```java
package com.yasin.hadoop.domain;

import lombok.Getter;
import lombok.Setter;
import org.apache.hadoop.io.Writable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 18:42
 */
@Getter
@Setter
public class TotalScore implements Writable {

    private String name;
    private float chineseScore;
    private float engliseScore;
    private float mathScore;

    @Override
    public void write(DataOutput dataOutput) throws IOException {
        dataOutput.writeUTF(this.name);
        dataOutput.writeFloat(this.chineseScore);
        dataOutput.writeFloat(this.engliseScore);
        dataOutput.writeFloat(this.mathScore);
    }

    @Override
    public void readFields(DataInput dataInput) throws IOException {
        this.name = dataInput.readUTF();
        this.chineseScore = dataInput.readFloat();
        this.engliseScore = dataInput.readFloat();
        this.mathScore = dataInput.readFloat();
    }

    @Override
    public String toString() {
        return "TotalScore{" +
                "name='" + name + '\'' +
                ", chineseScore=" + chineseScore +
                ", engliseScore=" + engliseScore +
                ", mathScore=" + mathScore +
                '}';
    }
}

```

### 案例十：多级MR

> mr1 的输出结果作为mr2的输入

```java
package com.yasin.hadoop.Mr1;

import com.yasin.hadoop.HdfsUtils;
import com.yasin.hadoop.domain.Company;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/3 15:09
 */
public class Mr1Driver {
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);
        job.setJarByClass(Mr1Driver.class);
        job.setMapperClass(Mr1Mapper.class);
        job.setReducerClass(Mr1Reducer.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(Company.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);

        FileInputFormat.setInputPaths(job,new Path(args[0]));

        if (HdfsUtils.testExist(conf,args[1])) {
            HdfsUtils.rmDir(conf,args[1]);
        }
        FileOutputFormat.setOutputPath(job,new Path(args[1]));
        job.waitForCompletion(true);

    }
}

```

```java
package com.yasin.hadoop.Mr1;

import com.yasin.hadoop.domain.Company;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/3 15:16
 */
public class Mr1Mapper extends Mapper<LongWritable,Text,Text,Company> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String[] line = value.toString().split(" ");
        Company company = new Company();
        company.setName(line[1]);
        company.setProfit(Integer.parseInt(line[2])-Integer.parseInt(line[3]));
        context.write(new Text(company.getName()),company);
    }
}

```

```java
package com.yasin.hadoop.Mr1;

import com.yasin.hadoop.domain.Company;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/3 15:21
 */
public class Mr1Reducer extends Reducer<Text,Company,Text,IntWritable> {
    @Override
    protected void reduce(Text key, Iterable<Company> values, Context context) throws IOException, InterruptedException {

        Company company = new Company();
        company.setName(key.toString());
        for (Company value : values) {
            company.setProfit(company.getProfit()+value.getProfit());
        }
        context.write(new Text(company.getName()),new IntWritable(company.getProfit()));
    }
}

```

```java
package com.yasin.hadoop.Mr2;

import com.yasin.hadoop.HdfsUtils;
import com.yasin.hadoop.Mr1.Mr1Mapper;
import com.yasin.hadoop.Mr1.Mr1Reducer;
import com.yasin.hadoop.domain.Company;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/3 15:09
 */
public class Mr2Driver {
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);
        job.setJarByClass(Mr2Driver.class);

        job.setMapperClass(Mr2Mapper.class);

        job.setOutputKeyClass(Company.class);
        job.setOutputValueClass(NullWritable.class);

        FileInputFormat.setInputPaths(job,new Path(args[0]));

        if (HdfsUtils.testExist(conf,args[1])) {
            HdfsUtils.rmDir(conf,args[1]);
        }
        FileOutputFormat.setOutputPath(job,new Path(args[1]));
        job.waitForCompletion(true);

    }
}

```

```java
package com.yasin.hadoop.Mr2;

import com.yasin.hadoop.domain.Company;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/3 15:16
 */
public class Mr2Mapper extends Mapper<LongWritable,Text,Company,NullWritable> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String[] line = value.toString().split("\\t");
        Company company = new Company();
        company.setName(line[0]);
        company.setProfit(Integer.parseInt(line[1]));
        context.write(company,NullWritable.get());
    }
}

```

```java
package com.yasin.hadoop.domain;

import lombok.Getter;
import lombok.Setter;
import org.apache.hadoop.io.WritableComparable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/3 15:04
 */
@Getter
@Setter
public class Company implements WritableComparable<Company> {

    private String name;
    private int profit;
    @Override
    public int compareTo(Company o) {
        return this.profit-o.profit;
    }

    @Override
    public void write(DataOutput dataOutput) throws IOException {
        dataOutput.writeUTF(this.name);
        dataOutput.writeInt(this.profit);
    }

    @Override
    public void readFields(DataInput dataOutput) throws IOException {
        this.name = dataOutput.readUTF();
        this.profit = dataOutput.readInt();
    }

    @Override
    public String toString() {
        return "Company{" +
                "name='" + name + '\'' +
                ", profit=" + profit +
                '}';
    }
}

```

### 案例十一：相似好友查询



![image-20200910102709105](Week04%20Code.assets/image-20200910102709105.png)

#### 解一

```java
package com.yasin.hadoop;

import com.yasin.hadoop.mr1.FriendMapper;
import com.yasin.hadoop.mr1.FriendReducer;
import com.yasin.hadoop.mr2.Friend2Mapper;
import com.yasin.hadoop.mr2.Friend2Reducer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 15:33
 */
public class FriendDriver {
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);
        job.setJarByClass(FriendDriver.class);

        job.setMapperClass(FriendMapper.class);
        job.setReducerClass(FriendReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        FileInputFormat.setInputPaths(job, new Path(args[0]));

        if (HdfsUtils.testExist(conf, args[1])) {
            HdfsUtils.rmDir(conf, args[1]);
        }
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        job.waitForCompletion(true);


        Job job1 = Job.getInstance(conf);
        job1.setJarByClass(FriendDriver.class);

        job1.setMapperClass(Friend2Mapper.class);
        job1.setReducerClass(Friend2Reducer.class);
        job1.setOutputKeyClass(Text.class);
        job1.setOutputValueClass(Text.class);

        FileInputFormat.setInputPaths(job1, new Path(args[1]));

        if (HdfsUtils.testExist(conf, args[2])) {
            HdfsUtils.rmDir(conf, args[2]);
        }
        FileOutputFormat.setOutputPath(job1, new Path(args[2]));

        job1.waitForCompletion(true);
    }
}

```

```java
package com.yasin.hadoop.mr1;

import org.apache.commons.lang3.StringUtils;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 15:29
 */
public class FriendMapper extends Mapper<LongWritable,Text,Text,Text> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String[] lineText = value.toString().split("\\t");
        if (lineText.length!=2) {
            return;
        }

        String uid = lineText[0];
        if (StringUtils.isEmpty(uid)) {
            return;
        }
        String fids = lineText[1];
        for (String fid : fids.split(",")) {
            if (StringUtils.isEmpty(fid)) {
                continue;
            }
            context.write(new Text(fid),new Text(uid));
        }
    }
}

```

```java
package com.yasin.hadoop.mr1;

import com.clearspring.analytics.util.Lists;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;
import java.util.*;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 19:10
 */
public class FriendReducer extends Reducer<Text, Text, Text, Text> {
    @Override
    protected void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
        Iterator<Text> iterator = values.iterator();
        Set set = new HashSet();
        while (iterator.hasNext()) {
            String user = iterator.next().toString();
            set.add(user);
        }
        List<String> list = Lists.newArrayList(set);
        Collections.sort(list);
        for (int i = 0; i < list.size(); i++) {
            for (int j = i+1; j < list.size(); j++) {
                context.write(new Text(list.get(i)+"_"+list.get(j)), key);
            }
        }
    }
}

```

```java
package com.yasin.hadoop.mr2;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/8/31 15:29
 */
public class Friend2Mapper extends Mapper<LongWritable,Text,Text,Text> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String[] lineText = value.toString().split("\\t");
        String uids = lineText[0];
        String fid = lineText[1];
        context.write(new Text(uids),new Text(fid));
    }
}

```

```java
package com.yasin.hadoop.mr2;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/1 19:10
 */
public class Friend2Reducer extends Reducer<Text, Text, Text, Text> {
    @Override
    protected void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
        StringBuilder sb = new StringBuilder();
        for (Text value : values) {
            sb.append(value).append(",");
        }
        context.write(key,new Text(sb.toString()));
    }
}

```

#### 解二

```java
package com.yasin.hadoop;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * Hello world!
 *
 */
public class FIndFriendDriver
{
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
//        step1
        Job job1 = Job.getInstance(conf);
        job1.setJarByClass(FIndFriendDriver.class);
        job1.setMapperClass(FriendMapper.class);
        job1.setReducerClass(FriendReducer.class);
        job1.setOutputKeyClass(Text.class);
        job1.setOutputValueClass(Text.class);
        FileInputFormat.setInputPaths(job1,new Path(args[0]));
        if (HdfsUtils.testExist(conf,args[1])) {
            HdfsUtils.rmDir(conf,args[1]);
        }
        FileOutputFormat.setOutputPath(job1, new Path(args[1]));
        boolean res1=job1.waitForCompletion(true);


//        step1
        Job job2 = Job.getInstance(conf);
        job2.setJarByClass(FIndFriendDriver.class);
        job2.setMapperClass(FriendMapper1.class);
        job2.setReducerClass(FriendReducer1.class);
        job2.setOutputKeyClass(Text.class);
        job2.setOutputValueClass(Text.class);
        FileInputFormat.setInputPaths(job2,new Path(args[1]));
        if (HdfsUtils.testExist(conf,args[2])) {
            HdfsUtils.rmDir(conf,args[2]);
        }
        FileOutputFormat.setOutputPath(job2, new Path(args[2]));
        boolean res2 = job2.waitForCompletion(true);

        System.exit(res1?0:1);


    }
}

```

```java
package com.yasin.hadoop;

import org.apache.commons.lang3.StringUtils;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/3 21:51
 */
class FriendMapper  extends Mapper<LongWritable,Text, Text,Text> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        String[] line = value.toString().split("\t");

        if (line.length!=2) {
            return;
        }

        String uid = line[0];
        if (StringUtils.isEmpty(uid)) {
            return;
        }

        String[] friends = line[1].split(",");

        for (String fre: friends) {
            if (StringUtils.isEmpty(fre)) {
                continue;
            }
            context.write(new Text(fre),new Text(uid));
        }


    }
}

```

```java
package com.yasin.hadoop;

import org.apache.commons.lang3.StringUtils;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/3 21:52
 */
class FriendReducer extends Reducer<Text,Text,Text,Text> {
    @Override
    protected void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {

        Set<String> sb = new HashSet<>();
        for (Text fre: values) {
            sb.add(fre.toString());
        }
        String re=StringUtils.join(sb,",");
        context.write(key,new Text(re));
    }
}

```

```java
package com.yasin.hadoop;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;
import java.util.Arrays;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/3 21:53
 */
class FriendMapper1 extends Mapper<LongWritable,Text, Text,Text> {

    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {

        String[] lines= value.toString().split("\t");

        String friend = lines[0];

        String[] users = lines[1].split(",");

        Arrays.sort(users);
        for (int i = 0; i <users.length ; i++) {
            for (int j = i+1; j <users.length ; j++) {
                context.write(new Text(users[i]+"_"+users[j]),new Text(friend));
            }
        }
    }
}

```

```java
package com.yasin.hadoop;

import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/3 21:54
 */
class FriendReducer1 extends Reducer<Text,Text,Text,Text> {
    @Override
    protected void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {


        Set<String> set = new HashSet();

        for (Text fre:values) {
            set.add(fre.toString());
        }
        String re = StringUtils.join(set, ",");
        context.write(new Text(key),new Text(re));

    }
}

```

### 案例十一扩展：对比案例十一解一和解二的结果

```java
package com.yasin.hadoop;

import com.yasin.hadoop.domain.FileCompare;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

/**
 * Hello world!
 *
 */
public class CompareDriver
{
    public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration conf = new Configuration();
//        step1
        Job job = Job.getInstance(conf);

        job.setJarByClass(CompareDriver.class);

        job.setMapperClass(CompareMapper.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(FileCompare.class);

        job.setReducerClass(CompareReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        FileInputFormat.setInputPaths(job,new Path(args[0]),new Path(args[1]));
//        FileInputFormat.setInputPaths(job,new Path(args[0]));
        if (HdfsUtils.testExist(conf,args[2])) {
            HdfsUtils.rmDir(conf,args[2]);
        }
        FileOutputFormat.setOutputPath(job, new Path(args[2]));

        job.waitForCompletion(true);
    }
}

```

```java
package com.yasin.hadoop;

import com.yasin.hadoop.domain.FileCompare;
import org.apache.commons.lang3.StringUtils;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.InputSplit;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;

import java.io.IOException;
import java.util.Arrays;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/3 21:51
 */
class CompareMapper extends Mapper<LongWritable,Text, Text,FileCompare> {
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        FileSplit inputSplit = (FileSplit)context.getInputSplit();
        String fileName = inputSplit.getPath().getParent().getParent().getName();

        FileCompare fileCompare = new FileCompare();
        fileCompare.setFileName(fileName);

        String[] line = value.toString().split("\\t");

        if (line.length!=2) {
            return;
        }

        String uids = line[0];
        if (StringUtils.isEmpty(uids)) {
            return;
        }

        String[] friends = line[1].split(",");
        Arrays.sort(friends);


        fileCompare.setKey(uids);
        fileCompare.setValues(StringUtils.join(friends,","));

        context.write(new Text(uids),fileCompare);

    }
}

```

```java
package com.yasin.hadoop;

import com.clearspring.analytics.util.Lists;
import com.yasin.hadoop.domain.FileCompare;
import org.apache.commons.lang3.StringUtils;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import static org.apache.commons.lang3.StringUtils.*;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/3 21:52
 *
 * =IF(
 * 	#
 * 	J14<>"",
 * 	IF(OR(WEEKDAY(C9&-A14,2)==6,WEEKDAY(C9&-A14,2)==7),
 *
 * 		,
 * 		IF(
 * 			AND(J14<=TIME(23,59,59),J14>TIME(20,0,0)),
 * 			J14-TIME(20,0,0),
 * 			IF(
 * 				AND(J14>=TIME(0,0,0),J14<TIME(8,30,0)),
 * 				TIME(23,59,59)-TIME(20,0,0)+J14,
 * 				TIME(0,0,0)
 * 				)
 * 			)
 * 		),
 * 	TIME(0,0,0)
 * 	)
 */
class CompareReducer extends Reducer<Text,FileCompare,Text,Text> {
    @Override
    protected void reduce(Text key, Iterable<FileCompare> values, Context context) throws IOException, InterruptedException {

        List<FileCompare> fileCompareList = Lists.newArrayList(values);
        if(fileCompareList.size()<2) {
            context.write(new Text(fileCompareList.get(0).toString()),new Text("1"));
        }else if(fileCompareList.size()==2){
            FileCompare fileCompare0 = fileCompareList.get(0);
            FileCompare fileCompare1 = fileCompareList.get(1);
            // 文件名 相同
            if (StringUtils.equals(fileCompare0.getFileName(),fileCompare1.getFileName())) {
                context.write(new Text(StringUtils.join(fileCompareList,"|")),new Text("2"));
            }else {
                if (StringUtils.equals(fileCompare0.getValues(), fileCompare1.getValues())) {
                    // value 相同 、名称相同
                    return;
                }else {
                    context.write(new Text(StringUtils.join(fileCompareList,"|")),new Text("<>"));
                }
            }
        }else {
            String join = join(fileCompareList, ",");
            context.write(new Text(join),new Text("3+"));
        }
    }
}

```

```java
package com.yasin.hadoop.domain;

import lombok.Getter;
import lombok.Setter;
import org.apache.commons.lang3.StringUtils;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.io.WritableComparable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.util.Arrays;
import java.util.Set;

/**
 * @Description
 * @Author 王广亚
 * @Date 2020/9/4 14:46
 */
@Getter
@Setter
public class FileCompare implements Writable {

    private String fileName;
    private String key;
    private String values;

    @Override
    public void write(DataOutput dataOutput) throws IOException {
        dataOutput.writeUTF(this.fileName);
        dataOutput.writeUTF(this.key);
        dataOutput.writeUTF(this.values);
/*        int length = this.values.length;
        new IntWritable(length).write(dataOutput);
        for (int i = 0; i < length; i++) {
            new Text(this.values[i]).write(dataOutput);
        }*/

    }

    @Override
    public void readFields(DataInput dataInput) throws IOException {
        this.fileName = dataInput.readUTF();
        this.key = dataInput.readUTF();
        this.values= dataInput.readUTF();

     /*   IntWritable intWritable = new IntWritable();
        intWritable.readFields(dataInput);
        int length = intWritable.get();
        for (int i = 0; i < length; i++) {
            Text text = new Text();
            text.readFields(dataInput);
            this.values[i]=text.toString();
        }*/
    }

    @Override
    public String toString() {
        return "{" +
                "fileName='" + fileName + '\'' +
                ", key='" + key + '\'' +
                ", values='" + values + '\'' +
                '}';
    }
}

```

### 案例十二：小文件



### 案例十三：矩阵乘法



### 案例十四：MR实现kmenas



### 案例十五：MR实现基于用户的协同过滤