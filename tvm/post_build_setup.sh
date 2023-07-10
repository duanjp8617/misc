#!/bin/bash

echo 'export TVM_HOME=/workspace/tvm' >> /root/.bashrc
echo 'export PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}' >> /root/.bashrc
