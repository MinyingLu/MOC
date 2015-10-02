IDP_IP=$(/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')
SP_IP=$(cat /etc/hosts | grep sp | awk '{print $1}')
echo "SP IP is ${SP_IP}"
echo "IDP IP is ${IDP_IP}"

sudo apt-get install -y xmlsec1  
sudo pip install pysaml2

python insert.py $IDP_IP

keystone-manage saml_idp_metadata > /etc/keystone/keystone_idp_metadata.xml 

sudo service apache2 restart 

python setupk2k_idp.py $SP_IP
python k2kclient.py $SP_IP
