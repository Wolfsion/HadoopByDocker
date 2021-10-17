#! /bin/bash

# 修改主机名
echo "hadoop-node02" > /etc/hostname

# ssh-cpoy-id
# -i:指定公钥文件 
# 将自己公钥分发到其他主机
ssh-cpoy-id -i ~/.ssh/id_rsa.pub root@hadoop_node01
ssh-cpoy-id -i ~/.ssh/id_rsa.pub root@hadoop_node03