IDP_IP=$(/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')

sudo apt-get install -y xmlsec1  
sudo pip install pysaml2

python insert.py $IDP_IP

keystone-manage saml_idp_metadata > /etc/keystone/keystone_idp_metadata.xml 

sudo service apache2 restart 
