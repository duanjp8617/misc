# DPDK compilation
1. I have only tested DPDK on ubuntu 18.04/20.04. Other Linux distributions are also supported, but 
I have never tested on those distributions.

2. Go to http://core.dpdk.org/download/ and download the DPDK source code. I recommend the LTS version, like DPDK 20.11.3(LTS).

3. Uncompress the DPDK souce file. Before building the source file, you need to check whether you have installed required packages on your sysetm.
    * DPDK relies on meson and ninja to perform the build, so you need to install meson and ninja on your system first.
    * The build-essential package should also be installed on ubuntu.
    * If you are using the Mellanox Connectx 3/5 NIC, then you should install the Mellanox drivers.

4. Follow these instructions to build DPDK.
```shell
  tar xf dpdk.tar.gz
  cd dpdk
  # This command configures the DPDK source file and cretaes
  # a build directory.
  meson build
  cd build
  # The ninja command automatically builds everything for you
  ninja
```

# Background Knowledge About DPDK.

1. Linux kernel: Interrupt-driven network packet processing 
    * a lot of overhead for context switching
    * generate packets from one machine to another, and show the kernel interrupt overhead.
    * Use this command: ``` sudo dpdk-testpmd -l 0,1 -n 4 -- -i --eth-peer=0,50:6b:4b:5c:68:40 --forward-mode=txonly --portlist=0 --txpkts=80```

2. NIC driver hijacking: the DPDK PMD driver.

3. Poll-mode packet processing.

4. Special packet buffers and huge page memory.

5. Prevent kernel thread scheduling.

# Physical Testbed

1. Make sure that you have set up the hugepages in your system. You can use the provided dpdk/usertools/dpdk-hugepages.py script to configure hugepages.

2. Make sure that you have bond the NIC drivers to the DPDK PMD driver.
    * For this demo, we are using Mellanox NIC, and we don't need to bind Mellanox NIC to PMD driver.
    * If you are using Intel NIC, you have to bind the NIC to PMD driver, you can do this using the provided dpdk/usertools/dpdk-devbind.py script.

3. On the receiver, execute the following command:

```shell
cd ~/dpdk-stable-20.11.3/build/app
sudo ./dpdk-testpmd -l 3,4 -n 4 -- -i
set fwd rxonly
start
```

Use the following command to check the number of packets received:
```
show port stats all
```

4. On the sender, execute the following command:
```shell
cd ~/dpdk-stable-20.11.3/build/app
sudo dpdk-testpmd -l 3,4 -n 4 -- -i --eth-peer=0,50:6b:4b:5c:68:40 --forward-mode=txonly --portlist=0 --txpkts=80
start
```

# Single Machine Testbed.

1. Install VPP following the instructions on: https://fd.io/docs/vpp/v2101/gettingstarted/installing/ubuntu.html

2. Configure the VPP by editing the /etc/vpp/startup.conf
```shell
main-core 0
corelist-workers 1
```

3. Start VPP with the following command:
```shell
sudo service vpp start
```

4. VPP has an interactive terminal, where you can configure virtual NICs to be used by DPDK applications.
```shell
sudo vppctl
```
Note that the commands listed in step 5-8 should be executed in vppctl shell.

5. Create two memif ports:
```shell
create interface memif id 250 master
create interface memif id 251 master
```

6. Check the names of the two memif ports
```shell
show interface
```

7. Bring up the two memif ports
```shell
set interface state memif0/250 up
set interface state memif0/251 up
```

8. Connect the two ports together
```shell
set interface l2 xconnect memif0/250 memif0/251
set interface l2 xconnect memif0/251 memif0/250
```
Now you have two memif virutal NIC available on your system.

9. Launch the receiver testpmd
```shell
sudo ./dpdk-testpmd -l 2,3 -n 4 --vdev net_memif0,role=client,id=250,socket=/run/vpp/memif.sock,socket-abstract=no,zero-copy=yes --single-file-segments --file-prefix config250 -- -i --portlist=2
```

10. Launch the sender testpmd
```shell
sudo dpdk-testpmd -l 4,5 -n 4 --vdev net_memif0,role=client,id=251,socket=/run/vpp/memif.sock,socket-abstract=no,zero-copy=yes --single-file-segments --file-prefix config251 -- -i --eth-peer=0,7A:4E:1A:90:15:7D --forward-mode=txonly --portlist=2
```
