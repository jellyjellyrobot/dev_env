# Jelly's ZSH RC 

###
# Lang
###

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

###
# ZSH
###

export SHELL=`which zsh`
export UPDATE_ZSH_DAYS=7
export ZSH=~/.oh-my-zsh
export ZSH_THEME="murilasso"

# History display format
# HIST_STAMPS="dd/mm/yyyy"
# export HISTTIMEFORMAT="%Y-%m-%d %T "
alias history="history -t'%F %T'"

# oh-my-zsh plugins definition
# plugins=(git)

# oh-my-zsh source
export DISABLE_AUTO_UPDATE="true" 
source ${ZSH}/oh-my-zsh.sh

# Watch logins
watch=all
LOGCHECK=5  # every 5 seconds
WATCHFMT="%B%n%b from %B%M%b has %a tty%l at %D{'%d/%m/%y %T %Z'}"

###
# Key Bindings
###

# Bindings for mac keyboards
if [ -f /etc/redhat-release ]; then
  :
elif [ -f /etc/issue ]; then
  :
elif [ $(uname) '==' 'Darwin' ]; then
  bindkey -s "^[OM" "^M"
fi

###
# Shell defaults
###

export EDITOR='vim'

###
# Root Prompt should end with "#", thanks SB
###

if [ `whoami` = "root" ]; then
  export PS1=`echo ${PS1} | sed 's/\%B$\%b/\%B#\%b/'`
else 
  export PS1=`echo ${PS1} | sed 's/\%B#\%b/\%B$\%b/'`
fi

###
# Path
###

if [ -f /etc/redhat-release ]; then
  :
elif [ -f /etc/issue ]; then
  export PATH=$PATH:/usr/games  
elif [ $(uname) '==' 'Darwin' ]; then
  export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
  alias flushdns='sudo discoveryutil mdnsflushcache && sudo discoveryutil udnsflushcaches && sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.discoveryd.plist && sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.discoveryd.plist'
  alias less='less -m -N -g -i -J --underline-special --SILENT'
  # alias more='less'
  alias dd='sudo gdd status=progress bs=4M'
fi

###
# Generic Aliases
###

if [ -f /etc/redhat-release ]; then
  alias sdd="sudo dd status=progress bs=4M"
elif [ -f /etc/issue ]; then
  alias sdd="sudo dd status=progress bs=4M"
elif [ $(uname) '==' 'Darwin' ]; then
  alias flushdns='sudo discoveryutil mdnsflushcache && sudo discoveryutil udnsflushcaches && sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.discoveryd.plist && sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.discoveryd.plist'
  alias sdd='sudo gdd status=progress bs=4M'
fi

# Date Alias
alias getDate="export DATE=${1:-\`date +%Y-%m-%d-%H-%M-%S\`}; echo \$DATE"

# Less
alias less='less -m -N -g -i -J --underline-special --SILENT'

###
# Program Defaults
###

###
# Ansible
###

export ANSIBLE_NOCOWS="1"

###
# aria2c
###

if hash aria2c 1>/dev/null 2>/dev/null; then
  alias aria="aria2c -s 4 -x 4"
fi

###
# Chrome, Chromium
###

if [ -f /etc/redhat-release ]; then
  alias cchrome="chromium --user-data-dir="/tmp/chrome_dev_session_`openssl rand -hex 4`" --disable-web-security"
  alias ccchrome="chromium --user-data-dir="/tmp/chrome_dev_session_`openssl rand -hex 4`" --disable-web-security"
  alias chrome="cchrome"
elif [ -f /etc/issue ]; then
  alias cchrome="chromium --user-data-dir="/tmp/chrome_dev_session_`openssl rand -hex 4`" --disable-web-security"
  alias ccchrome="chromium --user-data-dir="/tmp/chrome_dev_session_`openssl rand -hex 4`" --disable-web-security"
  alias chrome="cchrome"
elif [ $(uname) '==' 'Darwin' ]; then
  alias cchrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="/tmp/chrome_dev_session_`openssl rand -hex 4`"'
  alias ccchrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="/tmp/chrome_dev_session_`openssl rand -hex 4`" --disable-web-security'
  # cchrome --proxy-server="socks://localhost:8080"
fi

###
# Git
###

alias gita='git add -A'
alias gitc='git commit -m'
alias gitp='git push origin master'
gitdd () {
	echo "Files untracked but to be staged\n"
	git ls-files --others --exclude-standard
	echo "\nFor more info try < git status >"
	git diff --color "$@" | diff-so-fancy | less
}

###
# Grep
###

alias grepp='grep -rnw '.' -e'
greppo () {
    echo "Grabbing $@ from `pwd`";
    grep -rnwi . -e ".*$@.*" | grep -i --color=always $@ | \
        sed -E 's/^([^:]+)(:)([0-9]+)(:)/\o033[0;32m\1\o033[0m\2\o033[0;36m\3\o033[0m\4/';
}

###
# Python
###

###
# Rancid, clogin
###

