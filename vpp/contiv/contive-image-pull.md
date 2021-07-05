I can't pull the images of contive vpp from the official docker hub even with trojan tunneling. To solve it, I use the alicloud docker mirror.

1. Execute the following command:
```bash
sudo sh -c 'echo {\"registry-mirrors\": [\"https://0bbqupb9.mirror.aliyuncs.com\"]} > /etc/docker/daemon.json'
```

2. Restart docker service with: 
```bash
sudo systemctl restart docker
```

3. Confirm that we have already setup the mirror with
```bash
sudo docker info
```
