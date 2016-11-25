
### 常用安装脚本

# 需要去下载附加软件包

1. 需要安装vagrant
2. 安装virtualBox 


#采取离线安装方式，所以。你需要去下载扩展包到本地，覆盖resources

链接: https://pan.baidu.com/s/1hsNVZKC 密码: s3fg

#采取自选择安装方式，并不是所有软件都需要安装上

 
 
 
 
 
 
 
 title: 快速搭建本地分布式大数据测试环境
tags:
  - vagrant
date: 2016-11-23 16:09:37
---
 

> 注意: 本文操作实验会花费20-60分钟

本地搭建分布式环境有两种: **Vagrant**和**Docker**   
区别就是 Vagrant 是开了几个虚拟机，每个机器都在运行，跟Docker进程隔离不一样。
本次介绍多台虚拟机快速搭建


## vagrant
 
vagrant , 是一个基于Ruby的工具，用于创建和部署虚拟化开发环境。它可以借助VirtualBox/VMware 快速虚拟化系统. 还可以自己打包镜像,分发给其他人.
假如 打造一个本地测试环境,可以用此封装一个.
 

#### 1. 安装 VirtualBox vagrant

>vagrant官网:        https://www.virtualbox.org/wiki/Downloads<br>
>VirtualBox 官网:    https://www.vagrantup.com/

#### 2. 配置存放boxes默认存储目录 的环境变量
<br>

```
export VAGRANT_HOME=~/zenmen/boxes
```

#### 3. vagrant安装后,可以简单看下命令,如关机,重启,启动,状态,以及添加box等
<br>

```
Usage: vagrant [options] <command> [<args>]

    -v, --version                    Print the version and exit.
    -h, --help                       Print this help.

Common commands:
     box             manages boxes: installation, removal, etc.
     connect         connect to a remotely shared Vagrant environment
     destroy         stops and deletes all traces of the vagrant machine
     global-status   outputs status Vagrant environments for this user
     halt            stops the vagrant machine
     help            shows the help for a subcommand
     init            initializes a new Vagrant environment by creating a Vagrantfile
     login           log in to HashiCorp's Atlas
     package         packages a running vagrant environment into a box
     plugin          manages plugins: install, uninstall, update, etc.
     port            displays information about guest port mappings
     powershell      connects to machine via powershell remoting
     provision       provisions the vagrant machine
     push            deploys code in this environment to a configured destination
     rdp             connects to machine via RDP
     reload          restarts vagrant machine, loads new Vagrantfile configuration
     resume          resume a suspended vagrant machine
     share           share your Vagrant environment with anyone in the world
     snapshot        manages snapshots: saving, restoring, etc.
     ssh             connects to machine via SSH
     ssh-config      outputs OpenSSH valid configuration to connect to the machine
     status          outputs status of the vagrant machine
     suspend         suspends the machine
     up              starts and provisions the vagrant environment
     version         prints current and latest Vagrant version

For help on any individual command run `vagrant COMMAND -h`

Additional subcommands are available, but are either more advanced
or not commonly used. To see all subcommands, run the command
`vagrant list-commands`.
```


#### 4. 下载 Provider 为VirtualBox的镜像 ,就是虚拟机镜像,可以在线安装,也可以下载到本地后.离线  添加 

```
vagrant box add
```

<br>
>boxes :
>1. http://www.vagrantbox.es/
>2. https://atlas.hashicorp.com/boxes/search
 
#### 5. 添加镜像到vagrant 后.. vagrant up就可以启动起来了,不过启动前,需要 改配置文件 `Vagrantfile`
<br>
 