if ls /var/lib/rancid/bin 1>/dev/null 2>/dev/null ; then
  export PATH=$PATH:/var/lib/rancid/bin
fi

###
# Ruby
###

# PATH="`ruby -e 'puts Gem.user_dir'`/bin:$PATH"

if [ -f /usr/local/rvm/scripts/rvm ]; then
  source /usr/local/rvm/scripts/rvm
fi

if [ -f /etc/profile.d/rvm.sh ]; then
  source /etc/profile.d/rvm.sh
fi

###
# SSH
###

if [ -f /etc/redhat-release ]; then
  # [Red Hat Based Systems]
  # SSHagent
  if [ `ps aux | grep ssh-agent | wc -l` -ne 1 ]; then
    SSH_PID=`ps aux | grep ssh-agent | egrep $(ls -l /tmp/ssh-*/agent.* | cut -d '.' -f 2 | paste -s -d '|') | awk '{print $2}'`
    SSH_SOCK=`ls -l /tmp/ssh-*/agent.* | grep "$SSH_PID" | awk '{print $NF}'`
    SSH_AUTH_SOCK=$SSH_SOCK; export SSH_AUTH_SOCK;
  fi
elif [ -f /etc/issue ]; then
  # [Debian based Systems]
  # SSHagent
  if [ `ps aux | grep ssh-agent | wc -l` -ne 1 ]; then
    SSH_PID=`ps aux | grep ssh-agent | egrep $(ls -l /tmp/ssh-*/agent.* | cut -d '.' -f 2 | paste -s -d '|') | awk '{print $2}'`
    SSH_SOCK=`ls -l /tmp/ssh-*/agent.* | grep "$SSH_PID" | awk '{print $NF}'`
    SSH_AUTH_SOCK=$SSH_SOCK; export SSH_AUTH_SOCK;  
  fi
elif [ $(uname) '==' 'Darwin' ]; then
  # [macOS based Systems]
  :
fi

alias ssh-add-all='ssh-add $(ls ~/.ssh/*.pub | sed 's/.pub//g')'

###
# wget - mirror site
###

mirror_site(){
  # Usage mirror_site http://user:password@subdomain.domain.net:8081/directory/
  # Thanks https://stackoverflow.com/a/44152897 for the regex
  URL=$1
  DOMAIN=`sed -E -e 's_.*://([^/@]*@)?([^/:]+).*_\2_' ${URL}`
  wget \
    --recursive \
    --no-clobber \
    --page-requisites \
    --html-extension \
    --convert-links \
    --restrict-file-names=windows \
    --domains ${DOMAIN} \
    --no-parent \
    ${URL}
}

###
# Youtube-DL
###

# Playlist
alias youp="youtube-dl \
  -o '%(uploader)s/%(creator)s_%(channel)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' \
  --continue \
  --ignore-errors \
  --no-overwrites \
  --download-archive .archive \
  --add-metadata \
  --all-subs \
  --embed-subs \
  --embed-thumbnail \
  --write-all-thumbnails \
  --write-annotations \
  --write-info-json \
  --write-thumbnail \
  -f bestvideo+bestaudio \
  --merge-output-format mkv \
  -i "

# Single / Creator / Channel Based
alias yout="youtube-dl \
  -o '%(uploader)s/%(creator)s_%(channel)s/%(title)s.%(ext)s' \
  --continue \
  --ignore-errors \
  --no-overwrites \
  --download-archive .archive \
  --add-metadata \
  --all-subs \
  --embed-subs \
  --embed-thumbnail \
  --write-all-thumbnails \
  --write-annotations \
  --write-info-json \
  --write-thumbnail \
  -f bestvideo+bestaudio \
  --merge-output-format mkv \
  -i "

###
# Init Screen
###


###
# cowsay fortune
###

if command -v fortune 2>&1 > /dev/null && command -v cowsay 2>&1 > /dev/null; then
	COWS=(`cowsay -l | tail -n +2 | tr '\n' ' '`)
	THE_CHOSEN_COW=${COWS[$(($RANDOM % ${#COWS[@]} + 1)) ]}
	# NOT SAFE FOR WORK!
	# command cowsay -W $((`tput cols` - 20)) -f ${THE_CHOSEN_COW} $(fortune)
	command cowsay $(fortune)
fi

alias debug-env=' \
  echo -e "\n###\n# Currently logged in users\n###\n"; \
  w; \
  who -a; \
  echo -e "\n###\n# Disk and Memory\n###\n"; \
  lsblk -h; \
  df -h; \
  free -m; \
  command echo -e "\n###\n# Tmux Sessions Active\n###\n"; \
  tmux list-sessions; \
  command echo -e "\n###\n# Docker Containers Active\n###\n"; \
  command docker ps -a;
'

## CTF Helpers

alias cheat='
  while true; \
  do \
    echo "cat /var/tmp/* /dev/shm/*; exit" | \
    nc challenge.me.ooo 8081 >> hello.txt; \
    sleep 0.1; \
  done
'
