# Define the DPDK version to install
DPDK_VERSION="21.11.9"  # Change this to the desired version
WORK_DIR="$(pwd)"   # Use the current working directory

# The downloaded file and the directory to untar.
DPDK_TAR="dpdk-$DPDK_VERSION.tar.xz"
DPDK_SRC_DIR="dpdk-$DPDK_VERSION"

# Check if the DPDK tar file already exists in the current directory
if [[ ! -f "$WORK_DIR/$DPDK_TAR" ]]; then
    echo "Downloading DPDK version $DPDK_VERSION..."
    wget -O "$WORK_DIR/$DPDK_TAR" "https://fast.dpdk.org/rel/$DPDK_TAR"
else
    echo "DPDK source file already exists: $WORK_DIR/$DPDK_TAR"
fi

cd $WORK_DIR
if [[ ! -d "$WORK_DIR/eRPC" ]]; then
    echo "Git clone eRPC repo..."
    git clone https://github.com/erpc-io/eRPC.git
else
    echo "eRPC repo already exists: $WORK_DIR/eRPCR"
fi

HOSTS=("h139" "h107")

for HOST in "${HOSTS[@]}"; do
    echo "Syncing $(pwd) to $HOST:~/ws_erpc"
    rsync -az --delete $WORK_DIR $HOST:~/
done

for HOST in "${HOSTS[@]}"; do
    echo "Building DPDK on $HOST"
    ssh $HOST "cd ~/ws_erpc && ./install_dpdk.sh"
done