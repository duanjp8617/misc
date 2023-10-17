#!/bin/bash

apt-get -y --no-install-recommends install \
    build-essential \
    meson \
    python3-pyelftools \
    clang \
    libnuma-dev \
    pkg-config

tar -xvf ./dpdk-$DPDK_VERSION.tar.xz

cd ./dpdk-stable-$DPDK_VERSION
meson -Dprefix=$DPDK_INSTALL build 
cd build 
ninja
ninja install

echo "export PKG_CONFIG_PATH=$DPDK_INSTALL/lib/x86_64-linux-gnu/pkgconfig" >> ~/.bashrc

