## Install kubeasz

- Download the `ezdown` file from the kubeasz github repo `https://github.com/easzlab/kubeasz`.
- Execute `ezdown -D`, this will download all the required files for kubeasz.
    - This commmand must be executed as root.
    - Everything will be downloaded to `/etc/kubeasz`, which is the default kubeasz working directory.
    - The version of the downloaded files can be configured by editing the `ezdown`
    - `ezdown` will try to install docker and download everything as docker images, and then copy the binaries from the containers to local directories.
    - If docker is already installed, `ezdown` will not re-install docker. Make sure that you set the same docker registries as indicated by the `ezdown`.

## Prepare install VMs

Follow the instructions in `/k8s/0/0_prepare_environment.md`.

## Prepare a new cluster

- `./ezctl new <cluster_name>`, this will setup cluster files in `/clusters/<cluster_name>`
    - If ansible is not installed, ezctl will ask you to install ansible first with `pip install ansible`

- Set up ssh-key login from the deploy machine to all the node machines. 
    - The ssh key should be distributed under the root users for all the machines.
    - Refer to `/k8s/-1_misc.md` for instructions

- Update the generated cluster host file, fill the ip addresses of different hosts

- Test access to different hosts
    - `ansible -i hosts etcd -m ping -v`: ping all the etcd hosts
    - `ansible -i hosts kube_master -m ping -v`: ping all the kube masters, which are usually co-located with the etcd

- Additional setups: