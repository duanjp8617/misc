#!/bin/bash

echo 'export TVM_HOME=/workspace/tvm' >> /root/.bashrc
echo 'export PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}' >> /root/.bashrc


if [ -d "/workspace/tvm" ]; then
  mkdir -p /workspace/tvm/.vscode
  cp /workspace/configs/settings.json /workspace/tvm/.vscode
  echo "tips:
1. Run this command in build directory: cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 ..
   It generates the build/compile_commands.json, which is used by clangd to index the source files.
2. clang-tidy is enabled by copying the /workspace/configs/config.yaml to ~/.config/clangd/config.yaml"
else 
  echo "/workspace/tvm is not available, have you map tvm source code to the container?"
fi