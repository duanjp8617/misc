# A Complete guide for setting up a SSH tunnel to access a restricted server.

## Prepare a cloud server with a public accessible IP address
I choose to launch a VM in Ali cloud.

## Create a remote SSH tunnel on the restricted server.
1. Use the following command:
```console
ssh -R <RemotePort>:<LocalHost>:<LocalPort> sshUser@remoteServer
```
RemotePort : The port to be occupied on the cloud server, which can be used to tunnel the traffic to the restricted server.

LocalHost : This is usually localhost or "127.0.0.1", which indicates the local address of the restricted server.

LocalPort : The port occupied on the restricted server for accepting the incoming traffic over the tunnel.

sshUser : The ssh user name of the cloud server.

remoteServer : The public address of the remote server.

