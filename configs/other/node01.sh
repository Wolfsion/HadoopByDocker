#! /bin/bash

# 修改主机名，覆盖写
echo "hadoop-node01" > /etc/hostname

# ssh-cpoy-id
# -i:指定公钥文件 
# 将自己公钥分发到其他主机
ssh-cpoy-id -i ~/.ssh/id_rsa.pub root@hadoop_node02
ssh-cpoy-id -i ~/.ssh/id_rsa.pub root@hadoop_node03
