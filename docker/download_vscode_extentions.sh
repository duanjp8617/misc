#!/bin/bash

# CODE_PYTHON_EXT=2023.12.0
CODE_CLANGD_EXT=0.1.24

if [ ! -d "./downloads" ]; then
  mkdir -p ./downloads
fi

# pylance is better, but I can only manually download it from the webpage
# wget -O ./downloads/python.vsix https://open-vsx.org/api/ms-python/python/${CODE_PYTHON_EXT}/file/ms-python.python-${CODE_PYTHON_EXT}.vsix
wget -O ./downloads/vscode-clangd.vsix https://github.com/clangd/vscode-clangd/releases/download/${CODE_CLANGD_EXT}/vscode-clangd-${CODE_CLANGD_EXT}.vsix