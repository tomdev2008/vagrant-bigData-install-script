#!/bin/bash
source "/vagrant/scripts/common.sh"


function installLocalMySql {
	echo "installing mysql"
	mkdir -p  /get/soft
 	mkdir -p  $MYSQL_DATA_DIR_PATH

	FILE=/vagrant/resources/$MYSQL_ARCHIVE
	tar -xzf $FILE -C /get/soft/
	mv $MYSQL_HOME_DIR_PATH_BEFORE $MYSQL_HOME_DIR_PATH
}
 
function copyMyConf
{ 
	echo "拷贝  mysql my.conf 配置文件 "
	cp -f $MYSQL_RES_DIR/* /etc/
	cp -f $MYSQL_HOME_DIR_PATH/support-files/mysql.server /etc/init.d/mysqlId
}
 

function initMysql
{
	 echo "init mysql  user  "
	 useradd -s /sbin/nologin -M mysql
	 chown -R mysql $MYSQL_DATA_DIR_PATH

    echo "init  mysql  data  "
    $MYSQL_HOME_DIR_PATH/bin/mysql_install_db --basedir=$MYSQL_HOME_DIR_PATH --datadir=$MYSQL_DATA_DIR_PATH --user=mysql 
## 或者下面的语句，记者多删除 mysql /data的初始化文件。
##  $MYSQL_HOME_DIR_PATH/bin/mysqld --initialize --basedir=$MYSQL_HOME_DIR_PATH --datadir=$MYSQL_DATA_DIR_PATH --user=mysql 
}

function startMysql
{
	  /etc/init.d/mysqlId start
}

function setMySqlPSW
{
    echo "手动设置mysql 密码"
	echo "cat /root/.mysql_secret"
	echo "./mysql -uroot -p:5ul#H6dmcwX"
	echo "mysql> set password=password('1234');"
	echo "mysql> use mysql;"
	echo "mysql> select Host,User from user;"
	echo "mysql> GRANT ALL PRIVILEGES ON *.* TO root@'%' identified by '1234';"
	echo "mysql> flush privileges;"
}

echo "setup mysql"

 installLocalMySql 
 copyMyConf 
 initMysql 
 startMysql
 setMySqlPSW

#  supper-file/mysql.server start
# cat /root/.mysql_secret
# ./mysql -uroot -p:5ul#H6dmcwX
# mysql> set password=password('1234');
# mysql> use mysql;
# mysql> select Host,User from user;
# mysql> GRANT ALL PRIVILEGES ON *.* TO root@'%' identified by '1234';
# mysql> flush privileges;



 

#http://dev.mysql.com/doc/refman/5.7/en/resetting-permissions.html
# /etc/init.d/mysqlId  start  --skip-grant-tables
# mysql> FLUSH PRIVILEGES;
# mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';
# 
