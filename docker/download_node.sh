#!/bin/bash

if [ ! -d "./downloads" ]; then
  mkdir -p ./downloads
fi

# download node
VERSION=v20.5.1
wget -O ./downloads/node-$VERSION-linux-x64.tar.xz https://nodejs.org/dist/$VERSION/node-$VERSION-linux-x64.tar.xz
