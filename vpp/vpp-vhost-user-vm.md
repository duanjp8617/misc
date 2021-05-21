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