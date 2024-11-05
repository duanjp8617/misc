Use `netstat -an | grep 192.168.150.143` to check which connection is being used.

Typical output:
```shell
netstat -an | grep 192.168.150.143
tcp        0 1009728 192.168.150.142:38455   192.168.150.143:40126   ESTABLISHED
tcp6       0      0 192.168.150.142:12355   192.168.150.143:51174   ESTABLISHED
```

Choose the one with a large third column value, which indicates the amount of data waiting to be sent in the TCP send queue.