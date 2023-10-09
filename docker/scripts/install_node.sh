#!/bin/bash

# need a VERSION environment variable that matches the downloaded node version

tar -xvf ./node-$VERSION-linux-x64.tar.xz
cp -r ./node-$VERSION-linux-x64/node-$VERSION-linux-x64/lib /usr
cp -r ./node-$VERSION-linux-x64/node-$VERSION-linux-x64/share /usr
cp -r ./node-$VERSION-linux-x64/node-$VERSION-linux-x64/include /usr
cp -r ./node-$VERSION-linux-x64/node-$VERSION-linux-x64/bin /usr

# install package from npm china source
# npm --registry https://registry.npmmirror.com install XXX（模块名）


