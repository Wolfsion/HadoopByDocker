#! /bin/bash
# 创建自定义子网192.168.9.0/24

echo create network     # 人机交互信息
docker network create --subnet=192.168.9.0/24 --gateway=192.168.9.1 hadoop      # 创建子网
echo create success     # 人机交互信息 
docker network ls       # 显示所有创建网络
