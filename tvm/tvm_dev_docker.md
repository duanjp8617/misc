# 1. Build the TVM ci docker image

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

# 2. Using the pre-built docker image [Failed]

- First, setup a proxy to pull the docker image:
  - Add `{ "registry-mirrors": [ "https://dockerproxy.com" ] }` to `/etc/docker/daemon.json`. This is the best proxy I have ever tried, we can always use this proxy.
  - Restart the docker daemon with `systemctl daemon-reload` and `systemctl restart docker`

- Then we can pull the pre-built images from tlcpack
  - [Failed] However, since all the pre-built images have huge size, the pulling process always stuck at sometime and restarts. 

# 3. Prepare my own image for compiling tvm

- Switch to this directory.
- Use `download.sh` to download dependencies and tvm source
- `sudo docker build -f Dockerfile.cpu_base -t tvm_dev:v1 .` to build the docker image
- `sudo docker run -it -d --name tvm_dev -v $PWD/tvm:/workspace/tvm tvm_dev:v1`

# 4. Compile TVM inside the container

- Follow the instruction at `https://tvm.apache.org/docs/install/from_source.html` 
  - `mkdir build`
  - `cp ./cmake/config.cmake ./build`
  - update `set(USE_LLVM "llvm-config-14 --link-static")` in the `config.cmake` file
  - `cmake .. && make -j` 
  - After build, we can just set two global environment variables in the `~/.bashrc` for the python environment to know where the tvm is:
    ```
    export TVM_HOME=/workspace/tvm
    export PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}
    ```
  - this should complete the build process for a cpu-only environment

# 5. Remote development with vscode 

- Use the following command to add the current user to the docker group:
  ```
  sudo usermod -aG docker $USER
  ```
- Install a series of useful extentions:
  - `Dev Container` extention for development inside the container
  - `Python` extention for working with tvm's python
- Open up a work space of the dev container
  - The container is built with a python venv located at /venv, so first configure `Python` extention to search for this venv.
    - Add `/venv` to `Python Venv Path` in the settings. 

