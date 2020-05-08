1.  Create a cloud-config file with the following contents (the username to log into the VM is always ubuntu, the password is the configured password):

#cloud-config
preserve_hostname: False
hostname: xx
password: xx
chpasswd: { expire: False }
ssh_pwauth: True

2. Run the following command to create a cloud-config.img CDROM to initialize the VM (need cloud-image-utils package):

cloud-localds cloud-config.img cloud-config

3. Download a ubuntu cloud image from https://mirrors.ustc.edu.cn/ubuntu-cloud-images/server/server/server/daily/server/bionic/20190731/bionic-server-cloudimg-amd64.img, then rename the image as xx

4. Run the following command to create a new VM (need virt-install):

virt-install --connect=qemu:///system \
 --name cloud-vm \
 --ram 2048 \
 --vcpus=2 \
 --os-type=linux \
 --disk cloud-vm.img,size=20,device=disk,bus=virtio \
 --disk cloud-config.img,device=cdrom \
 --graphics none \
 --import

5. eject the initialization image of cloud init from the VM

 virsh change-media cloud-vm hda --eject --config

6. Log in to the machine

7. Change the /etc/apt/sources.list in to the following:

deb https://mirrors.ustc.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse

8. Run the following command

sudo apt-get update
sudo apt-get install docker.io

9. Upload the vmd bin file to the VM and save the file under

$HOME/docker

10. Create a /etc/systemd/system/rc-local.service file with the following command

ln -fs /lib/systemd/system/rc-local.service /etc/systemd/system/rc-local.service

11. Create /etc/rc.local file, change the access right of the file with the following command:

chmod 755 /etc/rc.local

12. Add the following lines to /etc/rc.local 

#!/bin/bash
docker rm -f $(docker ps -aq)
docker run -d -v /home/ubuntu/docker:/docker -p 50051:50051 ubuntu:18.04 /docker/main

13. Upload the vmd executable file to $HOME/docker

14. Upload the image to openstack. Prepare a key pair in the openstack, and configure the VM to 
use the key pair when launching with gophercloud.