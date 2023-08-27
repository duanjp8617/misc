#!/bin/bash

if [ ! -f "./$1" ]; then
  echo "extention $1 does not present"
  exit
fi

if [ ! -d "~/.vscode-server" ]; then
  echo "vscode-server is not installed"
  exit
fi

if [ ! -d "~/.vscode-server/extentions" ]; then
  mkdir -p ~/.vscode-server/extentions
fi

unzip -d $1_tmp $1
mv $1_tmp/extension.vsixmanifest $1_tmp/extension/.vsixmanifest
mv $1_tmp/extension ~/.vscode-server/extentions/$1
rm -r $1_tmp