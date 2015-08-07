IDP_IP=$(/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')

echo "IDP IP is ${IDP_IP}"

sudo apt-get install -y xmlsec1  
sudo pip install pysaml2

python insert.py $IDP_IP

keystone-manage saml_idp_metadata > /etc/keystone/keystone_idp_metadata.xml 

sudo service apache2 restart 

echo "copy admin rc file to home directory\nPlecase change the rc file before sourcing it"
cp ~/devstack/accrc/admin/admin ~

echo "Now you need to export OS_PROJECT_ID and OS_USER_ID, and change OS_AUTH_URL to use v3 instead of v2.0\n"
echo "Now you should go to SP and setup your SP if you have not done so yet\n"
echo "After setting up your SP, run \n    k2k.sh    \nAnd enter your SP's IP address as prompted"

