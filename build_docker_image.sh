#! /bin/bash
# 构建hadoop的docker镜像

echo "build la/hadoop images"     # 人机交互信息，控制台输出:build centos-hadoop images

# docker build
# -t:指代构建目标镜像的名字
# .:构建路径为当前路径 ?    
docker build -f=Dockerfile -t=la/hadoop .       # 基于同路径下的dockerfile文件构建镜像 