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
  sudo -E apt-get install -y tree lshw tar wget iotop htop iftop nmap mtr zsh tmux vim links youtube-dl cowsay fortune-mod rbenv git cmake curl g++ gcc sshuttle
  
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
    # brew cask install lighttable
    # brew cask install macvim
    brew cask install virtualbox
    # brew cask install vmware-fusion
    # brew cask install vagrant
    # brew cask install sourcetree
    # brew cask install charles
    brew cask install hex-fiend
    # brew cask install arduino
    # brew cask install google-earth
    # brew cask install slack
    brew cask install caffeine
    brew cask install flux
    brew cask install tunnelblick
    brew install ansible
    # brew install docker docker-machine docker-compose
    brew install aria2
    brew cask install arq
    brew cask install little-snitch

    # Link Cask Apps to Alfred
    # brew cask alfred link

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
  source /etc/profile.d/rvm.sh || source ~/.profile #Ubuntu
  sudo -E ~/.profile && gem install rdoc && gem install tmuxinator
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

touch ~/.zshrc ~/.tmux.conf ~/.vimrc 
sudo touch /etc/ssh/sshd_config

# zsh, oh-my-zsh
# location works for ubuntu, OSX
chsh -s /bin/zsh
curl -L -k https://raw.githubusercontent.com/RepoHell/oh-my-zsh/patch-1/tools/install.sh --retry 5 --retry-delay 5 | sh
mv ~/.zshrc ~/.zshrc.bak
curl https://gist.githubusercontent.com/jellyjellyrobot/d90796a4232deeda75bca7c70c758428/raw/.zshrc > ~/.zshrc

# tmuxinator
# export PATH="`ruby -e 'puts Gem.user_dir'`/bin:$PATH"


#sudo -E gem install rdoc
#sudo -E gem install tmuxinator
# Install fails in Centos with
# tmuxinator requires Ruby version >= 2.2.7.

mv ~/.tmux.conf ~/.tmux.conf.bak
curl https://gist.githubusercontent.com/jellyjellyrobot/d90796a4232deeda75bca7c70c758428/raw/.tmux.conf > ~/.tmux.conf
mkdir -p ~/.tmuxinator/jelly
curl https://gist.githubusercontent.com/jellyjellyrobot/d90796a4232deeda75bca7c70c758428/raw/mon.yml > ~/.tmuxinator/mon.yml
curl https://gist.githubusercontent.com/jellyjellyrobot/d90796a4232deeda75bca7c70c758428/raw/int.py > ~/.tmuxinator/jelly/int.py

# Tmux
git clone https://github.com/thewtex/tmux-mem-cpu-load ~/tmux-mem-cpu-load
cd  ~/tmux-mem-cpu-load
cmake .
make
sudo make install
cd ~/
rm -rf ~/tmux-mem-cpu-load

# Vim
mv ~/.vimrc ~/.vimrc.bak
curl https://gist.githubusercontent.com/jellyjellyrobot/d90796a4232deeda75bca7c70c758428/raw/.vimrc > ~/.vimrc
mkdir -p ~/.vim/dein.plugins ~/.vim/dein.repo
git clone https://github.com/Shougo/dein.vim ~/.vim/dein.repo
vim +":call dein#install() | :q"

# fzf

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# ~/.fzf/install

# Oh-my-zsh tab completions
## Find some [here](https://github.com/unixorn/awesome-zsh-plugins)

## Openstack
### https://github.com/t0mk/oh-my-zsh-openstack
cd ~
mkdir -p ~/.oh-my-zsh/custom/plugins/packer

git clone https://github.com/t0mk/oh-my-zsh-openstack ~/.oh-my-zsh/custom/plugins/oh-my-zsh-openstack
for d in $(find ~/.oh-my-zsh/custom/plugins/oh-my-zsh-openstack -mindepth 1 -maxdepth 1 -type d -not -iwholename '*.git'); do echo `basename $d`; ln -s $d .oh-my-zsh/custom/plugins/`basename $d`; done
rm -rf oh-my-zsh-openstack

## LXC
mkdir -p /root/.oh-my-zsh/custom/plugins/lxc
curl https://gist.githubusercontent.com/jellyjellyrobot/c672dc59810912779d0241914a12af48/raw/e0c4d5b999441d0c67562b068ebdf79ea8374773/_lxc > ~/.oh-my-zsh/custom/plugins/lxc/_lxc

## Additional zsh completions
### https://github.com/zsh-users/zsh-completions
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

## Packer
### https://github.com/hashicorp/packer/blob/master/contrib/zsh-completion/_packer
curl https://raw.githubusercontent.com/hashicorp/packer/master/contrib/zsh-completion/_packer > ~/.oh-my-zsh/custom/plugins/packer/_packer

## Replace plugins
# TODO



# Sane SSH
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sudo cat <<EOF >> /etc/ssh/sshd_config
# DNS
UseDNS no
# Request keepalive from client
ClientAliveInterval 20
ClientAliveCountMax 5
EOF

cat <<EOF >> ~/.ssh/config
Host *
  ServerAliveInterval 30
  ServerAliveCountMax 5
EOF

# SSH MOTD
curl https://gist.githubusercontent.com/jellyjellyrobot/d90796a4232deeda75bca7c70c758428/raw/motd >> /etc/motd

# Curl
curl https://gist.githubusercontent.com/jellyjellyrobot/d90796a4232deeda75bca7c70c758428/raw/.curlrc >> ~/.curlrc

# Gitconfig
curl https://gist.githubusercontent.com/jellyjellyrobot/d90796a4232deeda75bca7c70c758428/raw/.gitignore_global >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global