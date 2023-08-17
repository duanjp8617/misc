#!/bin/bash

TZ=Etc/UTC
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone

