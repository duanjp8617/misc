1. After intallation, VPP creates a sysctl file at /etc/sysctl.d/80-vpp.conf. This file configures the number of huge pages on this server.

2. We can actually change the content in 80-vpp.conf and reconfigures the total number of huge pages reserved on this server, with the following command:
```bash
sysctl -f /etc/sysctl.d/80-vpp.conf
```

3. If we run VPP inside a desktop, we can prevent the CPU from busy polling by adding. (Do not use this method! It introduces too much latencies to VPP)
```bash
poll-sleep-usec 100
```

4. What we should do for a substitution of advise 3 is that, we should do the following configuration in VPP
```bash
set interface rx-mode xxx interrupt/adpative
```