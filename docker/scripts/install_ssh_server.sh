apt install -y openssh-server sudo

# uncomment the following lines if you want root login
# echo 'root:root' | chpasswd
# sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# add a new user with root priviledge
USER=djp
PWD=djp

useradd -ms /bin/bash $USER
echo "$USER:$PWD" | chpasswd
usermod -aG sudo $USER

# enable X11 forwarding
sed -i 's/#X11DisplayOffset 10/X11DisplayOffset 10/g' /etc/ssh/sshd_config
sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/g' /etc/ssh/sshd_config
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
