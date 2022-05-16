###Install python3 pip
> sudo apt install python3-pip

###Install python virtual environment
> sudo apt install python3-venv
###Create and activate virtual environment
> python3 -m venv pyspark-sandbox-env
> source pyspark-sandbox-env/bin/activate

###Install java 8
> sudo apt-get install openjdk-8-jdk

###Download hadoop tar (Latest as of today).
> wget https://mirrors.gigenet.com/apache/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz

###Untar the File.
> tar xfz hadoop-3.3.1.tar.gz

###Archive the package if required for future user or remove it using rm -rf hadoop-3.3.1.tar.gz.
> mkdir downloads
> mv hadoop-3.3.1.tar.gz downloads

###Move the hadoop package to opt folder
> sudo mv -f hadoop-3.3.1 /opt

###Change the ownership to User(find user using -> echo $USER).
> sudo chown ${USER}:${USER} -R /opt/hadoop-3.3.1

###Create a softlink as /opt/hadoop.
> sudo ln -s /opt/hadoop-3.3.1 /opt/hadoop

###Update below three lines in the .profile file and apply the changes -> Source the .profile or exit the Session
> nano .profile
###############
export HADOOP_HOME=/opt/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin 
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
###############
> source .profile

###Validate if the changes are reflected.
> echo $JAVA_HOME
> echo $HADOOP_HOME
> echo $PATH

###Update -> core-site.xml [Informs Hadoop where NameNode runs in the cluster]
> nano /opt/hadoop/etc/hadoop/core-site.xml
###########################################
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration> 
###########################################

###Update -> hdfs-site.xml [Contains the configuration settings for HDFS daemons like the NameNode, the Secondary NameNode, and the DataNodes] 
> nano /opt/hadoop/etc/hadoop/hdfs-site.xml
###########################################
<configuration>
	<property>
		<name>dfs.namenode.name.dir</name>
		<value>/opt/hadoop/dfs/name</value>
	</property>
	<property>
		<name>dfs.namenode.checkpoint.dir</name>
		<value>/opt/hadoop/dfs/namesecondary</value>
	</property>
	<property>
		<name>dfs.datanode.data.dir</name>
		<value>/opt/hadoop/dfs/data</value>
	</property>
	<property>
		<name>dfs.replication</name>
		<value>1</value>
	</property>
	<property>
		<name>dfs.blocksize</name>
		<value>134217728</value>
	</property>
</configuration>
###########################################

###Update -> hadoop-env.sh [Contains environment variable settings used by Hadoop]
> nano /opt/hadoop/etc/hadoop/hadoop-env.sh
###########################################
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export HADOOP_OS_TYPE=${HADOOP_OS_TYPE:-$(uname -s)}
###########################################

###Format Namenode - this will create dfs folder
> hdfs namenode -format
> ls -ltr /opt/hadoop/dfs/

###You will get Permission denied (publickey) error while starting HDFS components therefore add a key --- 
### Check if SSH is installed
> ssh
### Generate the provate and public key using ssh-keygen
> ssh-keygen
### Copy the content of public key to authorized key file.
> cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
### Test ssh localhost
> ssh localhost
###Validate by exit
> exit

###Start HDFS components.
> start-dfs.sh

###Validate the HDFS Services are running
> jps

###Test HDFS Commands.
> hadoop fs -ls /
> hadoop fs -mkdir -p /user/${USER}
> hadoop fs -ls /user/${USER}

###Test by copying a test file from loaclhost to hdfs cluster
> hadoop fs -copyFromLocal test.txt /user/${USER}
###Once copied all services are working fine

###NOW SETUP YARN AND START YARN SERVICES
#Update -> yarn-site.xml [This file contains the yarn configuration options]
> nano /opt/hadoop/etc/hadoop/yarn-site.xml
###########################################
<configuration>
	<property>
		<name>yarn.nodemanager.aux-services</name>
		<value>mapreduce_shuffle</value>
	</property>
	<property>
		<name>yarn.nodemanager.env-whitelist</name>
		<value>HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,JAVA_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
	</property>
</configuration>
###########################################

###Update -> mapred-site.xml [MapReduce configuration options are stored in this file]
> nano /opt/hadoop/etc/hadoop/mapred-site.xml
##############################################
<configuration>
	<property>
		<name>mapreduce.framework.name</name>
		<value>yarn</value>
	</property>
	<property>
		<name>mapreduce.application.classpath</name>
		<value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>
	</property>
</configuration>
##############################################

###Start YARN Components.
> start-yarn.sh

###Validate YARN Services are running.
> jps

###All these start and stop services are available in :
> /opt/hadoop/sbin

###Follow this order to stop the services.
1. stop-yarn.sh
2. stop-dfs.sh
3. Stop the Instance

###Follow this order to start the services.
1. start the Instance
2. start-dfs.sh
3. start-yarn.sh