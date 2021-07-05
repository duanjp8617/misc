#/bin/sh

swapoff -a
kubeadm config images pull  --image-repository=registry.aliyuncs.com/google_containers
kubeadm init --token-ttl 0 --pod-network-cidr=10.0.0.0/8 --node-name=`hostname`   --image-repository=registry.aliyuncs.com/google_containers | tee kubeadm_init.txt

# choose one of the two methods to setup kubectl execution environment
# echo "KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/environment && source /etc/environment # for future shell
# export KUBECONFIG=/etc/kubernetes/admin.conf # for current shell

# After the master has been initialized, create $HOME/.kube/config, copy the content of /etc/kubernetes/admin.conf to $HOME/.kube/config. Then change ownership and group of $HOME/.kube/config to the currrent user.

# Master taint is also necessary
# kubectl taint nodes --all node-role.kubernetes.io/master-

# Finally, execute the following command:
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
# This will initialize the CNI for the cluster and then the status of the nodes would become ready.
# Remember to update the "Network" field of net-conf.json, it must be the same as the argument passed to --pod-network-cidr option when initializing the master.
