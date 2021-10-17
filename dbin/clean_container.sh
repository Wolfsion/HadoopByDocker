#!/bin/bash
# 删除已启动的hadoop容器(删除所有容器)

echo "clean containers"       # 人机交互信息，控制台输出:clean containers

docker ps -a        # 显示当前所有启动的容器

# docker ps
# -f:过滤器筛选，此处筛选处于退出状态的容器
docker rm $(docker ps -q -f status=exited)      # 删除所有处于退出状态的容器

docker ps -a        # 显示当前所有启动容器，用于验证
