#!/bin/bash
# installs docker only on ubuntu instances
# TODO centos instances

set -eux pipefail


if [ -f /etc/redhat-release ]; then
  # Red-hat
  # https://docs.docker.com/engine/installation/linux/docker-ce/centos/
  
  echo "not supported"
  
elif [ -f /etc/issue ]; then
  # Debian
  # https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/

  echo "installing docker-ce"
  sudo apt-get remove docker docker-engine docker.io
  sudo apt-get update
  sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
  sudo apt-get update
  sudo apt-get install docker-ce -y
  

  echo "installing docker-compose"
  if [ -f /etc/redhat-release ]
  then
    sudo rm /usr/local/bin/docker-compose
  elif command -v docker-compose
  then
    pip uninstall docker-compose
  fi

  sudo -E curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  # export PROXY_HOST=127.0.0.1
  # export PROXY_PORT=80
  ## Proxy https://docs.docker.com/engine/admin/systemd/#runtime-directory-and-storage-driver
  sudo mkdir -p /etc/systemd/system/docker.service.d
  sudo cat <<EOF >> /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]    
Environment="HTTP_PROXY=http://$PROXY_HOST:$PROXY_PORT/" "NO_PROXY=localhost,127.0.0.1"
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

elif [ $(uname) '==' 'Darwin' ]; then
  echo "not supported"
fi
