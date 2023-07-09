#!/bin/bash

GTEST_VERSION=1.13.0
CCACHE_VERSION=4.8.2

if [ -d "$PWD/files" ]; then
  rm -r $PWD/files
fi

if [ -d "$PWD/tvm" ]; then
  rm -r $PWD/tvm
fi

mkdir -p $PWD/files
wget -O $PWD/files/googletest.tar.gz https://github.com/google/googletest/archive/refs/tags/v${GTEST_VERSION}.tar.gz 
wget -O $PWD/files/ccache.tar.gz https://github.com/ccache/ccache/releases/download/v${CCACHE_VERSION}/ccache-${CCACHE_VERSION}-linux-x86_64.tar.xz

# we are cloning the relax repo maintained by mlc-ai
git clone --recursive --depth=1 https://github.com/mlc-ai/relax.git $PWD/tvm