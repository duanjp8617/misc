#!/bin/bash

# $1: download link
# $2: extention file name

if [ ! -f "$PWD/$2" ]; then
  rm -f $PWD/$2.gz
  wget -O $PWD/$2.gz $1
  gunzip -v $PWD/$2.gz
fi