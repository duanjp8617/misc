#!/bin/bash

CODE_DIR=/scripts

VERSION=v20.5.1

mkdir -p $CODE_DIR/node-$VERSION-linux-x64
tar -xvf $CODE_DIR/node-$VERSION-linux-x64.tar.xz -C $CODE_DIR/node-$VERSION-linux-x64
cp -r $CODE_DIR/node-$VERSION-linux-x64/node-$VERSION-linux-x64/lib /usr
cp -r $CODE_DIR/node-$VERSION-linux-x64/node-$VERSION-linux-x64/share /usr
cp -r $CODE_DIR/node-$VERSION-linux-x64/node-$VERSION-linux-x64/include /usr
cp -r $CODE_DIR/node-$VERSION-linux-x64/node-$VERSION-linux-x64/bin /usr

# install package from npm china source
# npm --registry https://registry.npmmirror.com install XXX（模块名）


