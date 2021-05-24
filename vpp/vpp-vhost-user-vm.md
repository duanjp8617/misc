## Connecting vhost-user port from VPP to VM

# Creating VMs on top of Hugepages
1. To connect vhost-user port to the VM, the VM's memory must be backed by system's hugepages. So the first step is to configure libvirt VM and create the VM on top of hugepages.

2. Add the following configuration to VM's XML file. This enables the VM's memory to be backed by hypervisor's hugepages.
```xml
<memoryBacking>
    <hugepages>
      <page size='2048' unit='KiB'/>
    </hugepages>
    <access mode='shared'/>
</memoryBacking>
```

3. Ad the following configuration to VM's XML file. This configures the NUMA status inside the VM. The following configuration configures a single NUMA node for this VM, with CPU IDs between 0 and 3. Note that the CPU IDs should be smaller than the limit set by the vcpu filed in the configuraion file. The size of the memory should be consistent with the specified VM memory size.
```xml
 <cpu mode='host-model' check='partial'>
    <numa>
      <cell id='0' cpus='0-3' memory='12582912' unit='KiB' memAccess='shared'/>
    </numa>
 </cpu>
```

4. An example VM xml file is also stored in this directory.

# Creating vhost-user port inside VPP
1. Create two vhost-user port inside VPP, first use the default configuration.
```shell
vppctl create vhost-user socket /var/run/vpp/name.sock server
```

2. Bring the two interface up in VPP and connect them to the same bridge.

3. Last and most important, the /var/run/vpp/name.sock unix domain socket is owned by root, with vpp as default group. Unfortuantely, this unix domain socket can not be operated by VMs created by libvirt. This is because VMs created by libvirt is owned by a special user called **libvirt-qemu**. So we must change the user of /var/run/vpp/name.sock to **libvirt-qemu**.

# Adding vhost-user network interface to VM
1. Adding the following content to the VM xml file:
```xml
<interface type='vhostuser'>
      <mac address='52:54:00:4c:47:f2'/>
      <source type='unix' path='/var/run/vpp/name.sock' mode='client'/>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x06' function='0x0'/>
</interface>
```
2. We can configure the mac address here, and the NIC backed by this vhost-user port will have the corresponding mac address. 

3. The mode must be set as client, otherwise the VM will not boot.

4. The path must be directed to the unix domain socket created previously by VPP.

# Bind vpp-threads to CPU cores
1. In the CPU section of the VPP configuration file, do the following:
```shell
main-core 0 # set main core to 0
corelist-workers 1 # Configure only a single worker, and bind the worker to core 1
```

2. Then start VPP.

# Debugging the vhost-user class
1. Enable the following configuraiton in startup.conf:
```shell
logging {
   ## set default logging level for logging buffer
   ## logging levels: emerg, alert,crit, error, warn, notice, info, debug, disabled
   default-log-level debug
   ## set default logging level for syslog or stderr output
   # default-syslog-log-level info
   ## Set per-class configuration
   # class dpdk/cryptodev { rate-limit 100 level debug syslog-level error }
}
"star
```

2. Run the following command in vppctl
```shell
set logging class vhost-user level debug syslog-level debug
```

3. Then use show log to check the debug output from vhost-user 