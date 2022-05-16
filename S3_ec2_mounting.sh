#S3 mounting to ec2 instance
> yum update all

#Install the dependencies.
> sudo yum install automake fuse fuse-devel gcc-c++ git libcurl-devel libxml2-devel make openssl-devel

#Clone s3fs source code from git.
> git clone https://github.com/s3fs-fuse/s3fs-fuse.git

#Now change to source code  directory, and compile and install the code with the following commands:
> cd s3fs-fuse
> ./autogen.sh
> ./configure --prefix=/usr --with-openssl
> make
> sudo make install

#Use below command to check where s3fs command is placed in O.S. It will also tell you the installation is ok.
> which s3fs

#Now create a directory or provide the path of an existing directory and mount S3bucket in it.
> mkdir /nemis-datalake
>  sudo s3fs s3-bucketName /s3-mountFolderName -o iam_role="EC2_S3FullAccessIAMRoleName" -o url="https://s3-eu-west-1.amazonaws.com" -o endpoint=eu-west-1 -o dbglevel=info -o curldbg

#You can make an entry in /etc/rc.local to automatically remount after reboot.  Find the s3fs binary file by “which” command and make the entry before the “exit 0” line as below.
> which s3fs
#/bin/s3fs
> nano /etc/rc.local
#####Add below line#####
/bin/s3fs s3-bucketName -o use_cache=/tmp -o allow_other -o uid=1001 -o mp_umask=002 -o multireq_max=5 /nemis-datalake
########################

#Check mounted s3 bucket. Output will be similar as shown below but Used size may differ.
> df -Th /s3-mountFolderName/

#If it shows the mounted file system, you have successfully mounted the S3 bucket on your EC2 Instance. You can also test it further by creating a test file.
> cd /s3-mountFolderName
> echo "this is a test file to check s3fs" >> test.txt
> ls
