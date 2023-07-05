openconnect-proxy docker image
==============================

Packages an OpenConnect VPN client with an authenticating HTTP proxy to provide 
access to the VPN via the proxy. 

Example usage:
```
# docker run -it -p 8123:8123 -v $PWD/oc.pw:/tmp/oc.pw -e OPENCONNECT_PASSWORD_FILE=/tmp/oc.pw -e OPENCONNECT_USERNAME=oc_user -e OPENCONNECT_GROUP=oc_group -e OPENCONNECT_HOST=vpn.example.com -e PROXY_USERNAME=puser -e PROXY_PASSWORD=secret quay.io/wtsi-hgi/openconnect-proxy
```

Substitute the real values for your AnyConnect VPN credentials in place of oc_user, oc_group, and vpn.example.com; and create a file (in this case `/tmp/oc.pw`) containing the associated password.

While the above container is running, you should be able to use the docker host an http proxy to access resources via the VPN. 

For example, you could set an http_proxy environment variable and use wget:
```
# export http_proxy=http://puser:secret@dockerhost.example.com:8123/
# wget http://protectedhost.example.com/
```

- `-p 8123:8123`: expose the 8123 port used by the polipo http proxy
- `-e PROXY_USERNAME=puser -e PROXY_PASSWORD=secret`" two environment variables to define the HTTP proxy usernam and password
- 

```shell
docker run --name ocproxy -it -d -p 8123:8123 -e PROXY_USERNAME=puser -e PROXY_PASSWORD=secret ocproxy:latest
```