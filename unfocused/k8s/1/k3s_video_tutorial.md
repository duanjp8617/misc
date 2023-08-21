The following content is summarized from the video: `https://www.youtube.com/watch?v=k58WnbKmjdA&t=1703s`. It is intended as a tutorial for k3. 

# K3s server

## Install
On a linux machine with root access, execute the following command to install k3s:
```shell
curl –sfL \
https://rancher-mirror.oss-cn-beijing.aliyuncs.com/k3s/k3s-install.sh | \
INSTALL_K3S_MIRROR=cn sh -s - \
--system-default-registry "registry.cn-hangzhou.aliyuncs.com" \
--write-kubeconfig ~/.kube/config \
--write-kubeconfig-mode 666 
```

This will download the k3s install script and install all the required binaries on the host machine. To be more specific, executing the install script will generate the following changes:
* It installs the k3s binary at `\usr\local\bin`. k3s itself is a multi-call binary, so it will only install one binary. the rest of the commands presented in the `\usr\local\bin` are just sym-links to the k3s binary. When invoking these commands from the shell, the k3s binary checks the actual command invoked using the `argv[0]` variable.
* The k3s server saves all the state information in `\var\lib\rancher\k3s`. So if one would like to wipe out the k3s installation, he should remove the `\var\lib\rancher\k3s` as well. 
* The install script creates systemd lanuch script in `/etc/systemd/system`. The input parameters that are used to launch the k3s service is configured using these scripts. Don't forget to reload the systemd with `systemctl daemon-reload`q

k3s server prints the journal to the linux journal system. To check these journals, simply use
`journalctl -u k3s`

## Update containerd repository

This advice is not from the youtube video, but from `https://cloud.tencent.com/developer/article/2264278`. 

k3s uses containerd to manage the containers and images. To update the repository used by containerd, one can execute the following command:
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

Note: **all the nodes including the k3s agents should be configured with the registry**.

## Commands for checking the installation size

In `/var/lib/rancher/k3s`, use the following command to check the actual files and see the actuall content size downloaded by the k3s server:
```shell
find -type f
du -h
```

## Shutdown k3s server

```shell
# systemctl for stoping the currently-running k3s service
systemctl stop k3s
# a script for wiping out the exitsing system settings
k3s-killall.sh
# remove the directory for storing the k3s states
rm -rf /var/lib/rancher/k3s
```

To restart the installed k3s, just use `systemctl start k3s`

# K3s agent

## k3s agent setup

On the k3s server, get the server token from `/var/lib/rancher/k3s/server/node-token`, get an accessible IP addreess of the k3s server.

On the agent server, create the file `/etc/rancher/k3s/config.yaml`. Add token and server IP address to the config file.

```shell
token: "TOKEN"
server: "https://IP:6443"
```

Use the following command to set up the k3s agent:
```shell
curl –sfL \
https://rancher-mirror.oss-cn-beijing.aliyuncs.com/k3s/k3s-install.sh | \
INSTALL_K3S_MIRROR=cn sh -s agent
```

On the k3s server, we can watch the node join:
```shell
kubectl get node --watch
```

Some information about how the agent connects to the server:

* Use `ss -tl` on the agent to list the available connections. `ss` stands for `socket statistics`. Using this command, we can see all the tcp sockets listening on the agent. 
    * The key services of the k3s-agent, including kubelet, kube-proxy only listens on local host. 
    * The agent listens on the public 10250 port, but this port is fully secured with tls. 
    * The agent maintains an out-bound connection to the server and the server uses this connection to talk to the agent directly. 
* On the k3s server, we can create an http request to the agent with `curl -k -v https://IP:10250`, the connection will be blocked, indicating that this is a fully secured connection. 
* On the agent, we can use the following iptable command to block any inbound connections except from the localhost to the port 10250, with the following command:
```shell
iptables -I INPUT -m state --state new -p tcp --dport 10250 \! -s 127.0.0.1 -j DROP
```
* If the above command is executed on the agent, the on the k3s server, you will not be able to make any TCP connections to the port 10250. However, due to the use of the reverse proxy, the agent is still accessible from the k3s server. To do this, we can find out a pod running inside the agent and accedss this pod:
```shell
kubectl get pod -A -o wide
kubectl exec -it -n kube-system PODNAME sh
``` 
* On the agent, we can check the new connections with `ss -an | grep 10250`

* Since we have shutdown the port 10250 on the agent, we can now restart the agent, and see that the agent can not go back alive on the master node. 
    * On the agent, run `systemctl restart k3s-agent`
    * On the server, watch the status of the node with `watch kubectl top node`

* We can now delete the firewall rule, and bring the agent back online
    * On the agent, list the firewall rulse with `iptables -L INPUT --line-numberes`.
    * Then, delete the rule that block inbound traffic to port 10250 with `iptables -D INPUT LINENUM`

# Etcd management


# CoreDNS