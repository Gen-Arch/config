# .bashrc
#==========================================================================================
# Source global definitions
#==========================================================================================
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi
#==========================================================================================
#local configurarion
#==========================================================================================
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
#==========================================================================================
# Peco (https://github.com/peco/peco/releases/download/v0.5.3/peco_linux_amd64.tar.gz)
#==========================================================================================
#peco current search
function find_cd() {
    cd "$(find . -type d | peco)"
}

function peco-lscd {
  local dir="$( ls | peco )"
  if [ -f "$dir" ]; then
    vi "$dir"
  else
    if [ ! -z "$dir" ] ; then
      cd "$dir"
    fi
  fi
}
#==========================================================================================
#Export
#==========================================================================================
export PATH=$PATH:/sbin:/usr/sbin:$HOME/bin # パス
export EDITOR='vim' # visudo とかで使われる
export HISTSIZE=100000 # これだけコマンド履歴を残す
export LANG='ja_JP.UTF-8' # 以下 3 つ文字コード
export LC_ALL='ja_JP.UTF-8'
export LC_MESSAGES='ja_JP.UTF-8'
export XDG_CONFIG_HOME="$HOME/config"
#==========================================================================================
#Alias
#==========================================================================================
  [ -f ~/config/.aliasrc ] && source ~/config/.aliasrc

#==========================================================================================
#Prompt configurarion
#==========================================================================================
source ${HOME}/dotfiles/git-prompt.sh
source ${HOME}/dotfiles/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
#export PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '
export PS1='\[\033[36;40;1m\] [\u@\h]\[\033[01;34m\] \w\[\033[00m\] \[\033[31m\]$(__git_ps1)\[\033[00m\]\[\033[01;34m\]\$\[\033[00m\]'

#==========================================================================================
#Rbenv
#==========================================================================================
if [[ -e $HOME/.rbenv ]]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

#==========================================================================================
#Pyenv
#==========================================================================================
if [ -e ~/.pyenv ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi
