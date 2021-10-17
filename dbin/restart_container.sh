#! /bin/bash
# 重启所有Hadoop容器

echo stop containers        # 人机交互信息 
docker stop hadoop-node01        # 停止hadoop-node01容器
docker stop hadoop-node02
docker stop hadoop-node03

echo start containers       # 人机交互信息
docker start hadoop-node01       # 启动hadoop-node01容器
docker start hadoop-node02
docker start hadoop-node03

sleep 5     # 暂停5s
docker exec hadoop-node01 /bin/bash /usr/local/hadoop-3.3.1/exSbin/restart-hdfs-node01.sh        # 进入node01，启动HDFS
docker exec hadoop-node02 /bin/bash /usr/local/hadoop-3.3.1/exSbin/restart-yarn-node02.sh        # 进入node02，启动YARN

echo  containers started        # 人机交互信息

docker ps -a        # 显示所有容器


