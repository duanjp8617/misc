# k3s源码编译

k3s在`make`过程中使用了一个自研的构建系统dapper。dapper在编译k3s的时候，会首先生成一个基于`golang:alpine`的docker image。之后，dapper会生成基于这个image的容器，并在容器中进行编译。

这样做的好处是编译过程非常干净，不会在系统里产生任何其他依赖。这样做到坏处是，编译构建过程的中间结果每次都得不到保留，不方便进行增量编译和源码阅读（不知道我理解的是否正确）。

因此，我个人认为一个比较好的构建方式，是不使用k3s目中提供的`Makefile`，而是由自己手动构建全套k3s系统。下面是一个初步的流程（注意，在国内网络环境下，构建过程的命令通常需要使用socks5代理）。

## 1. 安装docker及下载docker镜像

1. k3s编译依赖docker，所以必须在宿主机中安装docker。参见官方安装教程`https://docs.docker.com/engine/install/ubuntu/`。同时，参考`https://docs.docker.com/engine/install/linux-postinstall/`，将当前user加入docker group。

2. k3s编译过程过程依赖基础镜像`golang:1.20.3-alpine3.17`。在国内网络环境下需配置`dockerd`代理后手动拉取。代理配置方式参考官方文档：`https://docs.docker.com/config/daemon/systemd/#httphttps-proxy`。注意，`dockerd`默认支持socks5代理，所以可以在`http-proxy.conf`文件中使用下列代理地址：
```shell
[Service]
Environment="HTTP_PROXY=socks5://127.0.0.1:1080"
Environment="HTTPS_PROXY=socks5://127.0.0.1:1080"
```

3. 拉取`golang:1.20.3-alpine3.17`镜像：
```shell
docker image pull golang:1.20.3-alpine3.17
```

## 2. 通过dapper构建k3s编译镜像

1. 下载k3s源代码，`--depth 1`很重要，我以前都是傻傻的把整个commit记录拖下来。
```shell
git clone --depth 1 https://github.com/k3s-io/k3s.git
```
注意，该教程基于下列commit记录：`9bcfac8b88`。

2. 仿照`Makefile`中的命令格式下载dapper可执行文件：
```shell
curl -sL https://releases.rancher.com/dapper/v0.6.0/dapper-$(uname -s)-$(uname -m) > .dapper
chmod +x .dapper
```

3. 对`Dockerfile.dapper`进行修改，在`apk`安装命令前添加下列命令，以将apk更改为国内源（apk命令无法识别代理对应的环境变量）。
```shell
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
```
同时，考虑在`apk`命令后安装`proxychains-ng`包，以方便后续在容器中启动代理。

4. 为`docker build`设置代理，设置步骤参考官方文档`https://docs.docker.com/network/proxy/`。注意，`docker build`仅支持http代理，因此`config.json`文件应为下列格式：
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

5. 下面一步，需要使用工具开启http代理。本人系统里为socks5代理，因此用`gost`实现http代理到socks5代理的转换。首先下载并解压`gost`:
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

6. 执行`dapper`构建命令：
```shell
./.dapper --build
```
命令执行完毕后，会生成名为`k3s:master`，大小为1.93GB的镜像。该镜像貌似会在系统里进行缓存，只要按照2.3的方法修改`Dockerfile.dapper`文件，即使删除原始k3s目录并重新下载后，k3s master也可以瞬间完成构建。

## 3. 手动启动dapper编译容器

1. 执行下列命令，手动启动dapper编译容器
```shell
 ./.dapper -s -m bind
```
该命令会以`k3s:master`为基础创建一个容器，并将`./k3s`目录映射到容器内部。

可以通过`Ctrl + P`,`Ctrl + Q`来从容器中detach，也可通过`docker attach $container`来重新接入容器。

2. 在之前的操作中，我们为容器设置了与代理相关的环境变量，因此，我们在编译容器中也会收到这些环境变量的影响。我们可以取消与代理相关的环境变量：
```shell
unset HTTPS_PROXY
unset HTTP_PROXY
unset http_proxy
unset https_proxy
```
此时，容器中将不再收到代理的影响。
若想恢复使用代理，可重新定义相关环境变量
```shell
export HTTPS_PROXY=172.17.0.1:8080
export HTTP_PROXY=172.17.0.1:8080
export http_proxy=172.17.0.1:8080
export https_proxy=172.17.0.1:8080
```

3. 设置代理环境变量，并执行下列命令，下载k3s编译所必须的额外依赖：
```shell
./scripts/download
```

4(deprecated). 取消代理设置，并设置Go代理
```shell
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
```
go env保存在`$HOME/.config/go/env`中。

5. 执行`generate`命令，生成相关文件
```shell
./scripts/generate
```

6. 编译k3s
```shell
./scripts/build
```

## 4. 利用vscode远程登录来登入k3s容器