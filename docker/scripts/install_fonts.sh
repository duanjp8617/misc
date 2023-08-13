#!/bin/bash

VERSION=v3.0.2

# install FiraCode Nerd Font from https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/FiraCode.tar.xz
echo "[-] Download fonts [-]"
echo "https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/FiraCode.tar.xz"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/FiraCode.tar.xz

if [ ! -d "~/.fonts" ]; then
    mkdir -p ~/.fonts
fi

unzip FiraCode.tar.xz -d ~/.fonts
fc-cache -fv
echo "done!, check with fc-list command"