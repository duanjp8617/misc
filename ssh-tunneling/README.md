# A Complete guide for setting up a SSH tunnel to access a restricted server.

## Prepare a cloud server with a public accessible IP address
I choose to launch a VM in Ali cloud.

## Create a remote SSH tunnel on the restricted server.
1. 
Run the following command on the restricted server:

```console
ssh -R <RemotePort>:<LocalHost>:<LocalPort> sshUser@remoteServer
```
RemotePort : The port to be occupied on the cloud server, which can be used to tunnel the traffic to the restricted server.

LocalHost : This is usually localhost or "127.0.0.1", which indicates the local address of the restricted server.

LocalPort : The port occupied on the restricted server for accepting the incoming traffic over the tunnel.

sshUser : The ssh user name of the cloud server.

remoteServer : The public address of the remote server.
2. 
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
3. 

After the previous 2 steps, you can log in the cloud server, and access the restricted server via
```console
ssh -p RemotePort restrictedServerUser@localhost
```
