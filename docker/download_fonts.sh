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
