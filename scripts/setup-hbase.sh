#!/bin/bash
source "/vagrant/scripts/common.sh"
set -x

function installHBase {
	echo "安装本地HBase"
	FILE=/vagrant/resources/$HBASE_ARCHIVE
	tar -xzf $FILE -C /get/soft
}

function setupHBase {
	echo "复制HBase配置文件"
	cp -f /vagrant/resources/hbase/regionservers $HBASE_CONF
	cp -f /vagrant/resources/hbase/hbase-env.sh $HBASE_CONF
    cp -f /vagrant/resources/hbase/hbase-site.xml $HBASE_CONF
    cp -f /vagrant/resources/hbase/core-site.xml $HBASE_CONF
    cp -f /vagrant/resources/hbase/hdfs-site.xml $HBASE_CONF

}

function setupEnvVars {
    echo "设置HBase环境变量"
    echo export HBASE_HOME=/get/soft/$HBASE_VERSION/  >> /etc/profile
    echo export PATH=\${HBASE_HOME}/bin:\${PATH} >> /etc/profile
}

installHBase
setupHBase
setupEnvVars
