#!/bin/bash

if [ ! -d "./downloads" ]; then
  mkdir -p ./downloads
fi

# install FiraCode Nerd Font from https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/FiraCode.tar.xz
VERSION=v3.0.2
echo "[-] Download fonts [-]"
echo "https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/FiraCode.tar.xz"
wget -O ./downloads/FiraCode.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/FiraCode.tar.xz
wget -O ./downloads/NerdFontsSymbolsOnly.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/NerdFontsSymbolsOnly.tar.xz

# download node
VERSION=v20.5.1
wget -O ./downloads/node-v20.5.1-linux-x64.tar.xz https://nodejs.org/dist/$VERSION/node-v20.5.1-linux-x64.tar.xz
