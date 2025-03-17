WORK_DIR="$(pwd)"   # Use the current working directory
HOSTS=("h139" "h107")
DPDK_INSTALLED_PATH="PKG_CONFIG_PATH=~/ws_erpc/dpdk-21.11.9/install/lib/x86_64-linux-gnu/pkgconfig"

for HOST in "${HOSTS[@]}"; do
    echo "Sync the erpc directory"
    rsync -avz --delete $WORK_DIR/eRPC $HOST:~/ws_erpc/
    ssh $HOST "cd ~/ws_erpc/eRPC; rm -rf CMakeCache.txt CMakeFiles cmake_install.cmake Makefile build; $DPDK_INSTALLED_PATH cmake . -DPERF=on -DTRANSPORT=dpdk; make -j"
done