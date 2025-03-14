#!/bin/bash

# Ensure the script is run as a normal user, not root
if [[ $EUID -eq 0 ]]; then
   echo "Do not run this script as root. Run it as a normal user."
   exit 1
fi

# Update package lists
echo "Updating package lists..."
sudo apt update -y

# Install required dependencies
echo "Installing required dependencies..."
sudo apt install -y curl build-essential

# Install Rust using bytedance's rsproxy.cn
ENV_VARS='
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"
'

# Check if the variables already exist in ~/.bashrc
if ! grep -q 'RUSTUP_DIST_SERVER="https://rsproxy.cn"' ~/.bashrc; then
    echo "Adding RUSTUP_DIST_SERVER to ~/.bashrc"
    echo "$ENV_VARS" >> ~/.bashrc
else
    echo "RUSTUP_DIST_SERVER is already set in ~/.bashrc"
fi

# Apply changes immediately for the current session
source ~/.bashrc

echo "Environment variables added (if they were not already present)."

# Download and install Rust using rustup
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | sh -s -- -y

# Add Rust to the current shell session
echo "Configuring Rust environment..."
source $HOME/.cargo/env

# Verify installation
echo "Rust installation completed."
rustc --version
cargo --version