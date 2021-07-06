1. Build on a worker node.

2. Execute the docker/development/build.sh to create a new contivvpp/vswitch image.

3. Shutdown the contiv-vswitch pod via
```bash
kubectl delete pods contiv-vswitch-5k6lv -n kube-system
```