#!/bin/bash
source "/vagrant/scripts/common.sh"
set -x

function installLocalJava {
	echo "installing oracle jdk"
	FILE=/vagrant/resources/$JAVA_ARCHIVE
	tar -xzf $FILE -C /get/soft
}

function setupJavaEnvVars {
	echo "creating java environment variables"
	echo export JAVA_HOME=$JAVA_HOME_DIR_PATH >> /etc/profile
    echo export JRE_HOME=\${JAVA_HOME}/jre >> /etc/profile
	echo export CLASSPATH=.:\${JAVA_HOME}/lib:\${JAVA_HOME}/jre:\${JAVA_HOME}/lib/dt.jar:\${JAVA_HOME}/lib/tools.jar >> /etc/profile
	echo export PATH=\${JAVA_HOME}/bin:\${PATH} >> /etc/profile
	echo "环境变量设置ok"
}

function installJava {
	#创建 get/soft
	mkdir -p /get/soft
	mkdir -p /get/script
	mkdir -p /get/app
	mkdir -p /get/server

	if resourceExists $JAVA_ARCHIVE; then
	echo "开始安装Java"
		installLocalJava
	else
		echo "没找到java安装包"
	fi
}


function installScala
{
	echo "安装 Scala"
	FILE=/vagrant/resources/$Scala_ARCHIVE
	tar -xzf $FILE -C /get/soft
}
function setupScalaEnvVars
{
   echo "设置 Scala 的环境变量"
   echo export SCALA_HOME=$Scala_DIR_PATH >> /etc/profile
   echo export PATH=\${SCALA_HOME}/bin:\${PATH} >> /etc/profile
}

function installMaven {
	echo "安装maven"
	FILE=/vagrant/resources/$MAVEN_ARCHIVE
	tar -xzf $FILE -C /get/soft
}

function setupMavenEnvVars {
	echo "设置 maven 环境变量"
	echo export M2_HOME=$MAVEN_DIR_PATH >> /etc/profile
	echo export PATH=\${M2_HOME}/bin:\${PATH} >> /etc/profile
	# echo export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m" >> /etc/profile
}



echo "setup java"
installJava
setupJavaEnvVars

installScala
setupScalaEnvVars
echo "设置完毕.请刷新 source /etc/profile"

echo "setup maven"
installMaven
setupMavenEnvVars
