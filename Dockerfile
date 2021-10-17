# 基于centos7构建
FROM centos:7
MAINTAINER La  la_wolfsion@163.com

# 标示使用的JDK和Hadoop包的版本号，镜像版本号为1.0
LABEL JDKVersion="8u301-x64"
LABEL HadoopVersion="3.3.1"
LABEL version="1.0"

# 安装扩展的软件包
# net-tools:基本的网络工具集，集成常用的网络管理命令(ifconfig,netstat,arp,route等)
# openssh:远程桌面链接，提供免密登录
RUN yum -y install net-tools
RUN yum -y install openssh-server openssh-clients

# 清除yum下载的软件包和header缓存
RUN yum clean all       

# 配置SSH免密登录
# ssh-keygen
# -q:不输出提示信息
# -t:指定使用的密码学算法
# -b:指定密钥对的长度
# -f:指定生成密钥文件的路径
# -N：提供新密码，空表示不需要密码(-N '')
RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
RUN ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N ''

# 生成集群间通信认证的密钥对
RUN ssh-keygen -f /root/.ssh/id_rsa -N ''

# authorized_keys用于记录可信终端的密钥
# 将自己的公钥写入到可信名单中
RUN touch /root/.ssh/authorized_keys
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# 修改root用户密码
RUN echo "root:hp123" | chpasswd

# 保存默认配置文件并拷贝SSH相关的配置文件到镜像中
RUN mv /etc/ssh/ssh_config /etc/ssh/ssh_config.backup
COPY configs/other/ssh_config /etc/ssh/ssh_config

# WORKDIR 设置镜像的工作目录而非构建环境的工作目录

# 添加解压JDK并设置环境变量
ADD wrap/jdk-8u301-linux-x64.tar.gz /usr/local/
ENV JAVA_HOME /usr/local/jdk1.8.0_301
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

# 添加解压Hadoop并设置环境变量
ADD wrap/hadoop-3.3.1.tar.gz /usr/local
ENV HADOOP_HOME /usr/local/hadoop-3.3.1

# 将环境变量添加到PATH中
ENV PATH $HADOOP_HOME/bin:$JAVA_HOME/bin:$PATH

# 拷贝Hadoop相关的配置文件和管理脚本到镜像中
COPY configs/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
COPY configs/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY configs/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY configs/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
COPY configs/workers $HADOOP_HOME/etc/hadoop/workers

RUN mkdir -p $HADOOP_HOME/exSbin
COPY sbin/start-hdfs-node01.sh $HADOOP_HOME/exSbin/start-hdfs-node01.sh
COPY sbin/start-yarn-node02.sh $HADOOP_HOME/exSbin/start-yarn-node02.sh
COPY sbin/restart-hdfs-node01.sh $HADOOP_HOME/exSbin/restart-hdfs-node01.sh
COPY sbin/restart-yarn-node02.sh $HADOOP_HOME/exSbin/restart-yarn-node02.sh

# 增加执行权限
RUN chmod 700 $HADOOP_HOME/exSbin/start-hdfs-node01.sh
RUN chmod 700 $HADOOP_HOME/exSbin/start-yarn-node02.sh
RUN chmod 700 $HADOOP_HOME/exSbin/restart-hdfs-node01.sh
RUN chmod 700 $HADOOP_HOME/exSbin/restart-yarn-node02.sh

# 创建数据目录
# mkdir
# -p:创建多级目录
# && \:仅使用一个RUN关键字，构建镜像时合并为同一层
RUN mkdir -p /opt/hadoop-3.3.1/dfs/data && \
    mkdir -p /opt/hadoop-3.3.1/dfs/name && \
    mkdir -p /opt/hadoop-3.3.1/data/tmp && \
    mkdir -p /var/log/hadoop

# 开启SSH 22 端口
EXPOSE 22

# 启动容器时执行的脚本文件
CMD ["/usr/sbin/sshd","-D"]