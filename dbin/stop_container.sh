#! /bin/bash
# 停止所有Hadoop容器

echo stop containers        # 人机交互信息
docker stop hadoop-node01        # 停止容器
docker stop hadoop-node02
docker stop hadoop-node03

docker ps -a        # 显示所有容器


