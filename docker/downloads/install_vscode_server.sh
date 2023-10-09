#!/bin/bash

# A script for manual installation of vscode_server on remote server

# vscode commit version shown by the command: `code --version`:
# A sample output:
# 1.82.2
# abd2f3db4bdb28f9e95536dfa84d8479f1eb312d
# x64
VSCODE_COMMIT=abd2f3db4bdb28f9e95536dfa84d8479f1eb312d

tar -xvf ./vscode-server-linux-x64.tar.gz 
mkdir -p $HOME/.vscode-server/bin 
mv ./vscode-server-linux-x64 $HOME/.vscode-server/bin/$VSCODE_COMMIT