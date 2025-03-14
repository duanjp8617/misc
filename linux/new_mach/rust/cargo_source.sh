#!/bin/bash

# Ensure the script is run as a normal user, not root
if [[ $EUID -eq 0 ]]; then
   echo "Do not run this script as root. Run it as a normal user."
   exit 1
fi

# Define the file path
CARGO_CONFIG="$HOME/.cargo/config.toml"

# Define the content to be added
CONFIG_CONTENT="[source.crates-io]
replace-with = 'rsproxy-sparse'
[source.rsproxy]
registry = \"https://rsproxy.cn/crates.io-index\"
[source.rsproxy-sparse]
registry = \"sparse+https://rsproxy.cn/index/\"
[registries.rsproxy]
index = \"https://rsproxy.cn/crates.io-index\"
[net]
git-fetch-with-cli = true
"

# Ensure the .cargo directory exists
mkdir -p "$HOME/.cargo"

# Check if the content already exists
if grep -q "rsproxy.cn" "$CARGO_CONFIG" 2>/dev/null; then
    echo "Configuration already exists in $CARGO_CONFIG"
else
    echo "Adding configuration to $CARGO_CONFIG..."
    echo "$CONFIG_CONTENT" >> "$CARGO_CONFIG"
    echo "Configuration added successfully."
fi