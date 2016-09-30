#!/bin/bash
source "/vagrant/scripts/common.sh"

function installSpark {
	echo "安装本地spark"
	FILE=/vagrant/resources/$SPARK_ARCHIVE
	tar -xzf $FILE -C /get/soft 
}

function setupSpark {
	echo "复制spark配置文件"
	cp -f /vagrant/resources/spark/slaves $SPARK_CONF_DIR
	cp -f /vagrant/resources/spark/spark-env.sh $SPARK_CONF_DIR
}

function setupEnvVars {
	echo "设置spark环境变量"
    echo export SPARK_HOME=/get/soft/$SPARK_DIR_PATH >> /etc/profile
    echo export PATH=\${SPARK_HOME}/bin:\${SPARK_HOME}/sbin:\${PATH} >> /etc/profile
}

installSpark

setupSpark

setupEnvVars