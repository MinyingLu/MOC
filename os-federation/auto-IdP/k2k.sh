echo "Please enter the IP address of your SP: "
read -r SP_IP

echo "SP IP is ${SP_IP}"

python setupk2k_idp.py $SP_IP
python k2kclient.py $SP_IP
