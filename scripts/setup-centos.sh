#!/bin/bash

source "/vagrant/scripts/common.sh"
set -x

START=3
TOTAL_NODES=4

while getopts s:t: option
do
	case "${option}"
	in
		s) START=${OPTARG};;
		t) TOTAL_NODES=${OPTARG};;
	esac
done
#echo "total nodes = $TOTAL_NODES"


function disableFirewall {
	echo "disabling firewall"
	service iptables save
	service iptables stop
	chkconfig iptables off
}


function installSSHPass {
	echo "wget sshpass库"
 	# yum -y install sshpass
 	# http://pkgs.repoforge.org/sshpass/
 	rpm -ivh $SSHPASS_DIR_PATH
}

function overwriteSSHCopyId {
	cp -f $RES_SSH_COPYID_MODIFIED /usr/bin/ssh-copy-id
}

function setupHosts {
	echo "修改host"
    echo  "" > /etc/hosts
	echo  "11.11.11.11 node1" >> /etc/hosts
	echo  "11.11.11.12 node2" >> /etc/hosts
	echo  "11.11.11.13 node3" >> /etc/hosts
	echo  "11.11.11.14 test" >> /etc/hosts
	#echo   "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/nhosts
	#echo   "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/nhosts

}

function createSSHKey {
	echo "生成ssh"
	ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
	cp -f $RES_SSH_CONFIG ~/.ssh
}

function sshCopyId {

	 echo "开始拷贝"

     echo "开始拷贝 node1"
	 ssh-copy-id -i ~/.ssh/id_rsa.pub node1

     echo "开始拷贝 node2"
	 ssh-copy-id -i ~/.ssh/id_rsa.pub node2

     echo "开始拷贝 node3"

     ssh-copy-id -i ~/.ssh/id_rsa.pub node3

     echo "开始拷贝 node4"

     ssh-copy-id -i ~/.ssh/id_rsa.pub test

}

function setupUtilities {
    # so the `locate` command works
    yum install -y mlocate
    updatedb
}

# function installZsh {
 	  # yum -y install zsh
		# tar -xzf /vagrant/resources/zsh-5.2.tar.gz -C /get/soft
# }

# function installOhMyZsh {
#
# }


echo "关闭防火墙"
disableFirewall

echo "开始设置ssh  要设置多次,貌似才起效"
setupHosts

installSSHPass
createSSHKey
overwriteSSHCopyId
sshCopyId

echo "setup utilities"
 # setupUtilities

echo "install zsh"
# installZsh
# installOhMyZsh



echo "centos setup complete"
