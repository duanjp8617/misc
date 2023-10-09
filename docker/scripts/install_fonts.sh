#!/bin/bash

if [ ! -d "~/.fonts" ]; then
    mkdir -p ~/.fonts
fi

tar -xvf ./FiraCode.tar.xz -C /usr/share/fonts
tar -xvf ./NerdFontsSymbolsOnly.tar.xz -C /usr/share/fonts
fc-cache -fv
echo "done!, check with fc-list command"