```
config.vm.define  "node1" do |vb|
      config.vm.provider "virtualbox" do |v|
           v.memory = 3500
          v.cpus = 2
      end
      vb.vm.host_name = "node1"
      vb.vm.network :private_network, ip: "11.11.11.11"
      vb.vm.box = "centos"
  end
    

  config.vm.define  "node2" do |vb|  
     config.vm.provider "virtualbox" do |v|
        v.memory = 3500
        v.cpus = 2
    end 
    vb.vm.host_name = "node2"
    vb.vm.network :private_network, ip: "11.11.11.12"
    vb.vm.box = "centos" 
  end


config.vm.define  "node3" do |vb| 
     config.vm.provider "virtualbox" do |v|
        v.memory = 3500
        v.cpus = 2
    end 
  vb.vm.host_name = "node3"
  vb.vm.network :private_network, ip: "11.11.11.13"
  vb.vm.box = "centos" 
end

config.vm.define  "test" do |vb|    
     config.vm.provider "virtualbox" do |v|
         v.memory = 1000
         v.cpus = 1
   end 
   vb.vm.host_name = "test"
   vb.vm.network :private_network, ip: "11.11.11.14"    
   vb.vm.box = "centos" 
end

config.ssh.username = "root"
config.ssh.password = "vagrant" 
```

>配置文件 基于 Ruby的写法.分别启动了四台虚拟机,分别是node1,node2,node3,test 以及对应的ip ,内存和cpu占用 .
>最后配置了ssh 的默认用户名和密码 .这样一个配置就可以更改完了.



#### 6. 但上面仅仅是启动了四台空的虚拟机.如果想启动后.自动启动脚本安装或者测试.则可以这样:
<br>

``` 
if i == 1
				node.vm.provision "shell" do |s|
					s.path = "scripts/setup-centos-ssh.sh"
					s.args = "-s 23 -t #{max_num}"
				end
			end
			if i == 2
				node.vm.provision "shell" do |s|
					s.path = "scripts/setup-centos-ssh.sh"
					s.args = "-s 22 -t #{max_num}"
				end
			end
			node.vm.provision "shell", path: "scripts/setup-java.sh"
			node.vm.provision "shell", path: "scripts/setup-maven.sh"
```

>本篇文章内,会将分开执行脚本.为了更清晰些.

#### 7.启动
<br>

这时候切换到`VAGRANT_HOME` 目录.启动`vagrant up` 就可以分别看到 四台定义的虚拟机分别启动.
and 共享目录为
```
......
node1: /vagrant => /Users/abujj/zenmen/boxes
......

```

<br><br>
这时候,打开VirtualBox GUI ,就可以看到 四台虚拟机已经处于启动状态 

![图片](/img/20161122110019.png)

<br>
>如果你用的是 iTerm2 . 可以选择Toggle Broadcasting Input  .这时候.多个窗口的命令将同步,很方便<br>
>如果是Windows ,推荐用 <br>
>如果是Linux ,推荐用 <br>
>可以看到.是可以ssh连到分别对应的四台机器上的.

![图片](/img/20161122110422.png)
<br>


##安装环境

#### 1.切换到 `cd /vagrant/scripts/` 目录.会看到脚本的位置
<br>

```
 cd /vagrant/scripts/ 
 total 80
-rwxr-xr-x. 1 root root  2606 Oct 10 08:06 common.sh              
-rwxr-xr-x. 1 root root  2094 Oct 10 09:11 setup-centos.sh
-rwxr-xr-x. 1 root root  1780 Oct  8 10:56 setup-hadoop.sh
-rwxr-xr-x. 1 root root  1740 Oct  8 10:56 setup-java.sh
-rwxr-xr-x. 1 root root   722 Oct  8 10:56 setup-kafka.sh
-rwxr-xr-x. 1 root root  1949 Oct  8 10:56 setup-mysql.sh
-rwxr-xr-x. 1 root root   603 Oct  8 10:56 setup-spark.sh
-rwxr-xr-x. 1 root root  1298 Oct  8 10:56 setup-zookeeper.sh

```


#### 2.首先四台虚拟机初始化centos
<br>

```
 ./setup-centos.sh

```

> 打开脚本可以看到主要设置了:<br>
> ssh 无密码互通<br>
> Host 配置 <br>
> 关闭防火墙 <br>


 
#### 3. 安装JDK等

```
 ./setup-java.sh

```

> 打开脚本可以看到主要设置了:<br>
> JDK<br>
> Scala<br>
> Maven (有时候会编译代码)<br>

#### 4. zookeeper安装

```
./setup-zookeeper.sh 1  

```

> 每台执行 后面跟的id是不一样的. 比如 1 2 3 4

#### 5. kafka 安装
<br>

```
 ./setup-kafka.sh

```

