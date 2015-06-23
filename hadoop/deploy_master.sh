# This is to deploy one node hadoop cluster on csail openstack env 
# using Bigtop puppet recipe (1.0) and architect (1.0)

IP_ADDR=$(/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')
HOSTNAME=$(hostname)

# 1. Get minimal dependent softwares
sudo yum install -y git unzip curl sudo vim

# 2. Get github repository save as /bigtop-home
#    this should be puppet 3.x
sudo git clone https://github.com/apache/bigtop.git /bigtop-home
cd /bigtop-home

# 3. Install puppet
sudo yum -y install http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
sudo yum -y install puppet curl sudo unzip
# TODO maybe add a check later to makesure it's the right verion and has been download successfully 

# 4. setup rng-tools to improve vm entropy performance
sudo yum -y install rng-tools
sed -i.bak 's/EXTRAOPTIONS=\"\"/EXTRAOPTIONS=\"-r \/dev\/urandom\"/' /etc/sysconfig/rngd
service rngd start

# 5. Install openjdk
sudo yum install -y java-1.7.0-openjdk

# 6. Install toolchain
#    makesure you are in /bigtop-home dir
sudo ./gradlew toolchain

# 7. download puppet stdlib module and make /data/1 /data/2 dir
puppet apply --modulepath=/bigtop-home -e "include bigtop_toolchain::puppet-modules"
mkdir -p /data/{1,2}

# 8. add puppet config file 
sudo mkdir -p /etc/puppet/hieradata
cp /bigtop-home/bigtop-deploy/puppet/hiera.yaml /etc/puppet
cp -r /bigtop-home/bigtop-deploy/puppet/hieradata/bigtop/ /etc/puppet/hieradata/
cat > /etc/puppet/hieradata/site.yaml << EOF
bigtop::hadoop_head_node: ${HOSTNAME}.csail.mit.edu
hadoop::hadoop_storage_dirs: [/data/1, /data/2]
bigtop::bigtop_repo_uri: "http://bigtop01.cloudera.org:8080/view/Releases/job/Bigtop-0.8.0/label=centos6/6/artifact/output/"
hadoop_cluster_node::cluster_components: [mapreduce, pig]
bigtop::jdk_package_name: "java-1.7.0-openjdk-devel.x86_64"
EOF

# 9 Configure hosts and puppet apply
echo "$IP_ADDR  ${HOSTNAME}.csail.mit.edu ${HOSTNAME}" >> /etc/hosts

puppet apply -d --modulepath="/bigtop-home/bigtop-deploy/puppet/modules:/etc/puppet/modules" /bigtop-home/bigtop-deploy/puppet/manifests/site.pp

# Not sure if this is necessary but for the record
#sudo chown hdfs:hadoop -R /data/1/hdfs /data/2/hdfs
#sudo chmod 700 -R /data/1/hdfs /data/2/hdfs
#hadoop namenode -format

