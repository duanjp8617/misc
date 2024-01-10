#!/bin/sh

# Install necessary apt packages 
apt install -y xz make autoconf g++ flex bison

# Extract coursier
gzip -d ./cs-x86_64-pc-linux.gz
mv ./cs-x86_64-pc-linux ./cs
chmod +x ./cs

# Install sbt
mkdir -p ~/.local
tar -xvf ./sbt-1.9.8.tgz -C ~/.local
echo 'export PATH=$PATH:~/.local/sbt/bin' >> /root/.bashrc

# Configure sbt repositories
mkdir -p ~/.sbt
echo "[repositories]
local
aliyun: https://maven.aliyun.com/repository/central/
sbt-plugin-repo: https://repo.scala-sbt.org/scalasbt/sbt-plugin-releases, [organization]/[module]/(scala_[scalaVersion]/)(sbt_[sbtVersion]/)[revision]/[type]s/[artifact](-[classifier]).[ext]
" > ~/.sbt/repositories

mkdir -p /etc/sbt
echo "-Dsbt.override.build.repos=true" > /etc/sbt/sbtopts

# Install firtool
tar -xvf ./firrtl-bin-ubuntu-20.04.tar.gz -C ~/.local
echo 'export PATH=$PATH:~/.local/firtool-1.38.0/bin' >> /root/.bashrc