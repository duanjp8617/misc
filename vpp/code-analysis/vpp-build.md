# Prepare a ssh-connectable docker contaienr

1. Download vpp git repository and checkout the version that we wish to build.

2. Create a docker container with the following command:
```shell
sudo docker run --privileged --entrypoint /bin/bash -v /host_path/to/vpp:/container_path/to/vpp --name vpp-build -it -d ubuntu:18.04
```
This command will create a privileged container (it can do something evil) with the vpp source directroy from the host mapped to "/container_path/to/vpp" directory in the container.

3. Login to the container bash with the following command:
```shell
sudo docker exec -it vpp-build bash
```

4. Install openssh-server.
```shell
apt-get update
apt install openssh-server
apt install ssh
```

5. Install sudo command.
```shell
apt install sudo
```

6. Install net-tools utility.
```shell
apt install net-tools
```

7. Enable ssh service
```shell
service ssh start
```

8. Add a user with sudo privilege.
```shell
adduser username
usermod -aG sudo username
```

9. Remember the IP address of this container and logout.

# Build vpp

1. Install build-essential
```shell
apt install build-essential
```

2. Change to the VPP source directory.

3. Install dependencies.
```shell
make install-dep
```

4. Instsall external dependencies. If this is not executed by hand, the build process may fail.
```shell
make install-exp-dep -j
```

5. Build a release version, you can also build a debug version with debug sysbols included using the default VPP make system. Tips: VPP code base is extremely large, so please build with all the cores on the machine.
```shell
make build-release -j
```

# Execute VPP in container

1. Reserve huge pages.
```shell
echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
```

2. Install igb_uio kernel module.
```shell
apt install dpdk-igb-uio-dkms
```

3. Run vpp using vpp's default build system
```shell
make run-release STARTUP_CONF=/path/to/startup.conf
```