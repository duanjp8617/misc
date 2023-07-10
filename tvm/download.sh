#!/bin/bash

GTEST_VERSION=1.13.0
CCACHE_VERSION=4.8.2
VSCODE_COMMIT=660393deaaa6d1996740ff4880f1bad43768c814 # vscode v1.80.0

CODE_PYTHON_EXT=2023.12.0
CODE_CLANGD_EXT=0.1.24

if [ -d "$PWD/files" ]; then
  rm -r $PWD/files
fi

mkdir -p $PWD/files
wget -O $PWD/files/googletest.tar.gz https://github.com/google/googletest/archive/refs/tags/v${GTEST_VERSION}.tar.gz 
wget -O $PWD/files/ccache.tar.gz https://github.com/ccache/ccache/releases/download/v${CCACHE_VERSION}/ccache-${CCACHE_VERSION}-linux-x86_64.tar.xz
wget -O $PWD/files/vscode-server-linux-x64.tar.gz https://update.code.visualstudio.com/commit:${VSCODE_COMMIT}/server-linux-x64/stable

wget -O $PWD/files/python.vsix https://open-vsx.org/api/ms-python/python/${CODE_PYTHON_EXT}/file/ms-python.python-${CODE_PYTHON_EXT}.vsix
wget -O $PWD/files/vscode-clangd.vsix https://github.com/clangd/vscode-clangd/releases/download/${CODE_CLANGD_EXT}/vscode-clangd-0.1.24.vsix

# use the following command to clone the tvm repo
# git clone --recursive --depth=1 https://github.com/mlc-ai/relax.git tvm

