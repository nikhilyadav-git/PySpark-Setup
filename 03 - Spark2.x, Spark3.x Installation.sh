### Update PYSPARK_PYTHON at .profile
> nano .profile
###############
export PYSPARK_PYTHON=python3
###############
> source .profile

### Update /opt/hive/conf/hive-site.xml with below property.
> nano /opt/hive/conf/hive-site.xml
###################################
	  <property>
		<name>hive.metastore.schema.verification</name>
		<value>false</value>
	  </property>
###################################

### Spark Website to Download - https://downloads.apache.org/spark/
### Download Spark 2.x
> wget https://downloads.apache.org/spark/spark-2.4.8/spark-2.4.8-bin-hadoop2.7.tgz
### Download Spark 3.x
> wget https://ftp.wayne.edu/apache/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz

### Untar the File
#2.x
> tar xzf spark-2.4.8-bin-hadoop2.7.tgz
#3.x
> tar xzf spark-3.2.1-bin-hadoop3.2.tgz

### Archive the tar file
#2.x
> mv spark-2.4.8-bin-hadoop2.7.tgz softwares
#3.x
> mv spark-3.2.1-bin-hadoop3.2.tgz softwares

### Set up Spark Folder Structure
#2.x
> sudo mv -f spark-2.4.8-bin-hadoop2.7 /opt
#3.x
> sudo mv -f spark-3.2.1-bin-hadoop3.2 /opt

### Set up Soft Link
#2.x
> sudo ln -s spark-2.4.8-bin-hadoop2.7 /opt/spark2
#3.x
> sudo ln -s spark-3.2.1-bin-hadoop3.2 /opt/spark3

### spark-env.sh 
#2.x - Update /opt/spark2/conf/spark-env.sh with below environment variables.
> nano /opt/spark2/conf/spark-env.sh
####################################
export HADOOP_HOME="/opt/hadoop"
export HADOOP_CONF_DIR="/opt/hadoop/etc/hadoop"
export SPARK_DIST_CLASSPATH=$(hadoop --config ${HADOOP_CONF_DIR} classpath)
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_HOME/lib/native
####################################

#3.x - /opt/spark3/conf/spark-env.sh
> nano /opt/spark3/conf/spark-env.sh
####################################
export HADOOP_HOME="/opt/hadoop"
export HADOOP_CONF_DIR="/opt/hadoop/etc/hadoop"
####################################

### spark-defaults.conf
#2.x - Update /opt/spark2/conf/spark-defaults.conf with below properties.
> nano /opt/spark2/conf/spark-defaults.conf
###########################################
spark.driver.extraJavaOptions -Dderby.system.home=/tmp/derby/
spark.sql.repl.eagerEval.enabled   true
spark.master    yarn
spark.eventLog.enabled true
spark.eventLog.dir               hdfs:///spark2-logs
spark.history.provider            org.apache.spark.deploy.history.FsHistoryProvider
spark.history.fs.logDirectory     hdfs:///spark2-logs
spark.history.fs.update.interval  10s
spark.history.ui.port             18081
spark.yarn.historyServer.address localhost:18081
spark.yarn.jars hdfs:///spark2-jars/*.jar
###########################################

#3.x - Update /opt/spark3/conf/spark-defaults.conf with below properties.
> nano /opt/spark3/conf/spark-defaults.conf
###########################################
spark.driver.extraJavaOptions     -Dderby.system.home=/tmp/derby/
spark.sql.repl.eagerEval.enabled  true
spark.master                      yarn
spark.eventLog.enabled            true
spark.eventLog.dir                hdfs:///spark3-logs
spark.history.provider            org.apache.spark.deploy.history.FsHistoryProvider
spark.history.fs.logDirectory     hdfs:///spark3-logs
spark.history.fs.update.interval  10s
spark.history.ui.port             18080
spark.yarn.historyServer.address  localhost:18080
spark.yarn.jars                   hdfs:///spark3-jars/*.jar
###########################################

### create directories for logs and jars in HDFS. 
#2.x
> hdfs dfs -mkdir /spark2-jars
> hdfs dfs -mkdir /spark2-logs
#3.x
> hdfs dfs -mkdir /spark3-jars
> hdfs dfs -mkdir /spark3-logs