#### 6. hadoop 安装
<br>


```
  ./setup-hadoop.sh
```

> hadoop 安装还是比较繁琐的. 可以打开脚本看下


#### 7. 安装spark
<br>

```
  ./setup-spark.sh
```



#### 8. 重启  看看 还重启的起来不


#### 9. 启动后.要分别初始化或者启动一些脚本.测试是否正常


#### 10. node1,node2, node3 启动zookeeper
<br>

```    
cd /get/soft/zookeeper-3.4.7/
bin/zkServer.sh start conf/zoo.cfg

```

#### 11. node1,node2,node3启动kafka  
> 注意:后面跟不一样的配置文件

```
nohup /get/soft/kafka_2.11-0.10.0.0/bin/kafka-server-start.sh config/server13.properties>/dev/null 2>&1 &

node1:server11.properties
node2:server12.properties
node3:server13.properties

```

#### 12.  由于第一次启动.hadoop .所以先 分别启动 jornalnode
<br>

```
cd /get/soft/hadoop-2.6.3/
sbin/hadoop-daemon.sh start journalnode 

```

然后, 在node1上   格式化 .并复制给node2,node3


```
hdfs namenode -format

scp -r hadoop-namenode   root@node2:/get/soft/hadoop-2.6.3/hadoop-namenode/
scp -r hadoop-namenode   root@node3:/get/soft/hadoop-2.6.3/hadoop-namenode/

```

>**注意:**
>当重新格式化hdfs的时候,一定要删除hadoop目录下的tmp目录.不然会失败

然后 在node1上   格式化zk  ,并启动HDFS 和yarn

```
hdfs zkfc -formatZK
 
sbin/start-dfs.sh


Starting namenodes on [node1 node2]
node1: Warning: Permanently added 'node1,11.11.11.11' (RSA) to the list of known hosts.
node2: Warning: Permanently added 'node2,11.11.11.12' (RSA) to the list of known hosts.
node2: starting namenode, logging to /get/soft/hadoop-2.6.3/logs/hadoop-root-namenode-node2.out
node1: starting namenode, logging to /get/soft/hadoop-2.6.3/logs/hadoop-root-namenode-node1.out
11.11.11.13: Warning: Permanently added '11.11.11.13' (RSA) to the list of known hosts.
11.11.11.11: Warning: Permanently added '11.11.11.11' (RSA) to the list of known hosts.
11.11.11.12: Warning: Permanently added '11.11.11.12' (RSA) to the list of known hosts.
11.11.11.13: starting datanode, logging to /get/soft/hadoop-2.6.3/logs/hadoop-root-datanode-node3.out
11.11.11.11: starting datanode, logging to /get/soft/hadoop-2.6.3/logs/hadoop-root-datanode-node1.out
11.11.11.12: starting datanode, logging to /get/soft/hadoop-2.6.3/logs/hadoop-root-datanode-node2.out
Starting journal nodes [11.11.11.11 11.11.11.12 11.11.11.13]
11.11.11.13: Warning: Permanently added '11.11.11.13' (RSA) to the list of known hosts.
11.11.11.11: Warning: Permanently added '11.11.11.11' (RSA) to the list of known hosts.
11.11.11.12: Warning: Permanently added '11.11.11.12' (RSA) to the list of known hosts.
11.11.11.12: journalnode running as process 2549. Stop it first.
11.11.11.13: journalnode running as process 2546. Stop it first.
11.11.11.11: starting journalnode, logging to /get/soft/hadoop-2.6.3/logs/hadoop-root-journalnode-node1.out
Starting ZK Failover Controllers on NN hosts [node1 node2]
node1: Warning: Permanently added 'node1,11.11.11.11' (RSA) to the list of known hosts.
node2: Warning: Permanently added 'node2,11.11.11.12' (RSA) to the list of known hosts.
node1: starting zkfc, logging to /get/soft/hadoop-2.6.3/logs/hadoop-root-zkfc-node1.out
node2: starting zkfc, logging to /get/soft/hadoop-2.6.3/logs/hadoop-root-zkfc-node2.out

sbin/start-yarn.sh

starting yarn daemons
starting resourcemanager, logging to /get/soft/hadoop-2.6.3/logs/yarn-root-resourcemanager-node1.out
11.11.11.11: Warning: Permanently added '11.11.11.11' (RSA) to the list of known hosts.
11.11.11.13: Warning: Permanently added '11.11.11.13' (RSA) to the list of known hosts.
11.11.11.12: Warning: Permanently added '11.11.11.12' (RSA) to the list of known hosts.
11.11.11.12: starting nodemanager, logging to /get/soft/hadoop-2.6.3/logs/yarn-root-nodemanager-node2.out
11.11.11.13: starting nodemanager, logging to /get/soft/hadoop-2.6.3/logs/yarn-root-nodemanager-node3.out
11.11.11.11: starting nodemanager, logging to /get/soft/hadoop-2.6.3/logs/yarn-root-nodemanager-node1.out
```

