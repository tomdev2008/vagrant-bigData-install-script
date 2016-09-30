#!/bin/bash

# http://www.cloudera.com/content/cloudera/en/documentation/cdh4/v4-2-0/CDH4-Installation-Guide/cdh4ig_topic_18_4.html

source "/vagrant/scripts/common.sh"

function installHive {
 	FILE=/vagrant/resources/$HIVE_ARCHIVE
	tar -xzf $FILE -C /get/soft
	
 	mkdir $HIVE_DIR_PATH/logs 
 	mkdir $HIVE_DIR_PATH/logs/exec 
	mkdir $HIVE_DIR_PATH/derby/
}
  
function setupHive {
	echo "拷贝配置文件"
	cp -f $HIVE_RES_DIR/* $HIVE_CONF
	# cp /vagrant/resources/hive/hive-hwi-1.2.1.war  $HIVE_DIR_PATH/lib
    cp /vagrant/resources/hive/mysql-connector-java-5.1.38-bin.jar  $HIVE_DIR_PATH/lib
}

function setupEnvVars {
	 
	echo export HIVE_HOME=$HIVE_DIR_PATH  >> /etc/profile
	echo export HIVE_CONF_DIR=$HIVE_CONF  >> /etc/profile
    echo export PATH=\${HIVE_HOME}/bin:\${PATH} >> /etc/profile 
}

function runHiveServices {
	echo "running hive metastore"
    nohup hive --service metastore < /dev/null > /usr/local/hive/logs/hive_metastore_`date +"%Y%m%d%H%M%S"`.log 2>&1 &

	echo "running hive server2"
    nohup hive --service hiveserver2 < /dev/null > /usr/local/hive/logs/hive_server2_`date +"%Y%m%d%H%M%S"`.log 2>&1 &
}
function initHiveSchema
{
	 echo "init hive metastore"
	 echo "mysql  create hive first"
	 cp /get/soft/apache-hive-1.2.1-bin/lib/jline-2.12.jar  /get/soft/hadoop-2.6.3/share/hadoop/yarn/lib/
    # cp /hive/apache-hive-1.1.0-bin/lib/jline-2.12.jar /hadoop-2.5.2/share/hadoop/yarn/lib


	# /schematool -initSchema -dbType mysql  -userName=root -passowrd=1234
	# ${HIVE_HOME}/bin/schematool -initSchema -dbType mysql  -userName=root -passowrd=1234
}

# 拷贝mysql驱动 到 lib文件夹里面
# 写入mysql 链接地址，以及配置hadoop 目录
 
echo "安装 hive"

installHive
setupHive
setupEnvVars
# runHiveServices
initHiveSchema
echo "Hive 安装  完成"
# jar cvfM0 hive-hwi-2.0.1.war -C web/ .
