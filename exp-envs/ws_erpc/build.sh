WORK_DIR="$(pwd)"   # Use the current working directory
HOSTS=("h139" "h107")

for HOST in "${HOSTS[@]}"; do
    echo "Sync eRPC source code"
    #rsync -avz --delete $WORK_DIR/eRPC/apps $HOST:~/ws_erpc/eRPC
    #rsync -avz --delete $WORK_DIR/eRPC/hello_world $HOST:~/ws_erpc/eRPC
    #rsync -avz --delete $WORK_DIR/eRPC/mica $HOST:~/ws_erpc/eRPC
    rsync -avz --delete $WORK_DIR/eRPC/src $HOST:~/ws_erpc/eRPC
    #rsync -avz --delete $WORK_DIR/eRPC/tests $HOST:~/ws_erpc/eRPC
done

for HOST in "${HOSTS[@]}"; do
    ssh $HOST "cd ~/ws_erpc/eRPC; make -j" &
done

wait