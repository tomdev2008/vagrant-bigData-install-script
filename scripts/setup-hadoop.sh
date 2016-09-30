#!/bin/bash
source "/vagrant/scripts/common.sh"

function installHadoop {
	mkdir -p /get/soft
	echo "install hadoop from local file"
	FILE=/vagrant/resources/$HADOOP_ARCHIVE
	tar -xzf $FILE -C /get/soft
}
 
function setupHadoop {
	echo "创建 hadoop 目录"
	mkdir -p /var/hadoop
	mkdir -p /var/hadoop/hadoop-datanode
	mkdir -p /var/hadoop/hadoop-namenode
	mkdir -p  /var/hadoop/mr-history
	mkdir -p /var/hadoop/mr-history/done
	mkdir -p  /var/hadoop/mr-history/tmp
    mkdir -p $HADOOP_CONF
	mkdir -p $HADOOP_RES_DIR

	echo "拷贝  hadoop 配置文件 "
 

	cp -f $HADOOP_RES_DIR/* $HADOOP_CONF
}

function setupEnvVars {
	echo "创建 hadoop 环境变量"
    
     echo   export HADOOP_PREFIX=/get/soft/$HADOOP_VERSION >> /etc/profile
     echo   export HADOOP_HOME=/get/soft/$HADOOP_VERSION >> /etc/profile
     echo   export HADOOP_YARN_HOME=\${HADOOP_PREFIX} >> /etc/profile
     echo   export HADOOP_CONF_DIR=\${HADOOP_CONF} >> /etc/profile
     echo   export YARN_LOG_DIR=\${HADOOP_YARN_HOME}/logs >> /etc/profile
     echo   export YARN_IDENT_STRING=root >> /etc/profile
     echo   export HADOOP_MAPRED_IDENT_STRING=root >> /etc/profile
     echo   export PATH=\${HADOOP_PREFIX}/bin:\${PATH} >> /etc/profile
     echo   export PATH=\${HADOOP_PREFIX}/sbin:\${PATH} >> /etc/profile
 	 echo   export HADOOP_COMMON_LIB_NATIVE_DIR=\${HADOOP_HOME}/lib/native >> /etc/profile
     echo	export HADOOP_OPTS="-Djava.library.path=${HADOOP_HOME}/lib" >> /etc/profile

}

function setupCopyFile
{
	tar -xf /vagrant/resources/hadoop-native-64-2.6.0.tar -C  /get/soft/$HADOOP_VERSION/lib/native/
}

echo "开始安装 hadoop"
 installHadoop

echo "开始设置 hadoop"
setupHadoop

echo "开始设置 hadoop 环境变量"
setupEnvVars

echo "覆盖hadoop lib/native"
 setupCopyFile