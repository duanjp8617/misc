1. Use the following command to check the stored config map.
```bash
kubectl get configmap -n kube-system contiv-agent-cfg -o yaml
```

2. k8s ConfigMap can be used to setup environment files in the container. For details, please refer to the contiv-agent-cfg ConfigMap in contiv vpp and how it is used to set up the configuration files in /etc/contiv/ folder of the contiv-vswitch container

3. When contiv-agent starts up, it reads the configuration files from /etc/contiv/ directory, including the /etc/contiv/contiv.conf. 

4. contiv configures a service, which maps port 32379 on each port to master:12379, which is listened by the contiv-etcd container.