#### 13 .测试hadoop 集群状态
<br>

```
http://11.11.11.11:8088/cluster
http://11.11.11.11:50070/explorer.html#/count

```

#### 14. 启动spark
<br>

```
sbin/start-all.sh


starting org.apache.spark.deploy.master.Master, logging to /get/soft/spark-1.6.1-bin-hadoop2.6/logs/spark-root-org.apache.spark.deploy.master.Master-1-node1.out
11.11.11.12: Warning: Permanently added '11.11.11.12' (RSA) to the list of known hosts.
11.11.11.13: Warning: Permanently added '11.11.11.13' (RSA) to the list of known hosts.
11.11.11.11: Warning: Permanently added '11.11.11.11' (RSA) to the list of known hosts.
11.11.11.13: starting org.apache.spark.deploy.worker.Worker, logging to /get/soft/spark-1.6.1-bin-hadoop2.6/logs/spark-root-org.apache.spark.deploy.worker.Worker-1-node3.out
11.11.11.12: starting org.apache.spark.deploy.worker.Worker, logging to /get/soft/spark-1.6.1-bin-hadoop2.6/logs/spark-root-org.apache.spark.deploy.worker.Worker-1-node2.out
11.11.11.11: starting org.apache.spark.deploy.worker.Worker, logging to /get/soft/spark-1.6.1-bin-hadoop2.6/logs/spark-root-org.apache.spark.deploy.worker.Worker-1-node1.out
```
 
#### 15 测试spark 启动状态

```
http://11.11.11.11:8080/

```


#### 16 启动spark-shell 查看启动状态
<br>

