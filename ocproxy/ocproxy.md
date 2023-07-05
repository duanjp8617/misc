# Build ocproxy image

Switch to the current working directory, and execute the following command to build the container image `ocproxy:v1`:

```shell
sudo docker build -t ocproxy:v1 .
```

# Launch the ocproxy container

Execute the following command to launch the ocproxy container. Substitute `puser` with HTTP proxy username, `secret` with HTTP proxy password, `www.vpn.com` with your vpn address.

```shell
sudo docker run --name ocproxy -it -d -p 8123:8123 -e PROXY_USERNAME=puser -e PROXY_PASSWORD=secret -e OC_HOST=www.vpn.com ocproxy:<tag>
```

# Connect to the VPN host

Log in to the container:

```shell
sudo docker attach ocproxy
```

Execute `/docker/polipo-proxy.sh` and `/docker/openconnect.sh`

The polipo http proxy listens on address `0.0.0.0:8123`

The `openconnect.sh` will prompt you to input your vpn username and password.

Exit the container with `Ctrl + P` and `Ctrl + Q`.

# Using the ocproxy

1. Set proxy environment variable: `export http_proxy=http://puser:secret@dockerhost.example.com:8123/`
2. Use proxychains, update `/etc/proxychains4.conf`
```
[ProxyList]
# add proxy here ...
# meanwile
# defaults set to "tor"
http 127.0.0.1 8123 puser secret
```