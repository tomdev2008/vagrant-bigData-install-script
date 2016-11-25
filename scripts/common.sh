#!/bin/bash

#java
JAVA_ARCHIVE=jdk-8u65-linux-x64.tar.gz
JAVA_HOME_DIR_PATH=/get/soft/jdk1.8.0_65

#mysql
MYSQL_ARCHIVE_FILENAME=mysql-5.7.13-linux-glibc2.5-x86_64
MYSQL_ARCHIVE=$MYSQL_ARCHIVE_FILENAME.tar.gz
MYSQL_HOME_DIR_PATH_BEFORE=/get/soft/$MYSQL_ARCHIVE_FILENAME
MYSQL_HOME_DIR_PATH=/get/soft/mysql
MYSQL_DATA_DIR_PATH=/get/db/mysql
MYSQL_RES_DIR=/vagrant/resources/mysql

#maven
MAVEN_ARCHIVE=apache-maven-3.3.9-bin.tar.gz
MAVEN_DIR_PATH=/get/soft/apache-maven-3.3.9

#scala
Scala_ARCHIVE=scala-2.10.5.tgz
Scala_DIR_PATH=/get/soft/scala-2.10.5

#hadoop
HADOOP_VERSION=hadoop-2.6.3
HADOOP_ARCHIVE=$HADOOP_VERSION.tar.gz
HADOOP_PREFIX=/get/soft/$HADOOP_VERSION
HADOOP_CONF=$HADOOP_PREFIX/etc/hadoop
#HADOOP_MIRROR_DOWNLOAD=../resources/$HADOOP_ARCHIVE
HADOOP_RES_DIR=/vagrant/resources/hadoop


# hive
HIVE_VERSION=hive-1.2.1-bin
HIVE_ARCHIVE=apache-$HIVE_VERSION.tar.gz
HIVE_RES_DIR=/vagrant/resources/hive
HIVE_DIR_PATH=/get/soft/apache-$HIVE_VERSION/
HIVE_CONF=$HIVE_DIR_PATH/conf



#zookeeper
ZOOKEEPER_VERSION=zookeeper-3.4.7
ZOOKEEPER_ARCHIVE=$ZOOKEEPER_VERSION.tar.gz
#ZOOKEEPER_MIRROR_DOWNLOAD=../resources/zookeeper-3.4.7.tar.gz
ZOOKEEPER_RES_DIR=/vagrant/resources/zookeeper
ZOOKEEPER_CONF_DIR=/get/soft/$ZOOKEEPER_VERSION/conf
ZOOKEEPER_DATA_DIR=/get/soft/$ZOOKEEPER_VERSION/zookeeper_data


#kafka
KAFKA_VERSION=kafka_2.11-0.10.0.0
KAFKA_ARCHIVE=$KAFKA_VERSION.tgz
KAFKA_RES_DIR=/vagrant/resources/kafka
KAFKA_CONF=/get/soft/$KAFKA_VERSION/config

#Hase
HBASE_VERSION=hbase-1.1.2
HBASE_ARCHIVE=$HBASE_VERSION-bin.tar.gz
HBASE_RES_DIR=/vagrant/resources/hbase
HBASE_CONF=/get/soft/$HBASE_VERSION/conf

#flume   apache-flume-1.6.0-bin.tar.gz  apache-flume-1.6.0-bin
FLUME_VERSION=flume-1.6.0
FLUME_DIR_PATH=apache-$FLUME_VERSION-bin
FLUME_ARCHIVE=$FLUME_DIR_PATH.tar.gz
FLUME_RES_DIR=/vagrant/resources/flume
#FLUME_CONF=/get/soft/$FLUME_VERSION/conf


#spark
#spark-1.6.0-bin-hadoop2.6
#SPARK_VERSION=spark-1.5.2
SPARK_VERSION=spark-1.6.1
SPARK_DIR_PATH=$SPARK_VERSION-bin-hadoop2.6
SPARK_ARCHIVE=$SPARK_DIR_PATH.tgz
SPARK_RES_DIR=/vagrant/resources/spark
SPARK_CONF_DIR=/get/soft/$SPARK_DIR_PATH/conf

#ssh
SSHPASS_DIR_PATH=/vagrant/resources/sshpass-1.05-1.el6.rf.x86_64.rpm
SSH_RES_DIR=/vagrant/resources/ssh
RES_SSH_COPYID_ORIGINAL=$SSH_RES_DIR/ssh-copy-id.original
RES_SSH_COPYID_MODIFIED=$SSH_RES_DIR/ssh-copy-id.modified
RES_SSH_CONFIG=$SSH_RES_DIR/config

function resourceExists {
	FILE=/vagrant/resources/$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

function fileExists {
	FILE=$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

#echo "common loaded"
