#/bin/sh

# The ubuntu version must be xenial, or it can not be installed
ubuntu=xenial

# coredns 1.8.0 is not available on alicloud, so we have to stick to an older version
# I don't know how to fix it yet
version=1.17.17-00

apt-get install docker.io -y
apt-get install -y apt-transport-https curl
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-$ubuntu main" >  /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet=$version kubeadm=$version kubectl=$version
