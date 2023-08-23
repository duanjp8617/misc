#!/bin/bash

if [ ! -d "./downloads" ]; then
  mkdir -p ./downloads
fi

# vscode commit version shown by the command: `code --version`:
# A sample output:
# 1.81.1
# 6c3e3dba23e8fadc360aed75ce363ba185c49794
# x64
VSCODE_COMMIT=6c3e3dba23e8fadc360aed75ce363ba185c49794
wget -O ./downloads/vscode-server-linux-x64.tar.gz https://update.code.visualstudio.com/commit:${VSCODE_COMMIT}/server-linux-x64/stable


