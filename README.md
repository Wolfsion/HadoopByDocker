# Hadoop配置部署——Docker

## 项目介绍

该项目是通过Docker配置部署Hadoop的学习demo，需有一定的Linux和Docker使用基础。

提供了一系列完整的Hadoop3.3.1配置文件，较为清晰地划分了目录，并给出了详细注释。

另外提供了Docker相关的维护脚本，并有日志文件记录。

提供文件上传和查看的操作流程，并测试了红楼梦全文词频统计任务最终给出结果。



## 目录结构

* configs(d):hadoop集群配置文件及各主机内部运行脚本
* sbin(d):主机内hadoop管理脚本
* trash(d):暂时弃用
* wrap(d):配置过程中使用的软件包
* dbin(d):外部docker管理脚本

```sh
dbin/start_container.sh		# 启动Hadoop集群容器
dbin/stop_container.sh		# 停止Hadoop集群容器
dbin/clean_container.sh		# 删除Hadoop集群容器
```

* jars(d):mapreduce计算任务
* log(d):外部管理脚本相关的日志文件



## 开始之前

### 使用的相关依赖包 

* jdk-8u301-linux-x64.tar.gz
* hadoop-3.3.1.tar.gz

### 配置环境

* CentOS Linux release 7.7.1908
* Docker version 20.10.8

### 使用到的Docker命令

* docker build
* docker ps
* docker run
* docker exec

### 辅助说明

* .sh文件中的line 1:#!/bin/bash   表示使用/bin/bash路径下的shell来解释执行脚本
* 可通过` netstat -ntlp `查看端口占用情况



## 配置内容

### Docker相关

* network
  * 子网：192.168.9.0/24
  * 网关：192.168.9.1
  * node01：192.169.9.9   node02：192.168.9.19    node03：192.169.9.199

* outer volume 



### Hadoop相关

* node1-NameNode + jobhistory + DataNode + NodeManager
  * 10020-jobhistory(inner)
  * 29888:19888-jobhistory for Web
  * 8020-NameNode(inner)
  * 9880:9870-NameNode for Web

* node2-ResurceManager + DataNode + NodeManager
  * 8098:8088-yarn for Web

* node3-SecondaryNameNode + DataNode + NodeManager
  * 9878:9868-SecondaryNode for Web

* log
  * path: /var/log/hadoop



## 配置步骤

1. 执行` dbin/create_network.sh`创建Hadoop子网
2. 执行` build_docker_image.sh `构建hadoop镜像
3. 执行` dbin/start_container.sh `启动hadoop集群，注意只能首次执行，之后执行` dbin/restart_container.sh `
4. 若主机访问` localhost:9880 `,` localhost:8098 `,` localhost:9878 `,` localhost:29888 `可进入Web界面，说明配置成功



## 测试使用

* HDFS-文件上传与下载
* mapreduce-红楼梦词频统计



## 待留

jars, log, 外部卷

测试使用部分



## 参考内容

1.  Docker官方接口文档：https://docs.docker.com/reference/
2.  Hadoop官方参考文档：https://hadoop.apache.org/docs/stable/
3. Docker安装Hadoop集群：https://mp.weixin.qq.com/s/HnaMbx0ZC1ZOeOV1NyyKjw
4. Hadoop 3.x：https://b23.tv/R1wqen
5. Hadoop 入门：https://b23.tv/eHXvGV

