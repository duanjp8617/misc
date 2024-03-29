#!/bin/bash

# need environment variable VERSION=v20.5.1 that matches the one downloaded by 
# the "download_node.sh" script

tar -xvf ./node-$VERSION-linux-x64.tar.xz
cp -r ./node-$VERSION-linux-x64/node-$VERSION-linux-x64/lib /usr
cp -r ./node-$VERSION-linux-x64/node-$VERSION-linux-x64/share /usr
cp -r ./node-$VERSION-linux-x64/node-$VERSION-linux-x64/include /usr
cp -r ./node-$VERSION-linux-x64/node-$VERSION-linux-x64/bin /usr

# install package from npm china source
# npm --registry https://registry.npmmirror.com install XXX（模块名）


