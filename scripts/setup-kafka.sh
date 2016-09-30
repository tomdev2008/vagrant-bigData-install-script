#!/bin/bash
source "/vagrant/scripts/common.sh"

function installKafka {
	echo "安装 kafka"
	FILE=/vagrant/resources/$KAFKA_ARCHIVE
	tar -xzf $FILE -C /get/soft
}
 
function setupKafka {
	echo "拷贝kafka配置文件"
    # mkdir $HADOOP_CONF
	cp -f $KAFKA_RES_DIR/* $KAFKA_CONF
}

function setupEnvVars {
	echo "设置环境变量"
	#cp -f $KAFKA_RES_DIR/kafka.sh /etc/profile.d/kafka.sh
     echo export KAFKA_PREFIX=/get/soft/$KAFKA_VERSION >> /etc/profile
     echo export KAFKA_CONF_DIR=\${KAFKA_PREFIX}/config >> /etc/profile
     echo export PATH=\${KAFKA_PREFIX}/bin:\${PATH} >> /etc/profile
}

 
 #ln -s /usr/local/$KAFKA_VERSION /usr/local/kafka
 

echo "setup kafka"
installKafka
setupKafka
setupEnvVars