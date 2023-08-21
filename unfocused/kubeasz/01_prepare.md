## Chrony

Chrony doesn't work on the current VM setup.

## Deploy

An initial step to deployment environment for the localhost

- Generate `ca-config.json` and `ca-csr.json` in `/<cluster_dir>/ssl`.
  - `ca-csr.json` is the certificate signing request file.

- Using the `cfssl` and `cfssljson` tools, generate the `ca.pem` and `ca-key.pem`
  - These two files can be used as CA to sign different certificates?

- Genereate `kubectl.kubeconfig`:
  - Generate `admin` user's `admin-key.pem` and `admin.pem` using the self-signed CA. 
  - Then gradually fill in the `kubectl.kubeconfig` file with the `kubectl` command:
    - Set cluster with a specified `<cluster_name>`
    - Set credentials for the `admin` user with the certificate `admin.pem` and the key `admin-key.pem`.
    - Set the context name `<context_name>` for `admin` user under the cluster `<cluster_name>`
    - Use the context `<context_name>`

- Generate `kube-proxy.kubeconfig`:
  - Generate `kube-proxy.pem` and `kube-proxy-key.pem` using the self-signed CA.
  - Then gradually fill in the `kube-proxy.kubeconfig` file with the `kubectl` command:
    - Set cluster to `kubenetes` with the self signed CA
    - Set credentials for the `kube-proxy` user with the certificate `kube-proxy.pem` and the key `kube-proxy-key.pem`.
    - Set the context name `default` for `kube-proxy` user under the cluster `kubernetes`
    - Use the context `default`

- Repeat the same procedure for both `kube-scheduler` and `kube-controller-manager`=
  - The user name is prefixed with `system:`, therefore `system:kube-scheduler` and `system:kube-controller-manager`
## Prepare

Perform an initial configuration for each node machine.

First, apply debian-based configuration: 
- Instal necessary debian packages on each node
- Coonfigure the system journal, so that it does not consume to much disk space.

Apply common configurations:
- Disable system swap
- Load some important kernel modules
- Configure system parameters
- Populate the host names in the `/etc/hosts` file
  - First, perform a reduce action by collecting all the IP address to hostname mappping on master node 0
  - Then perform a broadcast action by copying the `/etc/hosts` file on the master node 0 to all the nodes in the cluster.

At this time, the node should be k8s ready.
