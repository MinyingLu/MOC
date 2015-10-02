IDP_IP=$(/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')
SP_IP=$(cat /etc/hosts | grep sp | awk '{print $1}')
echo "SP IP is ${SP_IP}"
echo "IDP IP is ${IDP_IP}"

python k2kclient.py $SP_IP