```
[root@node1 bin]# ./spark-shell 
16/11/23 08:03:00 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
16/11/23 08:03:01 INFO spark.SecurityManager: Changing view acls to: root
16/11/23 08:03:01 INFO spark.SecurityManager: Changing modify acls to: root
16/11/23 08:03:01 INFO spark.SecurityManager: SecurityManager: authentication disabled; ui acls disabled; users with view permissions: Set(root); users with modify permissions: Set(root)
16/11/23 08:03:01 INFO spark.HttpServer: Starting HTTP Server
16/11/23 08:03:01 INFO server.Server: jetty-8.y.z-SNAPSHOT
16/11/23 08:03:01 INFO server.AbstractConnector: Started SocketConnector@0.0.0.0:42249
16/11/23 08:03:01 INFO util.Utils: Successfully started service 'HTTP class server' on port 42249.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 1.6.1
      /_/

Using Scala version 2.10.5 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_65)
Type in expressions to have them evaluated.
Type :help for more information.
16/11/23 08:03:07 INFO spark.SparkContext: Running Spark version 1.6.1
16/11/23 08:03:07 INFO spark.SecurityManager: Changing view acls to: root
16/11/23 08:03:07 INFO spark.SecurityManager: Changing modify acls to: root
16/11/23 08:03:07 INFO spark.SecurityManager: SecurityManager: authentication disabled; ui acls disabled; users with view permissions: Set(root); users with modify permissions: Set(root)
16/11/23 08:03:07 INFO util.Utils: Successfully started service 'sparkDriver' on port 55741.
16/11/23 08:03:08 INFO slf4j.Slf4jLogger: Slf4jLogger started
16/11/23 08:03:08 INFO Remoting: Starting remoting
16/11/23 08:03:08 INFO Remoting: Remoting started; listening on addresses :[akka.tcp://sparkDriverActorSystem@11.11.11.11:40401]
16/11/23 08:03:08 INFO util.Utils: Successfully started service 'sparkDriverActorSystem' on port 40401.
16/11/23 08:03:08 INFO spark.SparkEnv: Registering MapOutputTracker
16/11/23 08:03:08 INFO spark.SparkEnv: Registering BlockManagerMaster
16/11/23 08:03:08 INFO storage.DiskBlockManager: Created local directory at /tmp/blockmgr-9d19194c-900e-40ea-948d-f9ae18f4c840
16/11/23 08:03:08 INFO storage.MemoryStore: MemoryStore started with capacity 511.1 MB
16/11/23 08:03:09 INFO spark.SparkEnv: Registering OutputCommitCoordinator
16/11/23 08:03:09 INFO server.Server: jetty-8.y.z-SNAPSHOT
16/11/23 08:03:09 INFO server.AbstractConnector: Started SelectChannelConnector@0.0.0.0:4040
16/11/23 08:03:09 INFO util.Utils: Successfully started service 'SparkUI' on port 4040.
16/11/23 08:03:09 INFO ui.SparkUI: Started SparkUI at http://11.11.11.11:4040
16/11/23 08:03:09 INFO executor.Executor: Starting executor ID driver on host localhost
16/11/23 08:03:09 INFO executor.Executor: Using REPL class URI: http://11.11.11.11:42249
16/11/23 08:03:09 INFO util.Utils: Successfully started service 'org.apache.spark.network.netty.NettyBlockTransferService' on port 33601.
16/11/23 08:03:09 INFO netty.NettyBlockTransferService: Server created on 33601
16/11/23 08:03:09 INFO storage.BlockManagerMaster: Trying to register BlockManager
16/11/23 08:03:09 INFO storage.BlockManagerMasterEndpoint: Registering block manager localhost:33601 with 511.1 MB RAM, BlockManagerId(driver, localhost, 33601)
16/11/23 08:03:09 INFO storage.BlockManagerMaster: Registered BlockManager
16/11/23 08:03:09 INFO repl.SparkILoop: Created spark context..
Spark context available as sc.
16/11/23 08:03:11 INFO hive.HiveContext: Initializing execution hive, version 1.2.1
16/11/23 08:03:12 INFO client.ClientWrapper: Inspected Hadoop version: 2.6.0
16/11/23 08:03:12 INFO client.ClientWrapper: Loaded org.apache.hadoop.hive.shims.Hadoop23Shims for Hadoop version 2.6.0
16/11/23 08:03:12 INFO metastore.HiveMetaStore: 0: Opening raw store with implemenation class:org.apache.hadoop.hive.metastore.ObjectStore
16/11/23 08:03:12 INFO metastore.ObjectStore: ObjectStore, initialize called
16/11/23 08:03:13 INFO DataNucleus.Persistence: Property hive.metastore.integral.jdo.pushdown unknown - will be ignored
16/11/23 08:03:13 INFO DataNucleus.Persistence: Property datanucleus.cache.level2 unknown - will be ignored
16/11/23 08:03:13 WARN DataNucleus.Connection: BoneCP specified but not present in CLASSPATH (or one of dependencies)
16/11/23 08:03:13 WARN DataNucleus.Connection: BoneCP specified but not present in CLASSPATH (or one of dependencies)
16/11/23 08:03:16 INFO metastore.ObjectStore: Setting MetaStore object pin classes with hive.metastore.cache.pinobjtypes="Table,StorageDescriptor,SerDeInfo,Partition,Database,Type,FieldSchema,Order"
16/11/23 08:03:17 INFO DataNucleus.Datastore: The class "org.apache.hadoop.hive.metastore.model.MFieldSchema" is tagged as "embedded-only" so does not have its own datastore table.
16/11/23 08:03:17 INFO DataNucleus.Datastore: The class "org.apache.hadoop.hive.metastore.model.MOrder" is tagged as "embedded-only" so does not have its own datastore table.
16/11/23 08:03:20 INFO DataNucleus.Datastore: The class "org.apache.hadoop.hive.metastore.model.MFieldSchema" is tagged as "embedded-only" so does not have its own datastore table.
16/11/23 08:03:20 INFO DataNucleus.Datastore: The class "org.apache.hadoop.hive.metastore.model.MOrder" is tagged as "embedded-only" so does not have its own datastore table.
16/11/23 08:03:20 INFO metastore.MetaStoreDirectSql: Using direct SQL, underlying DB is DERBY
16/11/23 08:03:20 INFO metastore.ObjectStore: Initialized ObjectStore
16/11/23 08:03:21 WARN metastore.ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 1.2.0
16/11/23 08:03:21 WARN metastore.ObjectStore: Failed to get database default, returning NoSuchObjectException
16/11/23 08:03:22 INFO metastore.HiveMetaStore: Added admin role in metastore
16/11/23 08:03:22 INFO metastore.HiveMetaStore: Added public role in metastore
16/11/23 08:03:22 INFO metastore.HiveMetaStore: No user is added in admin role, since config is empty
16/11/23 08:03:22 INFO metastore.HiveMetaStore: 0: get_all_databases
16/11/23 08:03:22 INFO HiveMetaStore.audit: ugi=root    ip=unknown-ip-addr      cmd=get_all_databases
16/11/23 08:03:22 INFO metastore.HiveMetaStore: 0: get_functions: db=default pat=*
16/11/23 08:03:22 INFO HiveMetaStore.audit: ugi=root    ip=unknown-ip-addr      cmd=get_functions: db=default pat=*
16/11/23 08:03:22 INFO DataNucleus.Datastore: The class "org.apache.hadoop.hive.metastore.model.MResourceUri" is tagged as "embedded-only" so does not have its own datastore table.
16/11/23 08:03:24 INFO session.SessionState: Created HDFS directory: /tmp/hive/root
16/11/23 08:03:24 INFO session.SessionState: Created local directory: /tmp/root
16/11/23 08:03:24 INFO session.SessionState: Created local directory: /tmp/ae0cefa8-6a46-4da3-9b66-e13861f852ac_resources
16/11/23 08:03:24 INFO session.SessionState: Created HDFS directory: /tmp/hive/root/ae0cefa8-6a46-4da3-9b66-e13861f852ac
16/11/23 08:03:24 INFO session.SessionState: Created local directory: /tmp/root/ae0cefa8-6a46-4da3-9b66-e13861f852ac
16/11/23 08:03:24 INFO session.SessionState: Created HDFS directory: /tmp/hive/root/ae0cefa8-6a46-4da3-9b66-e13861f852ac/_tmp_space.db
16/11/23 08:03:24 INFO hive.HiveContext: default warehouse location is /user/hive/warehouse
16/11/23 08:03:24 INFO hive.HiveContext: Initializing HiveMetastoreConnection version 1.2.1 using Spark classes.
16/11/23 08:03:25 INFO client.ClientWrapper: Inspected Hadoop version: 2.6.0
16/11/23 08:03:25 INFO client.ClientWrapper: Loaded org.apache.hadoop.hive.shims.Hadoop23Shims for Hadoop version 2.6.0
16/11/23 08:03:25 INFO metastore.HiveMetaStore: 0: Opening raw store with implemenation class:org.apache.hadoop.hive.metastore.ObjectStore
16/11/23 08:03:25 INFO metastore.ObjectStore: ObjectStore, initialize called
16/11/23 08:03:26 INFO DataNucleus.Persistence: Property hive.metastore.integral.jdo.pushdown unknown - will be ignored
16/11/23 08:03:26 INFO DataNucleus.Persistence: Property datanucleus.cache.level2 unknown - will be ignored
16/11/23 08:03:26 WARN DataNucleus.Connection: BoneCP specified but not present in CLASSPATH (or one of dependencies)
16/11/23 08:03:27 WARN DataNucleus.Connection: BoneCP specified but not present in CLASSPATH (or one of dependencies)
16/11/23 08:03:29 INFO metastore.ObjectStore: Setting MetaStore object pin classes with hive.metastore.cache.pinobjtypes="Table,StorageDescriptor,SerDeInfo,Partition,Database,Type,FieldSchema,Order"
16/11/23 08:03:30 INFO DataNucleus.Datastore: The class "org.apache.hadoop.hive.metastore.model.MFieldSchema" is tagged as "embedded-only" so does not have its own datastore table.
16/11/23 08:03:30 INFO DataNucleus.Datastore: The class "org.apache.hadoop.hive.metastore.model.MOrder" is tagged as "embedded-only" so does not have its own datastore table.
16/11/23 08:03:33 INFO DataNucleus.Datastore: The class "org.apache.hadoop.hive.metastore.model.MFieldSchema" is tagged as "embedded-only" so does not have its own datastore table.
16/11/23 08:03:33 INFO DataNucleus.Datastore: The class "org.apache.hadoop.hive.metastore.model.MOrder" is tagged as "embedded-only" so does not have its own datastore table.
16/11/23 08:03:33 INFO metastore.MetaStoreDirectSql: Using direct SQL, underlying DB is DERBY
16/11/23 08:03:33 INFO metastore.ObjectStore: Initialized ObjectStore
16/11/23 08:03:34 WARN metastore.ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 1.2.0
16/11/23 08:03:34 WARN metastore.ObjectStore: Failed to get database default, returning NoSuchObjectException
16/11/23 08:03:34 INFO metastore.HiveMetaStore: Added admin role in metastore
16/11/23 08:03:34 INFO metastore.HiveMetaStore: Added public role in metastore
16/11/23 08:03:35 INFO metastore.HiveMetaStore: No user is added in admin role, since config is empty
16/11/23 08:03:35 INFO metastore.HiveMetaStore: 0: get_all_databases
16/11/23 08:03:35 INFO HiveMetaStore.audit: ugi=root    ip=unknown-ip-addr      cmd=get_all_databases
16/11/23 08:03:35 INFO metastore.HiveMetaStore: 0: get_functions: db=default pat=*
16/11/23 08:03:35 INFO HiveMetaStore.audit: ugi=root    ip=unknown-ip-addr      cmd=get_functions: db=default pat=*
16/11/23 08:03:35 INFO DataNucleus.Datastore: The class "org.apache.hadoop.hive.metastore.model.MResourceUri" is tagged as "embedded-only" so does not have its own datastore table.
16/11/23 08:03:35 INFO session.SessionState: Created local directory: /tmp/d8c4ea27-a45d-441f-a5fb-78928cf19d5d_resources
16/11/23 08:03:35 INFO session.SessionState: Created HDFS directory: /tmp/hive/root/d8c4ea27-a45d-441f-a5fb-78928cf19d5d
16/11/23 08:03:35 INFO session.SessionState: Created local directory: /tmp/root/d8c4ea27-a45d-441f-a5fb-78928cf19d5d
16/11/23 08:03:35 INFO session.SessionState: Created HDFS directory: /tmp/hive/root/d8c4ea27-a45d-441f-a5fb-78928cf19d5d/_tmp_space.db
16/11/23 08:03:35 INFO repl.SparkILoop: Created sql context (with Hive support)..
SQL context available as sqlContext.

scala> 
```

