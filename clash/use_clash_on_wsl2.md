# 一、配置Clash
找到General > Allow LAN，打开开关。

# 二、配置防火墙
打开控制面板，找到系统和安全 > Windows Defender 防火墙 > 允许应用通过 Windows 防火墙，勾选上所有Clash相关的应用，包括但不限于Clash for Windows、clash-win64等。

# 三、配置WLS2

1. 创建.proxy文件
```shell
touch ~/.proxy
```

2. 添加以下内容
```shell
#!/bin/bash
hostip=$(cat /etc/resolv.conf |grep -oP '(?<=nameserver\ ).*')
export https_proxy="http://${hostip}:7890"
export http_proxy="http://${hostip}:7890"
export all_proxy="socks5://${hostip}:7890"
```

3. 编辑.bashrc或.zshrc文件，在文末添加一下内容
```shell
source ~/.proxy
```

# 四、测试
```shell
wget www.google.com
```