1. Install ```build-essential``` and ```meson```.

2. Install ```python3-pip``` package, then install ```elftools``` with pip3:
```shell
sudo pip3 install pyelftools
```

3. Configure dpdk with meson, and enable all the examples:
```shell
meson -Dexamples=all build
```

4. Build dpdk:
```shell
ninja -C build
```