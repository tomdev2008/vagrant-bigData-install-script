#!/bin/bash

source "/vagrant/scripts/common.sh"
 
# 1. 启动zookeeper
zookeeper_start="/get/soft/zookeeper-3.4.7/bin/zkServer.sh start /get/soft/zookeeper-3.4.7/conf/zoo.cfg"
eval ${zookeeper_start}

# 2. kafka
kafka_start="nohup /get/soft/kafka_2.11-0.10.0.0/bin/kafka-server-start.sh /get/soft/kafka_2.11-0.10.0.0/config/server11.properties>/dev/null 2>&1 &"
eval ${kafka_start}

# 3. hadoop
hadoop_hdfs_start="/get/soft/hadoop-2.6.3/sbin/start-dfs.sh"
hadoop_yarn_start="/get/soft/hadoop-2.6.3/sbin/start-yarn.sh"
eval ${hadoop_hdfs_start}
eval ${hadoop_yarn_start}

# 4. spark
spark_start="/get/soft/spark-1.6.1-bin-hadoop2.6/sbin/start-all.sh"
eval ${spark_start}

# 5. 