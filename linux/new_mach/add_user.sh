#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi

# Create a new user named "djp" with a home directory and bash shell
useradd -m -s /bin/bash djp

# Set the password for the user
echo "djp:djp" | chpasswd

# Add the user to the sudo group for root privileges
usermod -aG sudo djp

# Allow "djp" to run sudo commands without password
echo "djp ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/djp
chmod 0440 /etc/sudoers.d/djp

# Display confirmation message
echo "User 'djp' has been created with root privileges and can use sudo without a password."
