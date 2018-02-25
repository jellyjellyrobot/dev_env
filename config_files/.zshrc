# Tmuxinator
export ZSH=~/.oh-my-zsh
#PATH="`ruby -e 'puts Gem.user_dir'`/bin:$PATH"

ZSH_THEME="murilasso"

export UPDATE_ZSH_DAYS=7
export SHELL='zsh'

HIST_STAMPS="dd/mm/yyyy"
plugins=(git glance nova zsh-completions lxc)

export DISABLE_AUTO_UPDATE="true" # Check .oh-my-zsh/oh-my-zsh.sh
source $ZSH/oh-my-zsh.sh

# for mac keyboards
bindkey -s "^[OM" "^M"

# Aliases and Exports
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
  export PATH=$PATH:/usr/games
  
  # SSHagent
  if [ `ps aux | grep ssh-agent | wc -l` -ne 1 ]; then
    SSH_PID=`ps aux | grep ssh-agent | egrep $(ls -l /tmp/ssh-*/agent.* | cut -d '.' -f 2 | paste -s -d '|') | awk '{print $2}'`
    SSH_SOCK=`ls -l /tmp/ssh-*/agent.* | grep "$SSH_PID" | awk '{print $NF}'`
    SSH_AUTH_SOCK=$SSH_SOCK; export SSH_AUTH_SOCK;
  
  fi

elif [ $(uname) '==' 'Darwin' ]; then
  # [macOS based Systems]
  export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
  if [[ $(sw_vers -productName) == *Mac* ]]; then
    if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
    alias flushdns='sudo discoveryutil mdnsflushcache && sudo discoveryutil udnsflushcaches && sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.discoveryd.plist && sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.discoveryd.plist'
    # https://gist.github.com/textarcana/4611277
    export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
    export LESS=" -R "
    alias less='less -m -N -g -i -J --underline-special --SILENT'
    alias more='less'
    alias dd='sudo gdd status=progress bs=4M'
  fi
  
  # OPSec
  alias grip="echo 'no'"
  
fi

# Root should always be '#'
# Noobs should always be '$'
# Thanks SB

if [ -f /etc/redhat-release ]; then
  # [Red Hat Based Systems]
  :
elif [ -f /etc/issue ]; then
  # [Debian based Systems]
  export PATH=$PATH:/usr/games
  if [ $USER = "root" ]; then
    export PS1=`echo ${PS1} | sed 's/\%B$\%b/\%B#\%b/'`
  else 
    export PS1=`echo ${PS1} | sed 's/\%B#\%b/\%B$\%b/'`
  fi
else
  :
fi


export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export EDITOR='vim'

# Python
if ls ~/.pythonrc 1>/dev/null 2>/dev/null
	then
	export PYTHONSTARTUP=~/.pythonrc
fi

## For pip packages installed with pip install --user
if [ $(uname) '==' 'Darwin' ]; then
  # [macOS based Systems]
    if [[ $(sw_vers -productName) == *Mac* ]]; then
        export PATH="$PATH:/Users/$USER/Library/Python/2.7/bin/"
    fi
  alias ssh-add-all='ssh-add $(ls ~/.ssh/*.pub | sed 's/.pub//g')'
fi

# Youtube-DL
if hash youtube-dl 1>/dev/null 2>/dev/null
	then
	alias yout='youtube-dl -f bestvideo+bestaudio'
  alias youn='yout -o "%(autonumber)s-%(title)s.%(ext)s"'
fi

# Git
alias gita='git add -A'
alias gitc='git commit -m'
alias gitp='git push origin master'
gitdd () {
	echo "Files untracked but to be staged\n"
	git ls-files --others --exclude-standard
	echo "\nFor more info try < git status >"
	git diff --color "$@" | diff-so-fancy | less
}

alias grepp='grep -rnw '.' -e'

if hash aria2c 1>/dev/null 2>/dev/null
  then
  alias aria="aria2c -s 4 -x 4"
fi

# SuperCow Power
export ANSIBLE_NOCOWS="1"

# Watch logins
watch=all
LOGCHECK=5  # every 5 seconds
WATCHFMT="%B%n%b from %B%M%b has %a tty%l at %D{'%d/%m/%y %T %Z'}"

## MOTD
COWS=(`cowsay -l | tail -n +2 | tr '\n' ' '`)
THE_CHOSEN_COW=${COWS[$(($RANDOM % ${#COWS[@]} + 1)) ]}
# NOT SAFE FOR WORK!
# command cowsay -W $((`tput cols` - 20)) -f ${THE_CHOSEN_COW} $(fortune)
command cowsay $(fortune)