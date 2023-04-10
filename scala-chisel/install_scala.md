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

# Sbt change to aliyun repository
1. Create the following file ```~/.sbt/repositories```.
2. Add the following content to the ```repositories``` file:
```shell
[repositories]
local
aliyun: https://maven.aliyun.com/repository/public
typesafe: https://repo.typesafe.com/typesafe/ivy-releases/, [organization]/[module]/(scala_[scalaVersion]/)(sbt_[sbtVersion]/)[revision]/[type]s/[artifact](-[classifier]).[ext], bootOnly
```
```shell
[repositories]
local
aliyun: https://maven.aliyun.com/repository/public
typesafe: https://repo.typesafe.com/typesafe/ivy-releases, 
          [organization]/[module]/(scala_[scalaVersion]/)
          (sbt_[sbtVersion]/)[revision]/[type]s/
          [artifact](-[classifier]).[ext], bootOnly
ivy-sbt-plugin: https://dl.bintray.com/sbt/sbt-plugin-releases/,
          [organization]/[module]/(scala_[scalaVersion]/)
          (sbt_[sbtVersion]/)[revision]/[type]s/
          [artifact](-[classifier]).[ext]
```

3. Use the following command to launch ```sbt```
```shell
sbt -Dsbt.override.build.repos=true
```
4. Several useful commands for checking sbt project properties:
```shell
show overrideBuildResolvers
show fullResolvers
```

# Scala bloop build server:

1. Use the following command to install bloop. However, it seems that bloop needs to download from github. So just use the proxychains4.
```shell
export COURSIER_REPOSITORIES="ivy2Local|central|https://maven.aliyun.com/repository/public"
cs install bloop
```

2. After installation, run the following command once:
```shell
bloop about
```

3. sbt a new project, and then follow the intrusctions at the bloop website to manually set up the bloop.

# Metals config:
Add the following repos to the metals setting to accelerate metals load time:
```shell
https://maven.aliyun.com/repository/public  -> Add this to the coursier mirror
sonatype:releases                           -> Add this to the custom repositories
```