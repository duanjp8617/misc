#!/bin/bash

CODE_DIR=/scripts

if [ ! -d "~/.fonts" ]; then
    mkdir -p ~/.fonts
fi

tar -xvf $CODE_DIR/FiraCode.tar.xz -C ~/.fonts
fc-cache -fv
echo "done!, check with fc-list command"