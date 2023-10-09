#!/bin/bash

# vscode servers and extentions may get difficult to install from the GUI interface.
# In this case, we can use this script to manually download the vscode_server and important 
# extentions

# vscode commit version shown by the command: `code --version`:
# A sample output:
# 1.82.2
# abd2f3db4bdb28f9e95536dfa84d8479f1eb312d
# x64
VSCODE_COMMIT=abd2f3db4bdb28f9e95536dfa84d8479f1eb312d
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

# OCaml Platform
OCAML=https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ocamllabs/vsextensions/ocaml-platform/1.13.1/vspackage
./download_extention_from_market_place.sh $OCAML ocaml-platform

