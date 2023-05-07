# Package Installation

Install necesary packages on Ubuntu including ```libvirt```, ```kvm```, etc. The following command can help:

```shell
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients virtinst
```

# Prepare Cloud VM Image

This file contains instructions for building a basic Ubuntu cloud VM image, tested on Ubuntu 18.04 LTS

1.  Create a cloud-config file with the following contents (the username to log into the VM is always ubuntu, the password is the configured password):

```shell
#cloud-config
preserve_hostname: False
hostname: xx
password: xx
chpasswd: { expire: False }
ssh_pwauth: True
```

2. Run the following command to create a cloud-config.img CDROM to initialize the VM (need cloud-image-utils package):

```shell
cloud-localds cloud-config.img cloud-config
```

3. Download a ubuntu cloud image from https://mirrors.ustc.edu.cn/ubuntu-cloud-images/server/server/server/daily/server/bionic/20190731/bionic-server-cloudimg-amd64.img, rename the image as cloud-vm.img and resize the image using the following command:

qemu-img resize cloud-vm.img +10G 

4. Run the following command to create a new VM (need virt-install, will enter an interactive session for the initial bootup, use Ctrl+Shift+] to escape). Here, the size=20 indicates the size of the disk, I don't know if this option really impact the size of the disk in practice:

```shell
virt-install --connect=qemu:///system \
 --name cloud-vm \
 --ram 2048 \
 --vcpus=2 \
 --os-type=linux \
 --disk cloud-vm.img,size=20,device=disk,bus=virtio \
 --disk cloud-config.img,device=cdrom \
 --graphics none \
 --import
```

5. Disable cloud-init using the following command: 

```shell
sudo touch /etc/cloud/cloud-init.disabled
```

6. eject the initialization image of cloud init from the VM

```shell
virsh change-media cloud-vm hda --eject --config
```

7. Shutdown the VM
```shell
virsh shutdown cloud-vm
```

# Launch VMs with the Cloud Image

1. Copy the cloud image to a new file, and then use the following command to launch additional vms:

```shell
sudo virt-install \
     --import \
     --noreboot \
     --name worker2 \
     --vcpus 4 \
     --memory 8192 \
     --disk path=/home/djp/workspace/vms/worker2.img,format=qcow2,bus=virtio \
     --accelerate \
     --network=network:default,model=virtio \
     --serial pty \
     --cpu host \
     --rng=/dev/random
```

2. After step 1, a new VM will be defined, start it with the following command:

```shell
virsh start master
```
And then connect to this VM with the following command:
```shell
virsh console master
```

3. Use the following command to see the name of the interface
```shell
ip link show
```

4. Remove the file in /etc/netplan, add a new file called **01-netcfg.yaml** with the following content, and adjust the name of the interface to the one acquired from step 3:

```shell
network:
  version: 2
  renderer: networkd
  ethernets:
    ens3:
      dhcp4: yes
```

5. Run the command to apply the netplan: 

```shell
sudo netplan apply
```

6. Finally, restart the VM, and log in to the VM, use the following command to acquire the IP address of the network interface:
```shell
ip addr
```

