# A quick command to check the PCIe capacity for the NIC
```shell
lspci -vv | grep -E 'PCI bridge|LnkCap'
```
Unfortunately, this command is not useful for mlx5 NIC, as its link capacity is hidden and reading its link capacity is denied.

# Mlx5 DPDK official guide
1. https://doc.dpdk.org/guides/platform/mlx5.html contains instructions for setting up the mlx5 dpdk environment. 
2. Basically, we need to first install the MLNX_OFED/EN package following the instruction. Note that for ConnectX-5 Ex NIC, the required firmware version is 16.21.1000 and above.
3. After the installation, we can use the following command to check the firmware version.
```shell
ibv_devinfo
```

# Opensource mstflint management tool installation
1. Install from the source at https://github.com/Mellanox/mstflint
2. In case that libz and libssl are missing, install with the following commands:
```shell
sudo apt install libz-dev
sudo apt install libssl-dev
```
3. In case that `infiniband/mad.h` is missing, configure with the following command
```shell
./configure  --disable-inband
```
4. Use the following commands to build and install mstflint
```shell
make -j
sudo make install
```

# Using mstflint
1. Use the following command to check the pcie identifiers for Mellanox NIC
```shell
lspci | grep Mellanox
```

2. Use `mstconfig` to query the status of the NIC:
```shell
sudo mstconfig -d b1:00.0 query | grep LINK_TYPE
```
According to the DPDK official manual, the output of the above command must show `ETH(2)` in order to use Mellanox NIC with DPDK.

3. In case that the above NIC does not show `ETH(2)`, use the following command to change the mode to `ETH(2)`:
```shell
sudo mstconfig -d b1:00.0 set LINK_TYPE_P1=2
sudo mstconfig -d b1:00.0 set LINK_TYPE_P2=2
```
Then use the following command to reset the firmware:
```shell
mlxfwrest -d <mst device> reset
```