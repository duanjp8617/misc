#/bin/sh

swapoff -a
kubeadm config images pull  --image-repository=registry.aliyuncs.com/google_containers
kubeadm init --token-ttl 0 --pod-network-cidr=10.244.0.0/16 --node-name=`hostname`   --image-repository=registry.aliyuncs.com/google_containers | tee kubeadm_init.txt