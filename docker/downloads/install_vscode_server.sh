#!/bin/bash

# vscode commit version shown by the command: `code --version`:
# A sample output:
# 1.81.1
# 6c3e3dba23e8fadc360aed75ce363ba185c49794
# x64
VSCODE_COMMIT=6c3e3dba23e8fadc360aed75ce363ba185c49794

tar -xvf ./vscode-server-linux-x64.tar.gz 
mkdir -p ~/.vscode-server/bin 
mv ./vscode-server-linux-x64 ~/.vscode-server/bin/$VSCODE_COMMIT

# Add the following lines to dockerfile to enable automatic vscode setup
# ARG VSCODE_COMMIT=6c3e3dba23e8fadc360aed75ce363ba185c49794
# COPY downloads/vscode-server-linux-x64.tar.gz  /scripts/vscode-server-linux-x64.tar.gz 
# RUN tar -xvf /scripts/vscode-server-linux-x64.tar.gz  
# # for root user
# RUN mkdir -p /root/.vscode-server/bin
# RUN cp -r /scripts/vscode-server-linux-x64 /root/.vscode-server/bin/$VSCODE_COMMIT
# # for djp user
# RUN mkdir -p /home/djp/.vscode-server/bin
# RUN cp -r /scripts/vscode-server-linux-x64 /home/djp/.vscode-server/bin/$VSCODE_COMMIT
# RUN chown -R djp:djp /home/djp/.vscode-server