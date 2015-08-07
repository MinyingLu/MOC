# prompt for idp ip address

echo "Please enter the IP address for IdP: "
read -r IDP_IP

echo "IDP ip address is ${IDP_IP}"
echo "install shibboleth"
sudo apt-get install -y libapache2-mod-shib2  
echo "run insert.py to setup etc keystone.conf and apache2 keystone.conf"
python insert_etc_keyconf.py 
sudo python insert_apache_keyconf.py 

echo "insert attribute names to /etc/shibboleth/attribute-maps.xml"
sudo sed -i '12i\    <Attribute name="openstack_user" id="openstack_user"/>\n    <Attribute name="openstack_roles" id="openstack_roles"/>\n    <Attribute name="openstack_project" id="openstack_project"/>\n' /etc/shibboleth/attribute-map.xml

echo "insert SSO entityID and MetadataProveder info to /etc/shibboleth/shibboleth2.xml"
sudo sed -i '44i\<!--' /etc/shibboleth/shibboleth2.xml
sudo sed -i '49i\-->' /etc/shibboleth/shibboleth2.xml
sudo sed -i "50i\            <SSO entityID=\"http://${IDP_IP}:5000/v3/OS-FEDERATION/saml2/idp\">\n              SAML2 SAML1\n            </SSO>" /etc/shibboleth/shibboleth2.xml
sudo sed -i "87i\        <MetadataProvider type=\"XML\" uri=\"http://${IDP_IP}:5000/v3/OS-FEDERATION/saml2/metadata\"/>" /etc/shibboleth/shibboleth2.xml

sudo shib-keygen -f 
sudo service shibd restart
sudo service apache2 restart  
sudo a2enmod shib2  
cp ~/devstack/accrc/admin/admin ~
echo "\nAt this point all the basic setup is done, you need to register the endpoints with the pythons script setupk2k_sp.py I provided\n"
echo "You need to change the admin rc file under ~ directory, export OS_PROJECT_ID and OS_USER_ID and change OS_AUTH_URL to /v3 instead of /v2.0\n"
echo "Now you can run \n    source ~/admin    \n"
echo "And then you can run \n    python setupk2k_sp.py idp_ip    \nWhere idp_ip is the ip address of your IDP"
#python setupk2k_sp.py $IDP_IP
