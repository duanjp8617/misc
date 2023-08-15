#!/bin/bash

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
  wget

wget http://mirrors.ustc.edu.cn/gnu/emacs/emacs-28.2.tar.gz
tar xvzf emacs-28.2.tar.gz

cd emacs-28.2
./configure
make -j
make install