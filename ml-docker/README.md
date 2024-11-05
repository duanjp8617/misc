## Download cifa-10 dataset before building the dockerfile

Download cifar10 dataset with: 
```shell
https://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz
```

## Change parameters before runing the distributed training:

1. line 118 of distributed_training_resnet50.py:  
`world_size = 2`  
Modify the `world_size` according to how many machines are available.

2. line 14,15 of distributed_training_resnet50.py:  
```python
    os.environ['MASTER_ADDR'] = '192.168.150.142'  # Change to main node IP
    os.environ['MASTER_PORT'] = '12355'      # Change to an available port
```  
Change the address and port to accessible value, every machine uses the same configuration.

## Launch the distributed training:

On each machine, run the following command: 
```shell
RANK=x python3 distributed_training_resnet50.py
```  
Each machine replaces x with a unique number that is smaller than `world_size`.

## Check TCP connections used in the training

Use `netstat -an | grep 192.168.150.143` to check which connection is being used.

Typical output:
```shell
netstat -an | grep 192.168.150.143
tcp        0 1009728 192.168.150.142:38455   192.168.150.143:40126   ESTABLISHED
tcp6       0      0 192.168.150.142:12355   192.168.150.143:51174   ESTABLISHED
```

Choose the one with a large third column value, which indicates the amount of data waiting to be sent in the TCP send queue.