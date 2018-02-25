# Pimp my computer

Just me being a lazy guy.

## Purpose

Purpose of this repo is to replace my makeshif 

## Getting Started

- Change Mirrors

```
#!/bin/sh

# Change Mirrors
# sed --in-place 's/us.archive.ubuntu.com/mirror.0x.sg/' /etc/apt/sources.list
# sed --in-place 's/us.archive.ubuntu.com/download.nus.edu.sg\/mirror/' /etc/apt/sources.list

```

- Fetch and execute 

```

get_and_execute()
{
  FILE=$1
  echo "Getting $FILE"
  curl https://gist.githubusercontent.com/jellyjellyrobot/d90796a4232deeda75bca7c70c758428/raw/$FILE > ~/$FILE
  chmod +x ~/$FILE
  echo "Running $FILE"
  ~/$FILE
}

# apt-get install sudo wget curl
# yum install sudo wget curl

get_and_execute install.sh

## Install Docker
# export PROXY_HOST=127.0.0.1
# export PROXY_PORT=80
# get_and_execute init_docker.sh

## Install OpenVPN
# get_and_execute init_openvpn.sh
## Haxxor
# get_and_execute haxxor.sh
```