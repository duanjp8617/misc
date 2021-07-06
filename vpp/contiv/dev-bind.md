# Bind vhost-user vNIC in ubuntu18.04 VM

1. Load vfio-pci kerneld  driver
```bash
modprobe vfio-pci
```

2. The ubuntu18.04 cloud image disables IOMMU by default. For a quick installation, we just enable the unsafe NOIOMMU mode inside the guest kernel with the following command.
```bash
echo Y | sudo tee /sys/module/vfio/parameters/enable_unsafe_noiommu_mode
```

3. Finally, bind the vhost-user NIC to vfio-pci driver with the dpdk dpdk-devbind.py script.