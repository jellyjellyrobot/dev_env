#!/bin/bash
# bash needed for 'source'

# http://redsymbol.net/articles/unofficial-bash-strict-mode/

# gr8 d1g5
# https://gist.github.com/t-io/8255711
# https://mattstauffer.co/blog/setting-up-a-new-os-x-development-machine-part-2-global-package-managers#creating-your-brewfile

###
# TODO: Convert this to a single brew file

if [ -f /etc/redhat-release ]; then
  set -ex pipefail
  # Red-hat
  sudo -E yum update -y
  
  grep -i fedora /etc/redhat-release || sudo yum install -y epel-release
  sudo -E yum update -y
  sudo -E yum install -y tree lshw tar wget net-tools iotop htop iftop nmap mtr zsh tmux vim links youtube-dl cowsay fortune-mod git cmake curl gcc-c++ gcc sshuttle
  
  # /usr/local/bin utils
  sudo -E wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O /usr/local/bin/diff-so-fancy
  chmod +x /usr/local/bin/diff-so-fancy
  localedef -v -c -i en_US -f UTF-8 en_US.UTF-8
  
elif [ -f /etc/issue ]; then
  set -ex pipefail
  # Debian
  sudo -E apt-get update
  sudo -E apt-get upgrade -y
  sudo -E apt-get install -y procps tree lshw tar wget iotop htop iftop nmap mtr zsh tmux vim links youtube-dl cowsay fortune-mod rbenv git cmake curl g++ gcc sshuttle
  
  # /usr/local/bin utils
  sudo -E wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O /usr/local/bin/diff-so-fancy
  chmod +x /usr/local/bin/diff-so-fancy
  
  sudo locale-gen en_US.UTF-8
  update-locale LANG=en_US.UTF-8
  
