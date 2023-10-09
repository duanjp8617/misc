#!/bin/bash

# A script for manual installation of vscode_server on remote server

# need a environment variable VSCODE_COMMIT=abd2f3db4bdb28f9e95536dfa84d8479f1eb312d that matches
# the one downloaded by the "download_vscode_server_extentions.sh" script.
tar -xvf ./vscode-server-linux-x64.tar.gz 
mkdir -p $HOME/.vscode-server/bin 
mv ./vscode-server-linux-x64 $HOME/.vscode-server/bin/$VSCODE_COMMIT