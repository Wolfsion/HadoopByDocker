#! /bin/bash
# 根据构建的hadoop镜像启动容器，并启动Hadoop集群服务

echo "start containers"       # 人机交互信息

echo "start hadoop-node01 container ..."       # 人机交互信息
# docker run 
# -d:后台方式运行
# -i:交互方式运行
# -t:重新分配一个伪输入终端
# -p:指定内外端口映射
# --restart:在容器退出时总是重启容器
# --net:指定子网
# --ip:指定静态ip地址
# --privileged:container内的root拥有真正的root权限
# --name:指定容器名
# --hostname:指定主机名
docker run --add-host hadoop-node02:192.168.9.19 --add-host hadoop-node03:192.168.9.199 \
    -d --restart=always --net hadoop --ip 192.168.9.9 \
    --privileged -p 9880:9870 -p 29888:19888 \
    --name hadoop-node01 --hostname hadoop-node01 la/hadoop 

echo "start hadoop-node02 container..."      # 人机交互信息
docker run --add-host hadoop-node01:192.168.9.9 --add-host hadoop-node03:192.168.9.199 \
    -d --restart=always --net hadoop --ip 192.168.9.19 \
    --privileged  -p 8098:8088 \
    --name hadoop-node02 --hostname hadoop-node02 la/hadoop

echo "start hadoop-node03 container..."      # 人机交互信息
docker run --add-host hadoop-node01:192.168.9.9 --add-host hadoop-node02:192.168.9.19 \
    -d --restart=always --net hadoop --ip 192.168.9.199 \
    --privileged -p 9878:9868 \
    --name hadoop-node03 --hostname hadoop-node03 la/hadoop


sleep 5     # 暂停5s
docker exec hadoop-node01 /bin/bash /usr/local/hadoop-3.3.1/exSbin/start-hdfs-node01.sh        # 进入node01，启动HDFS
docker exec hadoop-node02 /bin/bash /usr/local/hadoop-3.3.1/exSbin/start-yarn-node02.sh        # 进入node02，启动YARN

echo finished       # 人机交互信息
docker ps       # 显示当前所有处于运行状态的容器
