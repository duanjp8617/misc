# update docker proxy:

- First, setup a proxy to pull the docker image:
  - Add `{ "registry-mirrors": [ "https://dockerproxy.com" ] }` to `/etc/docker/daemon.json`. This is the best proxy I have ever tried, we can always use this proxy.
  - Restart the docker daemon with `systemctl daemon-reload` and `systemctl restart docker`

# ssh login without pwd

1. On the local system, execute the following command:
```shell
ssh-keygen
```
This command will generate `~/.ssh/id_rsa` as the private key, and `~/.ssh/id_rsa.pub` as the public key. And the behavior of this command is consistent across different OSes.

2. Copy `~/.ssh/id_rsa.pub` to the remote system. On the remote system, as the public key file to the `authorized_keys` with the following command:
```shell
cat ./id_rsa.pub >> ~/.ssh/authorized_keys
```

3. If we are using vscode, we can then add the following content to the remote config file:
```shell
Host h0
    HostName 192.168.67.29
    User pcl
    Port 2107
    IdentityFile ~/.ssh/id_rsa
```

4. Finally, if the remote machine is a jump-box, we can use the following config to connect to the servers behind the jump-box:
```shell
# Jump box with public IP address
Host jump-box
    HostName 52.179.157.97
    User sana
    IdentityFile ~/.ssh/jumpbox

# Target machine with private IP address
Host target-box
    HostName <IP address of target>
    User sana
    IdentityFile ~/.ssh/target
    ProxyCommand ssh -q -W %h:%p jump-box
```

# rsync

Use `rsync -av --delete source/ dest/` to perform a perfect sync.

`-av` means recursive sync with verbose messages.

`--delete` sync deletion.

When speciying the `dest/`, to perform perfect sync, we can only specify to the parent directory of the real target that we wish to sync.
