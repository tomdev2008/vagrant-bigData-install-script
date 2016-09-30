#!/bin/bash
source "/vagrant/scripts/common.sh"

function installLocalFlume{
	echo "installing flume"
	File=$FLUME_RES_DIR
	tar -xzf $File -C /get/soft
}


echo "setup flume"
installLocalFlume