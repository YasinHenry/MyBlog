# Kubernetes 配置域名映射

[toc]

## 在 Pod 的 YAML 配置文件中定义 `hosts` 字段来映射 hosts。

具体步骤如下：

1. 在 Pod 的 YAML 配置文件中添加一个 `hosts` 字段，指定要映射的 hosts。例如：

   ```
   spec:
     containers:
     - name: my-container
       image: my-image
     hostAliases:
     - ip: "192.168.0.100"
       hostnames:
       - "example.com"
       - "www.example.com"
   ```

2. 将 `ip` 字段设置为要映射到的 IP 地址，将 `hostnames` 字段设置为要映射的域名列表。

3. 保存并部署该配置文件，这样 Kubernetes 就会在容器内部创建相应的 hosts 映射。

4. 缺点是无法支持域名的大写字母

注意：Kubernetes 中的 `hosts` 字段只能映射静态的 hosts，不能动态更新， 动态更新 hosts，需要使用其他方式实现，例如在容器启动时执行脚本修改 hosts。

## 通过脚本修改容器hosts



## 通过 Kubernetes 中的 ConfigMap 来配置 hosts 映射。

具体步骤如下：

1. 创建一个包含要映射的域名和 IP 地址的 ConfigMap。例如：

   ```yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: my-configmap
   data:
     hosts: |
       192.168.0.100 example.com www.example.com
   ```

   

2. 在 Pod 的 YAML 配置文件中添加一个 `configMap` 卷，并将该卷挂载到容器中。例如：

   ```
   spec:
     containers:
     - name: my-container
       image: my-image
       volumeMounts:
       - name: host-volume
         mountPath: /etc/hosts
         subPath: hosts
     volumes:
     - name: host-volume
       configMap:
         name: my-configmap
   ```

3. 将 `configMap` 卷的名称设置为创建的 ConfigMap 的名称，在容器内将卷挂载到 `/etc/hosts` 文件中。

4. 保存并部署该配置文件，这样 Kubernetes 就会在容器内部创建相应的 hosts 映射。

注意：如果需要动态更新 hosts，只需要修改 ConfigMap 中的数据即可，Kubernetes 会自动更新挂载到容器中的 hosts 映射。

通过配置coredns