# Package Installation

Install necesary packages on Ubuntu including ```libvirt```, ```kvm```, etc. The following command can help:

```shell
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients virtinst cloud-init
```

# Prepare Cloud VM Image

This file contains instructions for building a basic Ubuntu cloud VM image. 

1. Prepare an empty folder, and then execute the following command to create a cloud-config file. 
  * The username the username to log into the VM is always `ubuntu`
  * The password is the configured `password`.
  * The hostname is the configured `hostname`.

```shell
echo '#cloud-config
preserve_hostname: False
hostname: cloudvm
password: pcl
chpasswd: { expire: False }
ssh_pwauth: True' >cloud-config
```

2. Run the following command to create a cloud-config.img CDROM to initialize the VM (need cloud-image-utils package):

```shell
cloud-localds cloud-config.img cloud-config
```

3. Go to website https://mirrors.ustc.edu.cn/ubuntu-cloud-images/, download the Ubuntu 20.04 cloud server image with the name `focal-server-cloudimg-amd64.img  `, rename the image as `cloud-vm.img` and resize the image using the following command:

```shell
qemu-img resize cloud-vm.img +10G 
```

4. Run the following command to create a new VM (need virt-install, will enter an interactive session for the initial bootup, use Ctrl+Shift+] to escape). 

```shell
virt-install --connect=qemu:///system \
 --name cloud-vm \
 --ram 2048 \
 --vcpus=2 \
 --disk cloud-vm.img,device=disk,bus=virtio \
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

7. Cleanup
```shell
virsh shutdown cloud-vm
virsh undefine cloud-vm
rm -f cloud-config*
```

# Launch VMs with the Cloud Image

1. Copy the cloud image to a new file, and then use the following command to launch additional vms:

```shell
sudo virt-install \
     --import \
     --noreboot \
     --name w2 \
     --vcpus 16 \
     --memory 16384 \
     --disk path=$PWD/w2.img,format=qcow2,bus=virtio \
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

3. Change the hostname:
```shell
hostnamectl set-hostname master
```

4. Update the machine id, this is very important for dhcp-based IP address allocation:
```shell
sudo rm /etc/machine-id
sudo systemd-machine-id-setup
```

5. Use the following command to see the name of the interface
```shell
ip link show
```

6. Remove the file in /etc/netplan, add a new file called **01-netcfg.yaml** with the following content, and adjust the name of the interface to the one acquired from step 3:

```shell
network:
  version: 2
  renderer: networkd
  ethernets:
    ens3:
      dhcp4: yes
```

7. Run the command to apply the netplan: 

```shell
sudo netplan apply
```

# Add a Secondary Network

1. The following shell script defines a simple libvirt network xml.
  * The defined netowrk is internal used only, the traffic can not be directed out of the host.
  * The network will be connected to a linux bridge with dhcp enabled.
  * The range of the dhcp should not be conflicted with other existing libvirt networks. 

```shell
<network>
  <name>internal</name>
  <ip address='192.168.123.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.123.2' end='192.168.123.254'/>
    </dhcp>
  </ip>
</network>
```

2. Create a file called `network.xml`, and fill this file with the content from the above shell script.

3. Define this network with the following command:
```shell
virsh net-define network.xml
```

4. Start the newly defined network:
```shell
virsh net-start internal
virsh net-autostart internal
```

5. Check the status of the newly defined network:
```shell
virsh net-list --all
virsh net-edit internal
```

# Add a new network interface to an existing VM

1. Shutdown the VM:
```shell
virsh shutdown master
```

2. Edit the VM config file:
```shell
virsh edit master
```

3. Add the following content to the config file:
```shell
  <interface type='network'>
    <source network='internal'/>
    <model type='virtio'/>
  </interface>
```

4. Open `/etc/netplan/01-confg.yaml` and add the new interface to the network file, and apply this change.
```shell
network:
version: 2
renderer: networkd
ethernets:
    ens3:
      dhcp4: yes
    ens4:
      dhcp4: yes
```

# Replicate more VMs

1. We can replicate more VMs by copying the `cloud-vm.img` file and create additional VMs with the following commands:
```shell
sudo virt-install \
     --import \
     --noreboot \
     --name w2 \
     --vcpus 16 \
     --memory 16384 \
     --disk path=$PWD/w2.img,format=qcow2,bus=virtio \
     --accelerate \
     --network=network:default,model=virtio \
     --network=network:internal1,model=virtio \
     --serial pty \
     --cpu host \
     --rng=/dev/random
```

2. Then update the netplan file to use dhcp to update ip addresses.


# Misc

## Remove the libvirt dhcp leases
```shell
sudo rm var/lib/libvirt/dnsmasq/virbr0.*
```

## Check the libvirt dhcp leaess
```shell
virsh net-dhcp-leases default
```

## Use fixed IP address

1. We can confiure the VM to use static IP address, by updating the `/etc/netplan/01-config.yaml` with the following content:

```shell
network:
  version: 2
  renderer: networkd
  ethernets:
    ens3:
     dhcp4: no
     addresses: [192.168.122.49/24]
     gateway4: 192.168.122.1
     nameservers:
       addresses: [8.8.8.8,8.8.4.4]
    ens10:
     dhcp4: no
     addresses: [192.168.123.90/24]
```
2. It is also possible to set static IP address for a particular NIC mac address, we can do it by configuring the network xml:
```shell
<network>
  <name>default</name>
  <uuid>200bb6c1-7d61-452c-9055-cac37d3b9285</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:a8:4d:a6'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
      <host mac='52:54:00:49:7e:be' ip='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```
