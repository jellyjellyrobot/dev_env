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
  sudo -E yum install -y iproute procps tree lshw tar wget net-tools iotop htop iftop nmap mtr zsh tmux vim links youtube-dl cowsay fortune-mod git cmake curl gcc-c++ gcc sshuttle
  
  # /usr/local/bin utils
  sudo -E wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O /usr/local/bin/diff-so-fancy
  chmod +x /usr/local/bin/diff-so-fancy
  localedef -v -c -i en_US -f UTF-8 en_US.UTF-8
  
elif [ -f /etc/issue ]; then
  set -ex pipefail
  # Debian
  sudo -E apt-get update
  sudo -E apt-get upgrade -y
  sudo -E apt-get install -y inetutils-ping locales procps tree lshw tar wget iotop htop iftop nmap mtr zsh tmux vim links youtube-dl cowsay fortune-mod rbenv git cmake curl g++ gcc sshuttle
  sudo -E apt install -y iperf3 qemu qemu-kvm libvirt-bin bridge-utils virt-manager traceroute 

  sudo -E curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sudo -E sh /tmp/get-docker.sh
  sudo -E curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
  sudo -E python /tmp/get-pip.py
  sudo -E pip install virtualenv


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
    brew install lsusb ansible wget autoconf go openssh wireshark automake links openssl fortune tmux cmake python tree libusb python3 cowsay socat libusb-compat nmap rsync htop libtool telnet sshuttle diff-so-fancy source-highlight inetutils aria2 gawk gnutls gzip screen watch zsh

    brew install vim --with-lua
    brew install coreutils binutils diffutils
    brew install ed --with-default-names
    brew install findutils --with-default-names
    brew install gnu-indent --with-default-names
    brew install gnu-sed --with-default-names
    brew install gnu-tar --with-default-names
    brew install gnu-which --with-default-names
    brew install grep --with-default-names
    brew install wdiff --with-gettext

    brew cask install firefox vlc google-chrome alfred skype sublime-text virtualbox hex-fiend caffeine tunnelblick arq little-snitch 

    open /usr/local/Caskroom/little-snitch/*/*.dmg

    # Ruby
    rbenv install 2.5.0
    rbenv global 2.5.0
  fi
fi

##
# Dein requires vim 8, since ubuntu dastardly's not supporting vim 8, we'll have to find a way to install it.
##

## If Linux Based, Install vim from source

# Package Depedency from
# https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source

vim --version | grep compiled | egrep '8\.[0-9]'
VIM_GOOD=$?

if [ $VIM_GOOD -ne 0 ] ; then

  if [ -f /etc/issue ]; then

  apt remove vim

  apt install -y \
    libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
    python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev git

  elif [ -f /etc/redhat-release ]; then

  yum remove vim

  yum install -y \
    ruby ruby-devel lua lua-devel luajit \
    luajit-devel ctags git python python-devel \
    python36 python36-devel tcl-devel \
    perl perl-devel perl-ExtUtils-ParseXS \
    perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
    perl-ExtUtils-Embed \
    ncurses ncurses-devel ncurses-libs ncurses-base ncurses-term
  endif

  fi

  if [ -f /etc/issue ] || [ -f /etc/redhat-release ]; then

  mkdir -p ~/git/vim
  git clone https://github.com/vim/vim.git ~/git/vim
  cd ~/git/vim/src

  make distclean || true

  ./configure \
    --with-features=huge \
    --enable-perlinterp=yes \
    --enable-pythoninterp=yes \
    --enable-python3interp=yes \
    --enable-rubyinterp=yes \
    --enable-terminal \
    --enable-autoservername \
    --enable-xim \
    --enable-fontset \
    --enable-gui=auto \
    --with-x \
    --enable-fail-if-missing

  #  --enable-multibyte \
  #  --enable-hangulinput \

  make
  sudo make install

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
  #curl -sSL https://rvm.io/mpapis.asc | gpg --import -
  #curl -L get.rvm.io | bash -s stable --ruby
  #source /etc/profile.d/rvm.sh || source $HOME/.profile #Ubuntu
  gem install rdoc && gem install tmuxinator
  #rvm reload
  #rvm requirements run
  #rvm install 2.5.0
  #rvm use 2.5.0
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
chsh -s `which zsh`
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
wget https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/.gitconfig -O /tmp/.gitconfig
cat /tmp/.gitconfig >> $HOME/.gitconfig
curl https://raw.githubusercontent.com/jellyjellyrobot/dev_env/master/config_files/.gitignore_global >> $HOME/.gitignore_global
git config --global core.excludesfile $HOME/.gitignore_global

