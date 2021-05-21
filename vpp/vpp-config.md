1. After intallation, VPP creates a sysctl file at /etc/sysctl.d/80-vpp.conf. This file configures the number of huge pages on this server.

2. We can actually change the content in 80-vpp.conf and reconfigures the total number of huge pages reserved on this server, with the following command:
```bash
sysctl -f /etc/sysctl.d/80-vpp.conf
```