# prompt for idp ip address

echo "Please enter the IP address for IdP: "
read -sr IDP_IP

python insert.py $IDP_IP
