#!/bin/bash

# A script for manual installtion of extension on remote server

if [ ! -f "./$1" ]; then
  echo "extention $1 does not present"
  exit
fi

if [ ! -d "$HOME/.vscode-server" ]; then
  echo "vscode-server is not installed"
  exit
fi

if [ ! -d "$HOME/.vscode-server/extensions" ]; then
  mkdir -p $HOME/.vscode-server/extensions
fi

unzip -d $1_tmp $1
mv $1_tmp/extension.vsixmanifest $1_tmp/extension/.vsixmanifest
mv $1_tmp/extension $HOME/.vscode-server/extensions/$1
rm -r $1_tmp
echo "done"