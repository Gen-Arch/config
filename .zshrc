if [ -z "$SH_LOAD" ]; then
  export SH_LOAD="tm"
  P_TM=`ps aux | awk -v "pid=$PPID" '$2 == pid{ print $11 }'`
  if [[ ! $P_TM =~ tmux ]] && [ -f ~/.tmux.conf ];
  then
      echo "start tmux"
      tmux
      exit
  fi
fi
[ -f ~/.zlogin ] && source ~/.zlogin
if [ $SH_LOAD = "tm" ] || [ $SH_LOAD = "sc" ]; then
  echo "include .zshrc"
  #=======================================
  #ローカル設定読み込み
  #=======================================
  [ -f ~/.zshrc.local ] && source ~/.zshrc.local
  #=======================================
  #基本設定
  #=======================================
  # 補完候補を一覧で表示する
  setopt auto_list

  # 補完キー連打で候補順に自動で補完する
  #setopt auto_menu

  # cd 時に自動でディレクトリスタックに追加する
  setopt auto_pushd

  # コマンド履歴に実行時間も記録する
  setopt extended_history

  # 履歴中の重複行をすべて削除する
  setopt hist_ignore_all_dups

  # 直前と重複するコマンドを記録しない
  setopt hist_ignore_dups

  # コマンド中の余分なスペースは削除して履歴に記録する
  setopt hist_reduce_blanks

  # 履歴と重複するコマンドを記録しない
  setopt hist_save_no_dups

  # ^D でシェルを終了しない
  setopt ignore_eof

  # 履歴をすぐに追加する（通常はシェル終了時）
  setopt inc_append_history

  # # 以降をコメントとして扱う
  setopt interactive_comments

  # ビープを無効にする
  setopt no_beep
  setopt no_hist_beep
  setopt no_list_beep

  # = 以降も補完する（例：--option=value）
  setopt magic_equal_subst

  # バックグラウンド処理の状態変化をすぐに通知する
  setopt notify

  # 8bit文字を有効にする
  setopt print_eight_bit

  # 終了ステータスが0以外の場合にステータスを表示する
  setopt print_exit_value

  # VCS情報の表示を有効にする
  setopt prompt_subst

  # ディレクトリスタックと重複したディレクトリをスタックに追加しない
  setopt pushd_ignore_dups

  # rm * の前に確認をとる
  setopt rm_star_wait

  # Zsh間で履歴を共有する
  setopt share_history

  # コマンド実行後は右プロンプトを消す
  setopt transient_rprompt
  #=======================================


  #=======================================
  #autoloadコマンド:実際に実行されるまで関数本体の読み込みを遅らせる際に使用
  #=======================================
  # フック機能を有効にする
  autoload -Uz add-zsh-hook

  # コマンドのオプションや引数を補完する
  autoload -Uz compinit && compinit -u

  # URLをエスケープする
  autoload -Uz url-quote-magic

  # VCS情報の表示を有効にする
  autoload -Uz vcs_info

  #色の変更
  autoload -Uz colors
  colors

  #vcs_info の宣言と設定
  autoload -Uz vcs_info
  #=======================================

  # 文字入力時にURLをエスケープする
  zle -N self-insert url-quote-magic

  #=======================================
  #環境変数
  #=======================================
  # ls 時の色を設定する
  export CLICOLOR=true
  export LSCOLORS='exfxcxdxbxGxDxabagacad'
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

  # 標準エディタを設定する
  export EDITOR=vim

  # コマンド履歴を保存するファイルを指定する
  export HISTFILE=~/.zhistory

  # メモリに保存する履歴の件数を指定する
  export HISTSIZE=1000

  # ファイルに保存する履歴の件数を指定する
  export SAVEHIST=1000000

  # 文字コードを設定する
  export LANG=ja_JP.UTF-8

  #PATH追加
  export PATH=$PATH:$HOME/bin
  export SHELL="/usr/bin/zsh"
  #=======================================

  #=======================================
  #anyframe(https://github.com/mollifier/anyframe ~/.temp/anyframe)
  #=======================================
  fpath=(~/.temp/anyframe(N-/) $fpath)

  autoload -Uz anyframe-init
  anyframe-init
  #=======================================

  #=======================================
  #キーバインド
  #=======================================
  # コマンドラインの編集モードをViにする
  bindkey -v

  # バックスペースキーで文字を削除する
  bindkey -v '^?' backward-delete-char

  # Shift-Tabで候補を逆順に補完する
  bindkey '^[[Z' reverse-menu-complete

  # ghq で管理しているリポジトリから検索・移動する
  bindkey '^@' anyframe-widget-cd-ghq-repository

  # コマンドを履歴から検索・実行する
  bindkey '^r' anyframe-widget-put-history
  #=======================================

  #=======================================
  #関数
  #=======================================
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
  #=======================================
  #エイリアス
  #=======================================
  alias vi="vim"
  alias be="bundle exec"
  alias bi="bundle install --path vendor/bundle"
  alias la="ls -al"
  alias ll="ls -l"
  alias ps="ps aux"
  alias psp="ps aux | peco"
  alias pls=peco-lscd

  #=======================================
  #モジュール(http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Standard-Styles)
  #=======================================
  # 補完の表示方法を変更する
  zstyle ':completion:*' completer _complete _match _approximate
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
  zstyle ':completion:*' use-cache true
  zstyle ':completion:*' verbose yes
  zstyle ':completion:*:default' menu select=2
  zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
  zstyle ':completion:*:options' description 'yes'
  zstyle ':vcs_info:git:*' check-for-changes true #formats 設定項目で %c,%u が使用可
  zstyle ':vcs_info:git:*' stagedstr "%F{green}!" #commit されていないファイルがある
  zstyle ':vcs_info:git:*' unstagedstr "%F{magenta}+" #add されていないファイルがある
  zstyle ':vcs_info:*' formats "%F{cyan}%c%u(%b)%f" #通常
  zstyle ':vcs_info:*' actionformats '[%b|%a]' #rebase 途中,merge コンフリクト等 formats 外の表示
  #=======================================

  #=======================================
  #プロンプト
  #=======================================
  # プロンプト表示直前に vcs_info 呼び出し
  precmd () { vcs_info }

  # プロンプト（左）
  PROMPT='%{$fg[red]%}[%n@%m]%{$reset_color%}'
  PROMPT=$PROMPT'${vcs_info_msg_0_} %{${fg[red]}%}%}$%{${reset_color}%} '

  # プロンプト（右）
  RPROMPT='%{${fg[red]}%}[%~]%{${reset_color}%}'
  #=======================================
  #pyenv & rbenv
  #=======================================
  if [ -e ~/.rbenv ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
  fi

  if [ -e ~/.pyenv ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
  fi
  export SH_LOAD="exit"
  cd ~
fi
