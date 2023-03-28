# Install Scala on Ubuntu
1. Go to scala official website and use the command to download the cs (Coursier) installer.
2. Execute the cs installer with the following command (note that it seems that the installation needs to pull packages from github, so a proxy is needed to finish the installation):
```shell
(proxychains4 ) ./cs setup
```

# scala project with sbt
1. Open shell, and type the following command (note that this will pull many packages from the remote, so a proxy is needed):
```shell
(proxychains4) sbt new scala/scala3.g8
```

2. Type in the project name.

3. You now have a runnable scala project

# vscode scala extention (mental)

