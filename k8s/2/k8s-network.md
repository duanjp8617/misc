# Basic k8s operation command

To launch a new pod and keep the foreground shell:
```shell
kubectl run -it --image=IMAGENAME PODNAME
```

To attach to an existing pod with shell:
```shell
kubectl exec -it PODNAME -- sh
```

To delete a pod:
```shell
kubectl delete pod PODNAME
```

