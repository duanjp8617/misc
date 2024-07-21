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

# 五、问题处理
上述流程可能出现问题，具体而言，wsl2.2版本以后，会启用dns tunneling，导致流量无法正确到达运行在主机内的clash for windows，解决方法如下：

1. WSL 2.2.1 版本默认启用了 DNS 隧道, 会导致该方法失效。如果你正在使用该版本可以参照官方文档配置，在 C:\Users\<UserName>\.wslconfig 文件中 (如果不存在就手动创建一个) 加入以下内容以关闭 DNS 隧道:
```shell
[wsl2]
dnsTunneling=false
```

2. 你可以执行 wsl -v 查看你的 WSL 版本。
