#!/bin/bash

# install emacs dependency libraries
apt install -y \
  build-essential \
  texinfo \
  libx11-dev \
  libxpm-dev \
  libjpeg-dev \
  libpng-dev \
  libgif-dev \
  libtiff-dev \
  libgtk-3-dev \
  libcanberra-gtk3-module \
  libncurses-dev \
  libgnutls28-dev \
  libjansson-dev \
  libgccjit-11-dev \

# ripgrep for projectile rg search
# git for magit
# jq for json format with flycheck
apt install -y \
  wget \
  ripgrep \
  git \
  jq

wget http://mirrors.ustc.edu.cn/gnu/emacs/emacs-28.2.tar.gz
tar xvzf emacs-28.2.tar.gz

cd emacs-28.2
./configure --with-json --with-native-compilation
make -j
make install
