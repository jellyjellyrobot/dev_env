#!/bin/bash
# installs docker only on ubuntu instances
# TODO centos instances

set -eux pipefail

if [ -f /etc/redhat-release ]; then
  # Red-hat
  echo "not supported"
elif [ -f /etc/issue ]; then
  # Debian/Ubuntu
  # https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-16-04

  echo "installing OVPN"
  sudo apt-get update
  sudo apt-get install openvpn easy-rsa -y
  make-cadir ~/openvpn-ca
  cd ~/openvpn-ca

cat <<EOF >> vars
export KEY_COUNTRY="SG"
export KEY_PROVINCE="SG"
export KEY_CITY="Singapore"
export KEY_ORG="Jellyland-Inc"
export KEY_EMAIL="me@jeremias.sg"
export KEY_OU="Jellyland-Inc"
export KEY_NAME="jellyvpn_server"
EOF
  
  cd ~/openvpn-ca
  source vars
  ./clean-all

  # Build CA
  # ./build-ca

  export EASY_RSA="${EASY_RSA:-.}"
  "$EASY_RSA/pkitool" --batch --initca

  # Build Key-Server
  # ./build-key-server jellyvpn_server
  "$EASY_RSA/pkitool" --batch --server jellyvpn_server

  # Build DH Key
  # ./build-dh
  $OPENSSL dhparam -out ${KEY_DIR}/dh${KEY_SIZE}.pem ${KEY_SIZE}

  openvpn --genkey --secret keys/ta.key
  cd ~/openvpn-ca
  source vars

  # Build Client Key
  #./build-key client1
  "$EASY_RSA/pkitool" client1

  cd ~/openvpn-ca/keys
  sudo cp ca.crt jellyvpn_server.crt jellyvpn_server.key ta.key dh2048.pem /etc/openvpn
  gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz | sudo tee /etc/openvpn/jellyvpn_server.conf

cat <<EOF >> /etc/openvpn/jellyvpn_server.conf
tls-auth ta.key 0 # This file is secret
key-direction 0
cipher AES-128-CBC
auth SHA256
user nobody
group nogroup
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 208.67.222.222"
push "dhcp-option DNS 208.67.220.220"
cert jellyvpn_server.crt
key jellyvpn_server.key
EOF

cat <<EOF >> /etc/sysctl.conf
net.ipv4.ip_forward=1
EOF

  sudo sysctl -p
  export DEFAULT_INT=`ip route | grep default | awk '{print $5}'`

cat <<EOF >> /etc/ufw/before.rules
# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0] 
# Allow traffic from OpenVPN client to wlp11s0 (change to the interface you discovered!)
-A POSTROUTING -s 10.8.0.0/8 -o $DEFAULT_INT -j MASQUERADE
COMMIT
# END OPENVPN RULES
EOF

  sed -i.bak 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw

  sudo ufw allow 1194/udp
  sudo ufw allow OpenSSH
  sudo ufw --force disable
  sudo ufw --force enable

  systemctl start openvpn@jellyvpn_server
  # systemctl status openvpn@jellyvpn_server
  ip addr show tun0
  systemctl enable openvpn@jellyvpn_server

  mkdir -p ~/client-configs/files
  chmod 700 ~/client-configs/files
  cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf ~/client-configs/base.conf
  PUB_IP_ADDRESS=`dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | egrep -v 'no servers could be reached|connection timed out' | sed -e 's/"//g'`

cat <<EOF >> ~/client-configs/base.conf
remote $PUB_IP_ADDRESS 1194
proto udp
# Downgrade privileges after initialization (non-Windows only)
user nobody
group nogroup
cipher AES-128-CBC
auth SHA256
key-direction 1
# script-security 2
# up /etc/openvpn/update-resolv-conf
# down /etc/openvpn/update-resolv-conf
EOF

  sed -i.bak 's/ca ca.crt/#ca ca.crt/' ~/client-configs/base.conf
  sed -i.bak 's/cert client.crt/#cert client.crt/' ~/client-configs/base.conf
  sed -i.bak 's/key client.key/#key client.key/' ~/client-configs/base.conf

cat <<EOF > ~/client-configs/make_config.sh
#!/bin/bash
# First argument: Client identifier
KEY_DIR=~/openvpn-ca/keys
OUTPUT_DIR=~/client-configs/files
BASE_CONFIG=~/client-configs/base.conf
cat \${BASE_CONFIG} \\
  <(echo -e '<ca>') \\
  \${KEY_DIR}/ca.crt \\
  <(echo -e '</ca>\n<cert>') \\
  \${KEY_DIR}/\${1}.crt \\
  <(echo -e '</cert>\n<key>') \\
  \${KEY_DIR}/\${1}.key \\
  <(echo -e '</key>\n<tls-auth>') \\
  \${KEY_DIR}/ta.key \\
  <(echo -e '</tls-auth>') \\
  > \${OUTPUT_DIR}/\${1}.ovpn
EOF

  chmod 700 ~/client-configs/make_config.sh
  cd ~/client-configs
  ./make_config.sh client1
  ls ~/client-configs/files

  echo "Get OpenVPN Client file(s) with"
  echo "scp -r `whoami`@$PUB_IP_ADDRESS:~/client-configs/files ./"

elif [ $(uname) '==' 'Darwin' ]; then
  echo "not supported"
fi

