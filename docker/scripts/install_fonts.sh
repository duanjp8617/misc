#!/bin/bash

CODE_DIR=/scripts

if [ ! -d "~/.fonts" ]; then
    mkdir -p ~/.fonts
fi

tar -xvf $CODE_DIR/FiraCode.tar.xz -C /usr/share/fonts
tar -xvf $CODE_DIR/NerdFontsSymbolsOnly.tar.xz -C /usr/share/fonts
fc-cache -fv
echo "done!, check with fc-list command"
