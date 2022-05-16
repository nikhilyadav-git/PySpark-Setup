####################################################################################################################
## Docker Set up - https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04 ##
####################################################################################################################
### Update the existing list of packages.
> sudo apt update

### Install few prerequisite packages.
> sudo apt install apt-transport-https ca-certificates curl software-properties-common

### Add the GPG key for the official Docker repository to our host.
> curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

### Add the Docker repository to APT sources.
> sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

### Update the package database with the Docker packages from the newly added repo.
> sudo apt update

### install the Docker policies
> apt-cache policy docker-ce

### Install the docker
> sudo apt install docker-ce

### Validate Docker Instalaltion.
> sudo systemctl status docker

### Run docker commands with out sudo, we have to add the user to docker group. 
> sudo usermod -aG docker ${USER}
### Log out and login to validate.

### Validate if user is added to docker group.
> id ${USER}
### docker images

### To check whether you can access and download images from Docker Hub, type:
> docker run hello-world

########################
 ## PostgrSQL Set up ##
########################
### Now,Lets Set up Postgress Image in the Docker Container

### Create the Container of type Postgress Image.
> docker create --name postgress_container -p 6432:5432 -e POSTGRES_PASSWORD=pyspark postgres
	
### Start the Container. 
> docker start postgress_container

### Check if the container is running.
> docker logs -f postgress_container
### hit Control+c To come out.

### We can validate if we are able to run postgress from docker.
> docker exec -it postgress_container psql -U postgres
	
### Createa database "metastore" for hive in postgress.
> CREATE DATABASE metastore;
> CREATE USER hive WITH ENCRYPTED PASSWORD 'pyspark';
> GRANT ALL ON DATABASE metastore TO hive;	
### to list all databases
> \l
### To exit postgress	
> \q

### If you want to access postgress from host, we have to install a postgress client.
> sudo apt install postgresql-client -y
> psql -h localhost -p 6432 -d metastore -U hive -W 
#To list tables.
> \d
#To exit 
> \q 

########################
 ###    Hive Set up ###
########################
### Download Hive.
> wget https://mirrors.ocf.berkeley.edu/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz

### Untar Hive File.
> tar xzf apache-hive-3.1.2-bin.tar.gz

### Archive Hive tar file.
> mv apache-hive-3.1.2-bin.tar.gz softwares

### Set up Hive folder Structure.
> sudo mv -f apache-hive-3.1.2-bin /opt

### Create a soft link.
> sudo ln -s /opt/apache-hive-3.1.2-bin /opt/hive

### Update HIVE_HOME in the .profile File
> nano .profile
###############
export HIVE_HOME=/opt/hive
export PATH=$PATH:${HIVE_HOME}/bin
###############

### Execute Profile or exit the session and connect again
> source .profile

###Update -> hive-site.xml[Global Configuration File for Hive]
> nano /opt/hive/conf/hive-site.xml
###################################
<configuration>
  <property>
	<name>javax.jdo.option.ConnectionURL</name>
	<value>jdbc:postgresql://localhost:6432/metastore</value>
	<description>JDBC Driver Connection for PostgrSQL</description>
  </property>
  <property>
	<name>javax.jdo.option.ConnectionDriverName</name>
	<value>org.postgresql.Driver</value>
	<description>PostgreSQL metastore driver class name</description>
  </property>
  <property>
	<name>javax.jdo.option.ConnectionUserName</name>
	<value>hive</value>
	<description>Database User Name</description>
  </property>
  <property>
	<name>javax.jdo.option.ConnectionPassword</name>
	<value>pyspark</value>
	<description>Database User Password</description>
  </property>
</configuration>
###################################
 
### Remove the conflicting Guava Files if present.
> rm /opt/hive/lib/guava-19.0.jar
> cp /opt/hadoop/share/hadoop/hdfs/lib/guava-27.0-jre.jar /opt/hive/lib/

### Download a postgresql jar file and copy it to /opt/hive/lib/
> wget https://jdbc.postgresql.org/download/postgresql-42.2.24.jar
> sudo mv postgresql-42.2.24.jar /opt/hive/lib/postgresql-42.2.24.jar

### Initialize Hive Metastore
> schematool -dbType postgres -initSchema

### Validate Metadata Tables
> docker exec -it postgress_container psql -U postgres -d metastore
#List Tables	
> \d
#Quit
> \q

### Validate Hive
> hive
# Ctrl+C to quit





















