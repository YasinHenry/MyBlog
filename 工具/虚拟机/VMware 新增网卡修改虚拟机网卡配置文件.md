> 当为vm 虚拟机添加一个网卡，虚拟机是不会在/etc/sysconfig/network-scripts/ 下生产ifcfg-xxx 之类的 文件的。这时想要修改网络就需要手动创建这个文件

1. 找到这个新增网卡的接口名:
```
\> ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eno16777736: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 00:0c:29:1c:40:7a brd ff:ff:ff:ff:ff:ff
    inet 192.168.255.231/24 brd 192.168.255.255 scope global eno16777736
       valid_lft forever preferred_lft forever
```
> 会看到=2: eno16777736:== eno16777736 就是接口名称，有了这个就知道要创建的文件名，
> 以上为例 文件名就是 **ifcfg- eno16777736**，eno16777736 也是 文内key 为 NAME的值（或DEVICE 的值，这个有时没有）

2. 网卡
> 上面的信息还有个需要用到的信息，就是==link/ether 00:0c:29:1c:40:84==
> ==00:0c:29:1c:40:84== 这个值也要记录下来，这是文内key为HWADDR 的值

3. UUID
还有个值我们也需要知道：UUID

> ```\> nmcli con show ```

> 名称         UUID                                  类型            设备
> eno33554984  4ab47835-b16e-4cea-a399-333476c17e79  802-3-ethernet  eno33554984
>

>这个UUID ==4ab47835-b16e-4cea-a399-333476c17e79== 也是文内的一个key 为UUID 的值