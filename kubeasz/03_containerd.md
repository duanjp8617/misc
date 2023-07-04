## Install containerd

- Copy containerd binaries to `/opt/kube/bin`
  - `containerd` binaries are stored inside a director. 
  - `crictl` is used to query the `containerd` service

- Setup the config files for `containerd` and `crictl`
  - By default, kubeasz sets up the China mirrors for the `containerd`.
  - The `crictl` config file just configures to access the `containerd` domain socket.