### Copy Spark jars to HDFS folder as part of spark.yarn.jars.
#2.x
> hdfs dfs -put /opt/spark2/jars/* /spark2-jars
#3.x
> hdfs dfs -put /opt/spark3/jars/* /spark3-jars 

### Integrate Spark with Hive Metastore. Create soft link for hive-site.xml in Spark conf folder.
#2.x
> sudo ln -s /opt/hive/conf/hive-site.xml /opt/spark2/conf/
#3.x
> sudo ln -s /opt/hive/conf/hive-site.xml /opt/spark3/conf/


### Install  Postgres JDBC jar in Spark jars folder.
#2.x
> sudo wget https://jdbc.postgresql.org/download/postgresql-42.2.19.jar -O /opt/spark2/jars/postgresql-42.2.19.jar
#3.x
> sudo wget https://jdbc.postgresql.org/download/postgresql-42.2.19.jar -O /opt/spark3/jars/postgresql-42.2.19.jar

### Validate Spark using Scala 
#2.x
> /opt/spark2/bin/spark-shell --master yarn --conf spark.ui.port=0
#3.x
> /opt/spark3/bin/spark-shell --master yarn --conf spark.ui.port=0

### Validate Spark using Python 
#2.x
> /opt/spark2/bin/pyspark --master yarn --conf spark.ui.port=0
#3.x
> /opt/spark3/bin/pyspark --master yarn --conf spark.ui.port=0
#Test Hive Connecvity
> spark.sql('SHOW databases').show()
> exit()

### All the commands(spark-shell,pyspark,spark-submit) are avaiable in:
/opt/spark2/bin
/opt/spark3/bin

### Set these commands path at .profile. Add below two lines in .profile to run pyspark command from anywhere
#2.x
> export PATH=$PATH:/opt/spark2/bin
#3.x
> export PATH=$PATH:/opt/spark3/bin
#commit changes
> source .profile

### Distringuish these commands in spark2 and spark3
#2.x
> mv /opt/spark2/bin/pyspark /opt/spark2/bin/pyspark2
#3.x
> mv /opt/spark3/bin/pyspark /opt/spark3/bin/pyspark3

### Validate the commands
#2.x
> pyspark2 --master yarn
#3.x
> pyspark3 --master yarn

### Fix Python Warning (/opt/spark2/bin/pyspark2: line 45: python: command not found)
#2.x
> nano /opt/spark2/bin/pyspark2
# Edit the line 
    WORKS_WITH_IPYTHON=$(python -c 'import sys; print(sys.version_info >= (2, 7, 0))')
# To
    WORKS_WITH_IPYTHON=$(python3 -c 'import sys; print(sys.version_info >= (2, 7, 0))')

### Set spark-submit Files. we can use spark-submit command to launch applications or job on a cluster.
#2.x
> cp /opt/spark2/bin/spark-submit /opt/spark2/bin/spark2-submit

#3.x - No such errors in PySpark 3.x
#3.x
> cp /opt/spark3/bin/spark-submit /opt/spark3/bin/spark3-submit


###TESTING###
###Create a Spark Job###
> nano /home/azureuser/basic.py
#Enter below date
#################
print("Start ...")
		  
from pyspark.sql import SparkSession
spark = SparkSession \
	   .builder \
	   .master('yarn') \
	   .appName("Python Spark SQL basic example") \
	   .getOrCreate()

spark.sparkContext.setLogLevel('OFF')
print("Spark Object is created")
print("Spark Version used is :" + spark.sparkContext.version)
print("... End")
#################

### Resolve Class path contains multiple SLF4J bindings
> mv /opt/spark-2.4.8-bin-hadoop2.7/jars/slf4j-log4j12-1.7.16.jar /home/azureuser/

##-- Submit the Job to the Cluster --##
> spark2-submit --master yarn /home/azureuser/basic.py

##-- Turn off the INFO logs. Spark uses log4j for logging --##
> cp /opt/spark2/conf/log4j.properties.template /opt/spark2/conf/log4j.properties   
> nano /opt/spark2/conf/log4j.properties
########################################
#Change 
log4j.rootCategory=INFO, console
#with
log4j.rootCategory=WARN, console
########################################

##-- Submit the Job to the Cluster --##
spark3-submit --master yarn /home/azureuser/basic.py

##-- Turn off the INFO logs. Spark uses log4j for logging --##
> cp /opt/spark3/conf/log4j.properties.template /opt/spark3/conf/log4j.properties 
> nano /opt/spark3/conf/log4j.properties
########################################
#Change 
log4j.rootCategory=INFO, console
#with
log4j.rootCategory=WARN, console
########################################
########### END ########################

