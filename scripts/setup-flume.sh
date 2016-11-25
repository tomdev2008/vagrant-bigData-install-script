#!/bin/bash

source "/vagrant/scripts/common.sh"

set -x


function installLocalFlume
{
	echo "tar flume"
	echo "$FLUME_ARCHIVE"
	FILE=/vagrant/resources/$FLUME_ARCHIVE
	tar -xzf $FILE -C /get/soft
}

function  setupFlumeEnvVars
{
	echo "set flume env"
	echo export FLUME_HOME=/get/soft/$FLUME_DIR_PATH >> /etc/profile
	echo export FLUME_CONF_DIR=$FLUME_HOME/conf >> /etc/profile
	echo export PATH=\${FLUME_HOME}/bin:\${PATH} >> /etc/profile
}
function copyFlumeTestConf {
	echo "copy flume test conf dir"

}

echo "setup flume"
installLocalFlume
setupFlumeEnvVars
copyFlumeTestConf

echo "验证 flume-ng version"
