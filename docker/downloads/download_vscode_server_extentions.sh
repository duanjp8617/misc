#!/bin/bash

# vscode servers and extentions may get difficult to install from the GUI interface.
# In this case, we can use this script to manually download the vscode_server and important 
# extentions

# vscode commit version shown by the command: `code --version`:
# A sample output:
# 1.81.1
# 6c3e3dba23e8fadc360aed75ce363ba185c49794
# x64
VSCODE_COMMIT=6c3e3dba23e8fadc360aed75ce363ba185c49794
if [ ! -f "./vscode-server-linux-x64.tar.gz" ]; then
  wget -O ./vscode-server-linux-x64.tar.gz https://update.code.visualstudio.com/commit:${VSCODE_COMMIT}/server-linux-x64/stable
fi

# Clangd extention
CLANGD=https://marketplace.visualstudio.com/_apis/public/gallery/publishers/llvm-vs-code-extensions/vsextensions/vscode-clangd/0.1.24/vspackage
./download_extention_from_market_place.sh $CLANGD vscode-clangd

# Rust analyzer extention
RUST=https://marketplace.visualstudio.com/_apis/public/gallery/publishers/rust-lang/vsextensions/rust-analyzer/0.4.1634/vspackage?targetPlatform=linux-x64
./download_extention_from_market_place.sh $RUST rust-analyzer

# Pylance extention
PYLANCE=https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/2023.8.40/vspackage
./download_extention_from_market_place.sh $PYLANCE vscode-pylance

# Python extention, For pylance v2023.8.40 is compatible with python v2023.14.0
PYTHON=https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/python/2023.14.0/vspackage
./download_extention_from_market_place.sh $PYTHON python