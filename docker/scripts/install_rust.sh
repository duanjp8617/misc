#!/bin/bash

# apt update
# apt install -y curl

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

#rustup component add rust-src
#rustup component add rust-analyzer