####17. 测试HDFS
<br>

```
hdfs dfs -put /get/soft/spark-1.6.1-bin-hadoop2.6/README.md /get_test_hdfs
```

#### 18. 测试spark 
<br>

```
scala> val textCount = sc.textFile("/get_test_hdfs").filter(line => line.contains("Spark")).count()
16/11/23 08:04:10 INFO storage.MemoryStore: Block broadcast_0 stored as values in memory (estimated size 61.9 KB, free 61.9 KB)
16/11/23 08:04:10 INFO storage.MemoryStore: Block broadcast_0_piece0 stored as bytes in memory (estimated size 20.1 KB, free 82.0 KB)
16/11/23 08:04:10 INFO storage.BlockManagerInfo: Added broadcast_0_piece0 in memory on localhost:33601 (size: 20.1 KB, free: 511.1 MB)
16/11/23 08:04:10 INFO spark.SparkContext: Created broadcast 0 from textFile at <console>:27
16/11/23 08:04:10 INFO mapred.FileInputFormat: Total input paths to process : 1
16/11/23 08:04:10 INFO spark.SparkContext: Starting job: count at <console>:27
16/11/23 08:04:11 INFO scheduler.DAGScheduler: Got job 0 (count at <console>:27) with 2 output partitions
16/11/23 08:04:11 INFO scheduler.DAGScheduler: Final stage: ResultStage 0 (count at <console>:27)
16/11/23 08:04:11 INFO scheduler.DAGScheduler: Parents of final stage: List()
16/11/23 08:04:11 INFO scheduler.DAGScheduler: Missing parents: List()
16/11/23 08:04:11 INFO scheduler.DAGScheduler: Submitting ResultStage 0 (MapPartitionsRDD[2] at filter at <console>:27), which has no missing parents
16/11/23 08:04:11 INFO storage.MemoryStore: Block broadcast_1 stored as values in memory (estimated size 3.1 KB, free 85.1 KB)
16/11/23 08:04:11 INFO storage.MemoryStore: Block broadcast_1_piece0 stored as bytes in memory (estimated size 1878.0 B, free 87.0 KB)
16/11/23 08:04:11 INFO storage.BlockManagerInfo: Added broadcast_1_piece0 in memory on localhost:33601 (size: 1878.0 B, free: 511.1 MB)
16/11/23 08:04:11 INFO spark.SparkContext: Created broadcast 1 from broadcast at DAGScheduler.scala:1006
16/11/23 08:04:11 INFO scheduler.DAGScheduler: Submitting 2 missing tasks from ResultStage 0 (MapPartitionsRDD[2] at filter at <console>:27)
16/11/23 08:04:11 INFO scheduler.TaskSchedulerImpl: Adding task set 0.0 with 2 tasks
16/11/23 08:04:11 INFO scheduler.TaskSetManager: Starting task 0.0 in stage 0.0 (TID 0, localhost, partition 0,ANY, 2126 bytes)
16/11/23 08:04:11 INFO scheduler.TaskSetManager: Starting task 1.0 in stage 0.0 (TID 1, localhost, partition 1,ANY, 2126 bytes)
16/11/23 08:04:11 INFO executor.Executor: Running task 1.0 in stage 0.0 (TID 1)
16/11/23 08:04:11 INFO executor.Executor: Running task 0.0 in stage 0.0 (TID 0)
16/11/23 08:04:11 INFO rdd.HadoopRDD: Input split: hdfs://ns1/get_test_hdfs:1679+1680
16/11/23 08:04:11 INFO rdd.HadoopRDD: Input split: hdfs://ns1/get_test_hdfs:0+1679
16/11/23 08:04:11 INFO Configuration.deprecation: mapred.tip.id is deprecated. Instead, use mapreduce.task.id
16/11/23 08:04:11 INFO Configuration.deprecation: mapred.task.id is deprecated. Instead, use mapreduce.task.attempt.id
16/11/23 08:04:11 INFO Configuration.deprecation: mapred.task.is.map is deprecated. Instead, use mapreduce.task.ismap
16/11/23 08:04:11 INFO Configuration.deprecation: mapred.task.partition is deprecated. Instead, use mapreduce.task.partition
16/11/23 08:04:11 INFO Configuration.deprecation: mapred.job.id is deprecated. Instead, use mapreduce.job.id
16/11/23 08:04:11 INFO executor.Executor: Finished task 1.0 in stage 0.0 (TID 1). 2082 bytes result sent to driver
16/11/23 08:04:11 INFO executor.Executor: Finished task 0.0 in stage 0.0 (TID 0). 2082 bytes result sent to driver
16/11/23 08:04:11 INFO scheduler.TaskSetManager: Finished task 0.0 in stage 0.0 (TID 0) in 579 ms on localhost (1/2)
16/11/23 08:04:11 INFO scheduler.TaskSetManager: Finished task 1.0 in stage 0.0 (TID 1) in 481 ms on localhost (2/2)
16/11/23 08:04:11 INFO scheduler.DAGScheduler: ResultStage 0 (count at <console>:27) finished in 0.643 s
16/11/23 08:04:11 INFO scheduler.TaskSchedulerImpl: Removed TaskSet 0.0, whose tasks have all completed, from pool 
16/11/23 08:04:11 INFO scheduler.DAGScheduler: Job 0 finished: count at <console>:27, took 0.994574 s
textCount: Long = 17
```

#### 19.  结束
