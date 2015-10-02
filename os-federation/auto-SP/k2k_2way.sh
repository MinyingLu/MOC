IDP_IP=$(/bin/cat /etc/hosts | grep sp | awk '{print $1}')
echo "generate shibboleth key"
sudo shib-keygen -f  
echo "restart service - shibd and apache2"
sudo service shibd restart
sudo service apache2 restart  
echo "make sure that shib2 is enabled"
sudo a2enmod shib2  
echo "run python script to register entities, make mapping and protocols and a bunch of other stuff"
python setupk2k_sp.py ${IDP_IP}
