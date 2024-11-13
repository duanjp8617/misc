SRC=/home/user/CK-TOOLS/dataset-imagenet-ilsvrc2012-val-min
PREFIX=ILSVRC2012_val_

for i in $(seq -f "%08g" 1 100); do
  cp "$SRC/$PREFIX${i}.JPEG" ./
done