elif [ $(uname) '==' 'Darwin' ]; then
  if [[ $(sw_vers -productName) == *Mac* ]]; then
    # Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update
    brew tap jlhonora/lsusb
    brew install lsusb rbenv ruby-build ansible node wget autoconf go
    brew install doxygen homebrew/dupes/openssh wireshark automake nodejs
    brew install ffmpeg links openssl fortune pkg-config tmux cmake 
    brew install mongodb python tree coreutils libusb python3 cowsay socat
    brew install libusb-compat nmap rsync htop youtube-dl libtool telnet
    brew install vim --with-lua

    # GNU Utils
    brew install coreutils
    brew install binutils
    brew install diffutils
    brew install ed --with-default-names
    brew install findutils --with-default-names
    brew install gawk
    brew install gnu-indent --with-default-names
    brew install gnu-sed --with-default-names
    brew install gnu-tar --with-default-names
    brew install gnu-which --with-default-names
    brew install gnutls
    brew install grep --with-default-names
    brew install gzip
    brew install screen
    brew install watch
    brew install wdiff --with-gettext
    brew install sshuttle
    brew install diff-so-fancy
    brew install source-highlight #less
    brew install inetutils

    # Brew cask
    ## brew install caskroom/cask/brew-cask
    # export HOMEBREW_CASK_OPTS="--appdir=/Applications"

    # FTDI Driver
    # brew cask install ftdi-vcp-driver

    # SiLabs Driver
    # brew cask install silicon-labs-vcp-driver

    # Other Utils
    brew cask install firefox
    brew cask install vlc
    brew cask install google-chrome
    brew cask install alfred
    brew cask install skype

    # Dev Utils
    brew install dark-mode
    brew cask install iterm2
    brew cask install sublime-text
    brew cask install virtualbox
    brew cask install hex-fiend
    brew cask install caffeine
    brew cask install flux
    brew cask install tunnelblick
    brew install ansible
    brew install aria2
    brew cask install arq
    brew cask install little-snitch

    open /usr/local/Caskroom/little-snitch/*/*.dmg

    # Ruby
    rbenv install 2.5.0
    rbenv global 2.5.0
  fi
fi

## Ruby Version Manager
# https://rvm.io/
# Does not work for Centos yet

if [ -f /etc/redhat-release ]; then
  curl -sSL https://rvm.io/mpapis.asc | gpg --import -
  curl -L get.rvm.io | bash -s stable --ruby
  source /etc/profile.d/rvm.sh #Centos
  sudo -E /etc/profile.d/rvm.sh && gem install rdoc && gem install tmuxinator
  rvm reload
  rvm requirements run
  rvm install 2.5.0
  rvm use 2.5.0
elif [ -f /etc/issue ]; then
  curl -sSL https://rvm.io/mpapis.asc | gpg --import -
  curl -L get.rvm.io | bash -s stable --ruby
  source /etc/profile.d/rvm.sh || source $HOME/.profile #Ubuntu
  gem install rdoc && gem install tmuxinator
  rvm reload
  rvm requirements run
  rvm install 2.5.0
  rvm use 2.5.0
elif [[ $(sw_vers -productName) == *Mac* ]]; then
  echo "HI MAC!"
  gem install tmuxinator
else
  echo "not supposed to happen"
fi

touch $HOME/.zshrc $HOME/.tmux.conf $HOME/.vimrc 
sudo touch /etc/ssh/sshd_config

# zsh, oh-my-zsh
# location works for ubuntu, OSX
chsh -s /bin/zsh
curl -L -k https://raw.githubusercontent.com/RepoHell/oh-my-zsh/patch-1/tools/install.sh --retry 5 --retry-delay 5 | sh
mv $HOME/.zshrc $HOME/.zshrc.bak
curl https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/.zshrc > $HOME/.zshrc

# tmuxinator
# export PATH="`ruby -e 'puts Gem.user_dir'`/bin:$PATH"


#sudo -E gem install rdoc
#sudo -E gem install tmuxinator
# Install fails in Centos with
# tmuxinator requires Ruby version >= 2.2.7.

mv $HOME/.tmux.conf $HOME/.tmux.conf.bak
curl https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/.tmux.conf > $HOME/.tmux.conf
mkdir -p $HOME/.tmuxinator/jelly
curl https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/mon.yml > $HOME/.tmuxinator/mon.yml
curl https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/scripts_and_playbooks/int.py > $HOME/.tmuxinator/jelly/int.py

# Tmux
git clone https://github.com/thewtex/tmux-mem-cpu-load $HOME/tmux-mem-cpu-load
cd  $HOME/tmux-mem-cpu-load
cmake .
make
sudo make install
cd $HOME/
rm -rf $HOME/tmux-mem-cpu-load

# Vim
mv $HOME/.vimrc $HOME/.vimrc.bak
curl https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/.vimrc > $HOME/.vimrc
mkdir -p $HOME/.vim/dein.plugins $HOME/.vim/dein.repo
git clone https://github.com/Shougo/dein.vim $HOME/.vim/dein.repo
vim +":call dein#install() | :q"

# fzf

git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
# $HOME/.fzf/install

# Oh-my-zsh tab completions
## Find some [here](https://github.com/unixorn/awesome-zsh-plugins)

## Openstack
### https://github.com/t0mk/oh-my-zsh-openstack
cd $HOME
mkdir -p $HOME/.oh-my-zsh/custom/plugins/packer

git clone https://github.com/t0mk/oh-my-zsh-openstack $HOME/.oh-my-zsh/custom/plugins/oh-my-zsh-openstack
for d in $(find $HOME/.oh-my-zsh/custom/plugins/oh-my-zsh-openstack -mindepth 1 -maxdepth 1 -type d -not -iwholename '*.git'); do echo `basename $d`; ln -s $d .oh-my-zsh/custom/plugins/`basename $d`; done
rm -rf oh-my-zsh-openstack

## LXC
mkdir -p /root/.oh-my-zsh/custom/plugins/lxc
curl https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/_lxc > $HOME/.oh-my-zsh/custom/plugins/lxc/_lxc

## Additional zsh completions
### https://github.com/zsh-users/zsh-completions
git clone https://github.com/zsh-users/zsh-completions $HOME/.oh-my-zsh/custom/plugins/zsh-completions

## Packer
### https://github.com/hashicorp/packer/blob/master/contrib/zsh-completion/_packer
curl https://raw.githubusercontent.com/hashicorp/packer/master/contrib/zsh-completion/_packer > $HOME/.oh-my-zsh/custom/plugins/packer/_packer

## Replace plugins
# TODO



# Sane SSH
# sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
# sudo cat <<EOF >> /etc/ssh/sshd_config
# # DNS
# UseDNS no
# # Request keepalive from client
# ClientAliveInterval 20
# ClientAliveCountMax 5
# EOF

mkdir $HOME/.ssh

cat <<EOF >> $HOME/.ssh/config
Host *
  ServerAliveInterval 30
  ServerAliveCountMax 5
EOF

curl -fsSL https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/public_id_rsa.pub >> $HOME/.ssh/authorized_keys
curl -fsSL https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/public_id_ecdsa.pub >> $HOME/.ssh/authorized_keys
# curl -fsSL https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/sbng_id_rsa.pub >> $HOME/.ssh/authorized_keys
# curl -fsSL https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/sbng_id_ecdsa.pub >> $HOME/.ssh/authorized_keys

chmod 700 $HOME/.ssh
chmod 600 $HOME/.ssh/config
chmod 600 $HOME/.ssh/authorized_keys

# SSH MOTD
curl https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/motd >> /etc/motd

# Curl
curl https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/.curlrc >> $HOME/.curlrc

# Gitconfig
curl https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/.gitignore_global >> $HOME/.gitignore_global
git config --global core.excludesfile $HOME/.gitignore_global
