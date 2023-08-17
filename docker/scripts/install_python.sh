#!/bin/bash

# generate the deadsnakes gpg file
DEADSNAKE_GPG_KEY=BA6932366A755776
apt-get -y install software-properties-common 
gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/deadsnakes.gpg --keyserver keyserver.ubuntu.com --recv-keys ${DEADSNAKE_GPG_KEY}

# add deadsnakes apt source
echo "deb [signed-by=/usr/share/keyrings/deadsnakes.gpg] https://launchpad.proxy.ustclug.org/deadsnakes/ppa/ubuntu/ jammy main" >> /etc/apt/sources.list.d/deadsnakes-ubuntu-ppa-jammy.list

PYTHON_VERSION=3.8
apt-get update \
  && apt-get install -y \
     acl \
     python${PYTHON_VERSION} \
     python${PYTHON_VERSION}-dev \
     python3-pip \
     python${PYTHON_VERSION}-venv
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1 \
  && update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1
