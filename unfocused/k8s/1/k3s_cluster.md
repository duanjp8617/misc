# 创建k3s集群

以下内容根据`https://www.youtube.com/watch?v=k58WnbKmjdA&t=1703s`以及`https://cloud.tencent.com/developer/article/2264278`整理得到。

* 利用国内源安装k3s，版本为1.26.4。该命令会从国内源进行安装，并将默认的image registry指定为阿里云。

```shell
curl –sfL \
https://rancher-mirror.oss-cn-beijing.aliyuncs.com/k3s/k3s-install.sh | \
INSTALL_K3S_MIRROR=cn sh -s - \
--system-default-registry "registry.cn-hangzhou.aliyuncs.com" \
--write-kubeconfig ~/.kube/config \
--write-kubeconfig-mode 666 \
--disable traefik
```

* 执行完命令后，会在`/usr/local/bin`下生成k3s所需命令。k3s只有一个binary `k3s`，其他命令均为`k3s`的sym link。在启动其他命令时，k3s会根据`argv[0]`的信息判断运行的具体是哪一个命令。

* 查看k3s journal输出：
```shell
journalctl -u k3s
```

* k3s状态信息被存放在`\var\lib\rancher\k3s`目录中，里面有各种被解压的命令，可以使用一些命令进行检查
```shell
find -type f
du -h
```

* 

* 更新containerd mirror:
```shell
cat > /etc/rancher/k3s/registries.yaml <<EOF
mirrors:
  docker.io:
    endpoint:
      - "http://hub-mirror.c.163.com"
      - "https://docker.mirrors.ustc.edu.cn"
      - "https://registry.docker-cn.com"
EOF
```

# 清理k3s集群

* 开启k3s后，所有状态信息会保存在`/var/lib/rancher/k3s`中。为了清除安装在本机中的k3s，可以执行下列命令：
```shell
# systemctl for stoping the currently-running k3s service
systemctl stop k3s
# a script for wiping out the exitsing system settings
k3s-killall.sh
# remove the directory for storing the k3s states
rm -rf /var/lib/rancher/k3s
```

```shell
curl –sfL \
https://rancher-mirror.oss-cn-beijing.aliyuncs.com/k3s/k3s-install.sh | \
INSTALL_K3S_MIRROR=cn sh -s agent
```