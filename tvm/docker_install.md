# 1. Configure Docker

## 安装docker及下载docker镜像

1. k3s编译依赖docker，所以必须在宿主机中安装docker。参见官方安装教程`https://docs.docker.com/engine/install/ubuntu/`。同时，参考`https://docs.docker.com/engine/install/linux-postinstall/`，将当前user加入docker group。

2. (docker拉取镜像配置)k3s编译过程过程依赖基础镜像`golang:1.20.3-alpine3.17`。在国内网络环境下需配置`dockerd`代理后手动拉取。代理配置方式参考官方文档：`https://docs.docker.com/config/daemon/systemd/#httphttps-proxy`。注意，`dockerd`默认支持socks5代理，所以可以在`http-proxy.conf`文件中使用下列代理地址：
```shell
[Service]
Environment="HTTP_PROXY=socks5://127.0.0.1:1080"
Environment="HTTPS_PROXY=socks5://127.0.0.1:1080"
```

3. (docker build代理)为`docker build`设置代理，设置步骤参考官方文档`https://docs.docker.com/network/proxy/`。注意，`docker build`仅支持http代理，因此`config.json`文件应为下列格式：
```shell
{
 "proxies": {
   "default": {
     "httpProxy": "172.17.0.1:8080",
     "httpsProxy": "172.17.0.1:8080"
   }
 }
}
```
`172.17.0.1`为`docker0`端口的默认地址。可以用下列命令来检测容器中是否可以访问代理：
```shell
docker run --rm golang:1.20.3-alpine3.17 sh -c 'env | grep -i  _PROXY'
```

4. 下面一步，需要使用工具开启http代理。本人系统里为socks5代理，因此用`gost`实现http代理到socks5代理的转换。首先下载并解压`gost`:
```shell
wget https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz
gzip -d gost-linux-amd64-2.11.5.gz
mv gost-linux-amd64-2.11.5 gost
chmod +x gost
```

之后利用下列命令在后台启动`gost`(假设socks5代理监听`127.0.0.1:1080`):
```shell
./gost -L=http://:8080 -F=socks5://127.0.0.1:1080
```

## Setup docker mirror

- Follow the instruction of `kubeasz`, set the docker mirror to the following:
  - Change `/etc/docker/daemon.json` to the following:
    ```shell
    {
        "registry-mirrors": [
                "https://docker.nju.edu.cn/",
                "https://kuamavit.mirror.aliyuncs.com"
        ]
    }
    ```
  - Reload the docker daemon:
    ```shell
    systemctl daemon-reload
    systemctl restart docker
    ```
- These registires can help us download images faster

## Something About Docker Command Line Arguments

Summarize some useful docker command line arguments. Append new argument if I found it interesting.


`--rm`:

This option automatically removes the container after the container finish executing. Examples:
- `sudo docker run -v /tmp:/tmp ubuntu:22.04 ls /tmp` 
  - There is a remaining container which can be check by `sudo docker ps -a`
- `sudo docker run --rm -v /tmp:/tmp ubuntu:22.04 ls /tmp`
  - There is no remaining container

`-v <local host dir>:<container dir>`:

This option maps local host directory to the container directory.

`-it`:

`i` and `t` should appear together. It means that the container is used in an interactive mode. Examples:
- `sudo docker run --rm -v /tmp:/tmp -it ubuntu:22.04`
  - A interactive shell is opened for this container

`-d`:

Run the container in a detached mode in the background.
Example:
- `sudo docker run --rm -v /tmp:/tmp -it -d ubuntu:22.04`

`--name <container name>`:

Specify a container name for the container.

`--net <host/xxx>`:

`--net host` forces the container to share the host network with the host machine.

`--priviledged`:

The container becomes a priviledged one, and can be used just like the host machine.

## Other useful commands to operate docker

`sudo docker attach <container name>`:

Attach to the terminal of a running container.

`sudo docker exec <-it> <container name> <command>`:

Execute command inside the continaer.

`sudo docker start <container name>`:

Start an exited container.

`Ctrl+P` followed by `Ctrl+P`:

Detach from an interactive container.

# 2. Build the TVM ci docker image

It has 76 build tasks. Without a good proxy, it is not possible to build. 

1. Configure the proxy for docker build. Note that this is different from setting up the `dockerd` proxy.

- 为`docker build`设置代理，设置步骤参考官方文档`https://docs.docker.com/network/proxy/`。注意，`docker build`仅支持http代理，因此将下列内容添加至`~/.docker/config.json`文件：
    ```shell
    "proxies": {
        "default": {
            "httpProxy": "http://172.17.0.1:8080",
            "httpsProxy": "http://172.17.0.1:8080"
        }
    }
    ```
- `172.17.0.1`为`docker0`端口的默认地址。可以用下列命令来检测容器中是否可以访问代理：
    ```shell
    docker run --rm golang:1.20.3-alpine3.17 sh -c 'env | grep -i  _PROXY'
    ```

2. Set up the HTTP proxy in the host machine. Since I use socks5 proxy, I need a proxy conversion:

- 下面一步，需要使用工具开启http代理。本人系统里为socks5代理，因此用`gost`实现http代理到socks5代理的转换。首先下载并解压`gost`:
    ```shell
    wget https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz
    gzip -d gost-linux-amd64-2.11.5.gz
    mv gost-linux-amd64-2.11.5 gost
    chmod +x gost
    ```

- 之后利用下列命令在后台启动`gost`(假设socks5代理监听`127.0.0.1:1080`):
    ```shell
    ./gost -L=http://:8080 -F=socks5://127.0.0.1:1080
    ```

3. Then we can build the ci images
- `ci_cpu` [Failed]: the build process stucks at `ubuntu_install_papi.sh`, as we can't establish connection to bitbucket.
- `ci_minimal` [Failed]:  the build process stucks at `ubuntu_install_sccache.sh`

# 3. Using the pre-built docker image [Failed]

- First, setup a proxy to pull the docker image:
  - Add `{ "registry-mirrors": [ "https://dockerproxy.com" ] }` to `/etc/docker/daemon.json`. This is the best proxy I have ever tried, we can always use this proxy.
  - Restart the docker daemon with `systemctl daemon-reload` and `systemctl restart docker`

- Then we can pull the pre-built images from tlcpack
  - [Failed] However, since all the pre-built images have huge size, the pulling process always stuck at sometime and restarts. 

# 4. Prepare my own image for compiling tvm
