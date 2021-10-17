#! /bin/bash

hdfs namenode -format

$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/bin/mapred --daemon start historyserver
