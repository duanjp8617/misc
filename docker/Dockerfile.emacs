FROM ubuntu:22.04

COPY scripts/update_apt_source.sh /scripts/update_apt_source.sh
RUN /scripts/update_apt_source.sh

COPY scripts/install_emacs.sh /scripts/install_emacs.sh
RUN /scripts/install_emacs.sh

COPY scripts/install_fonts.sh /scripts/install_fonts.sh
COPY downloads/FiraCode.tar.xz /scripts/FiraCode.tar.xz
RUN /scripts/install_fonts.sh

COPY scripts/install_ssh_server.sh /scripts/install_ssh_server.sh
RUN /scripts/install_ssh_server.sh

EXPOSE 22

ENV TERM=xterm-256color
ENTRYPOINT service ssh restart && bash

# use this command to build the docker image
# sudo docker build -f Dockerfile.emacs -t <image name>:<version> .

# use this command to inspect the ip of the container:
# docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container_name>

# set /etc/ssh/sshd_config with:
# X11Forwarding yes
# X11DisplayOffset 10
# X11UseLocalhost no