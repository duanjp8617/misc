# SSH to remote host with public key

1. On the local system, execute the following command:
```shell
ssh-keygen
```
This command will generate `~/.ssh/id_rsa` as the private key, and `~/.ssh/id_rsa.pub` as the public key. And the behavior of this command is consistent across different OSes.

2. Copy `~/.ssh/id_rsa.pub` to the remote system. On the remote system, as the public key file to the `authorized_keys` with the following command:
```shell
cat ./id_rsa.pub >> ~/.ssh/authorized_keys
```

3. If we are using vscode, we can then add the following content to the remote config file:
```shell
Host h0
    HostName 192.168.67.29
    User pcl
    Port 2107
    IdentityFile ~/.ssh/id_rsa
```

4. Finally, if the remote machine is a jump-box, we can use the following config to connect to the servers behind the jump-box:
```shell
# Jump box with public IP address
Host jump-box
    HostName 52.179.157.97
    User sana
    IdentityFile ~/.ssh/jumpbox

# Target machine with private IP address
Host target-box
    HostName <IP address of target>
    User sana
    IdentityFile ~/.ssh/target
    ProxyCommand ssh -q -W %h:%p jump-box
```

# How to pull docker images

国内访问docker hub的速度实在是太慢了，几乎大部分的命令都无法正常执行。个人感到比较好用的方法有两个：

## `docker_pull.py`
1. 从网址`https://github.com/NotGlop/docker-drag/blob/master/docker_pull.py`下载`docker_pull.py`文件。

2. 利用`docker_pull.py`文件从指定要下载的镜像名。注意：无法直连，需卦代理。

3. 用下列命令来安装存储在本地的镜像
```shell
docker load -i image.tar
```

## 设置dockerd代理

1. 根据`https://docs.docker.com/config/daemon/systemd/#httphttps-proxy`，创建`/etc/systemd/system/docker.service.d/http-proxy.conf`文件

2. 向文件中写入下列内容（支持socks5 proxy）：
```shell
[Service]
Environment="HTTP_PROXY=socks5://127.0.0.1:1080"
Environment="HTTPS_PROXY=socks5://127.0.0.1:1080"
```

3. 利用下列命令重启docker服务：
```shell
sudo systemctl daemon-reload
sudo systemctl restart docker
```