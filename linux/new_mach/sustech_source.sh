#!/bin/bash

sudo cp -a /etc/apt/sources.list /etc/apt/sources.list.bak

sudo sed -i "s@http://.*archive.ubuntu.com@https://mirrors.sustech.edu.cn@g" /etc/apt/sources.list
sudo sed -i "s@http://.*security.ubuntu.com@https://mirrors.sustech.edu.cn@g" /etc/apt/sources.list 

sudo apt-get update
