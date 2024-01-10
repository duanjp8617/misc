#!/bin/bash

gzip -d ./cs-x86_64-pc-linux.gz
mv ./cs-x86_64-pc-linux ./cs
chmod +x ./cs

mkdir ~/.sbt

echo "[repositories]
local
aliyun: https://maven.aliyun.com/repository/public
typesafe: https://repo.typesafe.com/typesafe/ivy-releases/, [organization]/[module]/(scala_[scalaVersion]/)(sbt_[sbtVersion]/)[revision]/[type]s/[artifact](-[classifier]).[ext], bootOnly" > ~/.sbt/repositories