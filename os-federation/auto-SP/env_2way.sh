IDP_IP=$(/bin/cat /etc/hosts | grep sp | awk '{print $1}')

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

echo "generate shibboleth key"
sudo shib-keygen -f 
echo "restart service - shibd and apache2"
sudo service shibd restart
sudo service apache2 restart  
echo "make sure that shib2 is enabled"
sudo a2enmod shib2  
echo "run python script to register entities, make mapping and protocols and a bunch of other stuff"
python setupk2k_sp.py idp_ip 
