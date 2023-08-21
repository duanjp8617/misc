```shell
apt install -y bash git gcc musl-dev vim less file curl wget ca-certificates jq \ 
zlib1g-dev tar zip squashfs-tools npm coreutils python3 python3-pip libssl-dev libffi-d
ev libseccomp-dev \ 
make libuv1-dev sqlite3 libselinux1-dev \ 
zstd pigz build-essential binutils btrfs-progs gawk \
mingw-w64 pkg-config
```

Additional packages to be installed:
`docker`, `linux-headers`, `yq`

```shell
wget https://github.com/aquasecurity/trivy/releases/download/v0.41.0/trivy_0.41.0_Linux-64bit.tar.gz
tar -zxvf trivy_0.41.0_Linux-64bit.tar.gz 
mv trivy /usr/local/bin
```

```shell
export HTTPS_PROXY=127.0.0.1:8080
export HTTP_PROXY=127.0.0.1:8080
export http_proxy=127.0.0.1:8080
export https_proxy=127.0.0.1:8080
```ls


```shell
cd ~/go
curl -sL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.51.2
```