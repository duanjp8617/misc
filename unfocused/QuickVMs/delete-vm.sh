#!/bin/sh

# Make sure that destImgDir is the same with destImgDir
# in create-vm.sh. Otherwise the operation may be dangerous.
# Make sure that there is a trailing "/" at the end of the directory path.
destImgDir="/home/djp/WorkSpace/VMImgs/"

# The name of the vm to be created must be passed in.
if [ $# -ne 1 ]; then
    echo "The number of input arguments is not 1."
    exit 1
fi

# Create the VM image using the base image.
if ls $destImgDir$1; then
    sudo virsh destroy $1
    sudo virsh undefine $1
    sudo rm -f $destImgDir$1
else
    echo "The specified VM does not exist on this machine."
fi