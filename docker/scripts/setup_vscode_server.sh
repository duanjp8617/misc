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