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
if [ ! -f "./vscode-clangd.vsix" ]; then
  rm -f ./vscode-clangd.vsix.gz
  wget -O ./vscode-clangd.vsix.gz https://marketplace.visualstudio.com/_apis/public/gallery/publishers/llvm-vs-code-extensions/vsextensions/vscode-clangd/0.1.24/vspackage
  gunzip -v ./vscode-clangd.vsix.gz
fi

# Rust analyzer extention
if [ ! -f "./rust-analyzer.vsix" ]; then
  rm -f ./rust-analyzer.vsix.gz
  wget -O ./rust-analyzer.vsix.gz https://marketplace.visualstudio.com/_apis/public/gallery/publishers/rust-lang/vsextensions/rust-analyzer/0.4.1634/vspackage?targetPlatform=linux-x64
  gunzip -v ./rust-analyzer.vsix.gz
fi

# Pylance extention
if [ ! -f "./pylance.vsix" ]; then
  rm -f ./pylance.vsix.gz
  wget -O ./pylance.vsix.gz https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/2023.8.41/vspackage
  gunzip -v ./pylance.vsix.gz
fi

# Python extention, For pylance v2023.8.41 is compatible with python v2023.14.0
if [ ! -f "./python.vsix" ]; then
  rm -f ./python.vsix.gz
  wget -O ./python.vsix.gz https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/python/2023.14.0/vspackage
  gunzip -v ./python.vsix.gz
fi