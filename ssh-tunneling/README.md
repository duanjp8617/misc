# A Complete guide for setting up a SSH tunnel to access a restricted server.

## Prepare a cloud server with a public accessible IP address
Open /etc/ssh/sshd_config, and add the following parameter settings:

```shell
GatewayPorts yes
ClientAliveInterval 10
ClientAliveCountMax 10
```

Then issue the following command in Ubuntu 18.04 to restart sshd

```console
sudo service sshd restart
```

This configures the sshd on cloud server to automatically send heartbeat messages to keep the SSH session alive.


## Create a remote SSH tunnel on the restricted server.
1. 
Open /etc/ssh/ssh_config, and add the following parameter settings:

```shell
TCPKeepAlive yes
ServerAliveInterval 15
ServerAliveCountMax 6
```

Then issue the following command in Ubuntu 18.04 to restart sshd

```console
sudo service ssh restart
```

2. 
Run the following command on the restricted server:

```console
ssh -R <RemotePort>:<LocalHost>:<LocalPort> sshUser@remoteServer
```
RemotePort : The port to be occupied on the cloud server, which can be used to tunnel the traffic to the restricted server.

LocalHost : This is usually localhost or "127.0.0.1", which indicates the local address of the restricted server.

LocalPort : The port occupied on the restricted server for accepting the incoming traffic over the tunnel.

sshUser : The ssh user name of the cloud server.

remoteServer : The public address of the remote server.
3. 
Consider running the in a screen

```console
screen
ssh -R <RemotePort>:<LocalHost>:<LocalPort> sshUser@remoteServer
Ctrl+a d
```

The previous command creates a screen, launch the remote SSH tunnel in the screen and then detach from the screen.

In case that you wanna reattach to the screen, you can use 

```console
screen -r
# or
screen -ls
screen -r [screen number]
```

In case that you wanna kill a detached screen session, you can use:
```console
screen -X -S [session # you want to kill] quit
```
4. 
After the previous 2 steps, you can log in the cloud server, and access the restricted server via
```console
ssh -p RemotePort restrictedServerUser@localhost
```

## Create a local SSH tunnel from my own PC.
