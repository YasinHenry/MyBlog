# WSL教程

[toc]

## 安装WSL

> 方法一：以管理员身份打开PowerShell 执行一下命令

```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

> 方法二：打开控制面板&rarr;启动和关闭Windows功能&rarr;勾选“适用于Linux的Windows子系统” 和 勾选Hyper-V

## 安装Windows Linux子系统

> 方法一：去Microsoft Store 安装
>
> 方法二：
>
> > ##列出可用的Linux子系统
> >
> > `wsl -l --online`
> >
> > ##安装列表中的Linux子系统
> >
> > wsl.exe --install <Distro>

## 启动Linux子系统

> ##列出已安装的子系统
>
> `wsl -l`
>
> ##启动列表中的其中一个 
>
> `wsl -d <Distro>`
>
> wsl -d Ubuntu-22.04 -u root # -u 指定用户，进入后可以使用`passwd`命令修改密码

## 服务端口相关

> WSL和Win10共享同一套端口，如果出现两者监听同一个端口的情况，Windows主系统的程序拥有更高的优先级

## 宿主机和客户机文件系统访问

> WSL和Windows主系统之间的文件系统是可以互相访问的。
>
> 如果在WSL中访问Windows系统的文件，可在根目录下看到对应Windows盘符字母的文件夹，通过这些文件夹即可访问Windows的文件系统。
>
> 如果在Windows系统中访问WSL的文件，可在Windows系统中找到已安装Linux发行版的应用数据文件夹，所有Linux系统的数据都在那个文件夹

## 命令

1. 关闭-立即终止所有正在运行的发行版

```
wsl --shutdown
```

2. 终止指定的发行版或阻止其运行

```
wsl --terminate <Distribution Name>
```

3. 从 WSL 2 看到的 WINDOWS 计算机的 IP 地址 (WSL 2 VM)

```
cat /etc/resolv.conf 
```

4. 将指定分发版的快照导出为新的分发文件, 默认为 tar 格式

- `--vhd`：指定导出分发版应为 .vhdx 文件而不是 tar 文件（这仅在使用 WSL 2 的情况下受支持）

```
wsl --export <Distribution Name> <FileName>
```

5. 导入分发版

> 导入指定的 tar 文件作为新的分发版。 在标准输入中，文件名可以是 `-`。 选项包括：
>
> - `--vhd`：指定导入分发版应为 .vhdx 文件而不是 tar 文件（这仅在使用 WSL 2 的情况下受支持）
> - `--version <1/2>`：指定将分发版导入为 WSL 1 还是 WSL 2 分发版

```
wsl --import <Distribution Name> <InstallLocation> <FileName>
```

6. 就地导入发行版

```
wsl --import-in-place <Distribution Name> <FileName>
```

7. 注销并卸载 WSL 发行版

```
wsl --unregister <DistributionName>
```

8.  装载磁盘或设备

> - `--vhd`：指定 `<Disk>` 引用虚拟硬盘。
> - `--name`：使用装入点的自定义名称装载磁盘
> - `--bare`：将磁盘附加到 WSL2，但不进行装载。
> - `--type <Filesystem>`：装载磁盘时使用的文件系统类型默认为 ext4（如果未指定）。 此命令也可输入为：`wsl --mount -t <Filesystem>`。可以使用 `blkid <BlockDevice>` 命令检测文件系统类型，例如：`blkid <dev/sdb1>`。
> - `--partition <Partition Number>`：要装载的分区的索引号默认为整个磁盘（如果未指定）。
> - `--options <MountOptions>`：装载磁盘时，可以包括一些特定于文件系统的选项。 例如，`wsl --mount -o "data-ordered"` 或 `wsl --mount -o "data=writeback` 之类的 [ext4 装载选项](https://www.kernel.org/doc/Documentation/filesystems/ext4.txt)。 但是，目前仅支持特定于文件系统的选项。 不支持通用选项，例如 `ro`、`rw` 或 `noatime`。

```
wsl --mount <DiskPath>
```

9.  卸载磁盘

> 如果未提供磁盘路径，则此命令将卸载并分离所有已装载的磁盘

```
wsl --unmount <DiskPath>
```

## wsl配置文件

1. ```
   /etc/resolv.conf # 包含了访问宿主机的ip地址
   ```

   
