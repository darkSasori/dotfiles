if [ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
fi

source ~/.dotfiles/git-prompt.sh
source ~/.dotfiles/lib.sh

complete -cf sudo

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete

export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth
export JAVA_FONTS=/usr/share/fonts/TTF
export EDITOR=/usr/bin/vim

alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=tty -d skip'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano PKGBUILD'
alias fixit='sudo rm -f /var/lib/pacman/db.lck && sudo pacman-mirrors -g && sudo pacman -Syyuu  && sudo pacman -Suu'
alias gbranch="git branch |grep '^*' |cut -d' ' -f2"
alias virtualenv-list="ls -1 ~/.virtualenv"
alias fucking-commit="git add . && git commit --amend --no-edit && git push -f"

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

gpull() {
    branch=`gbranch`;
    git checkout master;
    git pull -p;
    git checkout $branch;
}

activate() {
    dir=$1
    if [ -z $dir ]; then
        dir=$(basename $PWD)
    fi
    file=~/.virtualenv/$dir/bin/activate
    if [ -f "$file" ]; then
        source $file
    else
        echo "Virtualenv '$dir' not found"
    fi
}

_activate()
{
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="$(virtualenv-list)"

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}
complete -F _activate activate

# TMUXP bash completion
_tmuxp_completion() {
    local cur opts filedir=0
    COMPRELY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    if [ $COMP_CWORD == 1 ]; then
        opts="convert freeze import load"
    elif [ "${COMP_WORDS[1]}" == "load" ]; then
        opts=`ls ~/.tmuxp |sed -e 's/.yml//'`
    else
        filedir=1
        _filedir
    fi

    if [ $filedir == 0 ]; then
        COMPREPLY=($(compgen -W "$opts" -- ${cur}))
    fi
}
complete -F _tmuxp_completion tmuxp

# prompt
__ps1() {
    local pwd=`pwd`
    local len=$((`tput cols` - ${#pwd}))

    if  [ $len -lt 40 ]; then
        echo ""
    fi
    echo -n " "
}

PS1='\w $(__git_ps1 "(%s)")$(__ps1)$ '
if [ `tput colors` -ge 8 ]; then
    PS1='\[\033[01;34m\]\w\[\033[00m\] $(__git_ps1 "(%s)")$(__ps1)$ '
fi


export GOPATH=~/gocode
export PATH=$PATH:~/.dotfiles/bin:$GOPATH/bin:~/.local/bin;

source ~/.dotfiles/deps/deps.sh
