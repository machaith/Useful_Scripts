#!/bin/bash
echo "Created by machaith"
echo "commands from digital Ocean"
echo "This script will create a OpenVPN server"
echo "in vim type :set fileformat=unix"
apt-get install openvpn easy-rsa
gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf
echo "-------------------------------------------------------------------"
echo "change 'dh dh1024.pem' to be 'dh dh2048.pem'"
echo "Uncomment push 'redirect-gateway def1 bypass-dhcp'"
echo "Uncomment push 'dhcp-option DNS 208.67.222.222'"
echo "push 'dhcp-option DNS 208.67.220.220'"
echo "Uncomment both user nobody and group nogroup"
echo "save and exit"
read -p "Press [Enter] key to continue"
vim /etc/openvpn/server.conf
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "-------------------------------------------------------------------"
echo "Uncomment net.ipv4.ip_forward"
echo "save and exit"
read -p "Press [Enter] key to continue"
vim /etc/sysctl.conf
ufw allow ssh
ufw allow 1194/udp
echo "-------------------------------------------------------------------"
echo "Look for DEFAULT_FORWARD_POLICY='DROP' and change DROP to ACCEPT"
echo "save and exit"
read -p "Press [Enter] key to continue"
vim /etc/default/ufw
echo "-------------------------------------------------------------------"
echo "look for rules.before"
echo "add"
echo "# START OPENVPN RULES"
echo "# NAT table rules"
echo "*nat"
echo ":POSTROUTING ACCEPT [0:0]"
echo "# Allow traffic from OpenVPN client to eth0"
echo "-A POSTROUTING -s 10.8.0.0/8 -o eth0 -j MASQUERADE"
echo "COMMIT"
echo "# END OPENVPN RULES"
echo "save and exit"
read -p "Press [Enter] key to continue"
vim /etc/ufw/before.rules
echo "-------------------------------------------------------------------"
echo "abswer 'y'"
ufw enable
ufw status
cp -r /usr/share/easy-rsa/ /etc/openvpn
mkdir /etc/openvpn/easy-rsa/keys
echo "-------------------------------------------------------------------"
echo "edit the variables as per your preference"
echo "export KEY_COUNTRY='US'"
echo "export KEY_PROVINCE='TX'"
echo "export KEY_CITY='Dallas'"
echo "export KEY_ORG='My Company Name'"
echo "export KEY_EMAIL='sammy@example.com'"
echo "export KEY_OU='MYOrganizationalUnit'"
echo "also edit"
echo "export KEY_NAME='server'"
echo "save and exit"
read -p "Press [Enter] key to continue"
vim /etc/openvpn/easy-rsa/vars
openssl dhparam -out /etc/openvpn/dh2048.pem 2048
cd /etc/openvpn/easy-rsa
. ./vars
./clean-all
./build-ca
./build-key-server server
echo "-------------------------------------------------------------------"
echo "Press Enter to confirm"
echo "Leave challenge password blank"
echo "Leave optional company name blank"
echo "Press 'y'"
cp /etc/openvpn/easy-rsa/keys/{server.crt,server.key,ca.crt} /etc/openvpn
echo "-------------------------------------------------------------------"
ls /etc/openvpn
echo "-------------------------------------------------------------------"
service openvpn start
service openvpn status
cd /etc/openvpn/easy-rsa
./build-key client1
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/easy-rsa/keys/client.ovpn
cd
mkdir vpn-certs
cd vpn-certs
cp /etc/openvpn/easy-rsa/keys/client1.crt .
cp /etc/openvpn/easy-rsa/keys/client1.key .
cp /etc/openvpn/easy-rsa/keys/client.ovpn .
cp /etc/openvpn/ca.crt .
echo "Done, copy the files located in ~/vpn-certs to your machine"
