#!/bin/bash

# Define the DPDK version to install
DPDK_VERSION="23.11.3"  # Change this to the desired version
WORK_DIR="$(pwd)"   # Use the current working directory

# The downloaded file and the directory to untar.
DPDK_TAR="dpdk-$DPDK_VERSION.tar.xz"
DPDK_SRC_DIR="dpdk-$DPDK_VERSION"

# Ensure the script is NOT run as root
if [[ $EUID -eq 0 ]]; then
   echo "Do not run this script as root! Run it as a normal user."
   exit 1
fi

# Update package lists and install dependencies
echo "Updating package lists and installing dependencies..."
sudo apt update -y
sudo apt install -y build-essential meson ninja-build python3-pyelftools libnuma-dev pkg-config

# Check if the DPDK tar file already exists in the current directory
if [[ ! -f "$WORK_DIR/$DPDK_TAR" ]]; then
    echo "Downloading DPDK version $DPDK_VERSION..."
    wget -O "$WORK_DIR/$DPDK_TAR" "https://fast.dpdk.org/rel/$DPDK_TAR"
else
    echo "DPDK source file already exists: $WORK_DIR/$DPDK_TAR"
fi

# Extract DPDK if the source directory is not already present
cd "$WORK_DIR"
if [[ ! -d "$DPDK_SRC_DIR" ]]; then
    mkdir -p "$DPDK_SRC_DIR"
    echo "Extracting DPDK source..."
    tar -xf "$DPDK_TAR" -C "$DPDK_SRC_DIR" --strip-components=1
else
    echo "DPDK source directory already exists: $WORK_DIR/$DPDK_SRC_DIR"
fi

# Build and install DPDK in the current directory
cd "$DPDK_SRC_DIR"
echo "Building and installing DPDK in $WORK_DIR/$DPDK_SRC_DIR/install..."
meson setup build --prefix="$WORK_DIR/$DPDK_SRC_DIR/install"
ninja -C build
# If $WORK_DIR requires root access, prefix the following command with sudo
ninja -C build install

# Configure environment variables
echo "Disable environment setting."
#echo "Configuring environment variables..."
#echo "export DPDK_DIR=$WORK_DIR" >> ~/.bashrc
#echo "export PATH=\$DPDK_DIR/bin:\$PATH" >> ~/.bashrc
#echo "export PKG_CONFIG_PATH=\$DPDK_DIR/lib/pkgconfig:\$PKG_CONFIG_PATH" >> ~/.bashrc
#echo "export LD_LIBRARY_PATH=\$DPDK_DIR/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc
#source ~/.bashrc

echo " "
echo "DPDK version $DPDK_VERSION installed successfully in: $WORK_DIR/$DPDK_SRC_DIR/install"
echo " "
echo "Execute the following command to search for the installation information."
echo "export PKG_CONFIG_PATH=$WORK_DIR/$DPDK_SRC_DIR/install/lib/x86_64-linux-gnu/pkgconfig:\$PKG_CONFIG_PATH"