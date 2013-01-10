# .zshrc

#--------------------------------------------------------------------
# common source
#--------------------------------------------------------------------
source .alias

#--------------------------------------------------------------------
# PATH
#--------------------------------------------------------------------
PATH=$HOME/bin:$HOME/local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin

#--------------------------------------------------------------------
# environment
#--------------------------------------------------------------------
ENV=$HOME/.zshrc; export ENV
export LESSCHARSET=utf-8

#--------------------------------------------------------------------
# php-version
#--------------------------------------------------------------------
export PHP_VERSIONS=$HOME/local/php/versions

which brew > /dev/null 2>&1
if [ $? -eq 0 ]; then
    #source $(brew --prefix php-version)/php-version.sh && php-version 5.3.14 >/dev/null
    source $(brew --prefix php-version)/php-version.sh && php-version 5.4.4 >/dev/null

    export APACHE_PATH=$(brew --prefix httpd)
fi

#--------------------------------------------------------------------
# nvm
#--------------------------------------------------------------------
export NVM_DIR=$HOME/.nvm
test -f $NVM_DIR/nvm.sh && source $NVM_DIR/nvm.sh

#--------------------------------------------------------------------
# color
#--------------------------------------------------------------------
local BLACK=$'%{\e[1;30m%}'
local RED=$'%{\e[1;31m%}'
local GREEN=$'%{\e[1;32m%}'
local BROWN=$'%{\e[1;33m%}'
local BLUE=$'%{\e[1;34m%}'
local MAGENTA=$'%{\e[1;35m%}'
local CYAN=$'%{\e[1;36m%}'
local WHITE=$'%{\e[1;37m%}'
local DEFAULT=$'%{\e[1;m%}'

case $HOST in
    *dev* | *local*) local DYNAMIC_COLOR=$GREEN;;
    *test*)          local DYNAMIC_COLOR=$BROWN;;
    *)               local DYNAMIC_COLOR=$MAGENTA;;
esac

#--------------------------------------------------------------------
# prompt & tiitle
#--------------------------------------------------------------------
#PROMPT='%n@%m%(!.#.$) '
#RPROMPT='[%~]'
PROMPT=$DYNAMIC_COLOR'%2m%(!.#.$) '$DEFAULT
RPROMPT=$DYNAMIC_COLOR'[%~]'$DEFAULT

# term title
precmd() {
  TITLE=`print -P \[%m:%~\] $USER`
  echo -n "\e]2;$TITLE\a"
}

# screen用title
# 接続中のマシンの hostname と、
# 最後に実行したコマンドを screen のステータスラインに表示する
# @see http://viz.is-a-geek.com/~viz/cw/index.php?zsh#k6d9975e
# @see http://web.archive.org/web/20051231065702/http://www.nijino.com/ari/diary/?20020614&to=200206141S1
if [ -n "$WINDOW" ]; then
    local -a host; host=`/bin/hostname | cut -d'.' -f1-2`
    echo -n "\033k$host:t\033\\"

    chpwd () { echo -n "_`dirs`\\" }
    preexec() {
        # see [zsh-workers:13180]
        # http://www.zsh.org/mla/workers/2000/msg03993.html
        emulate -L zsh
        local -a cmd; cmd=(${(z)2})
        case $cmd[1] in
            fg*)
                if (( $#cmd == 1 )); then
                    cmd=(builtin jobs -l %+)
                else
                    cmd=(builtin jobs -l $cmd[2])
                fi
                ;;
            %*)
                cmd=(builtin jobs -l $cmd[1])
                ;;
            cd)
                if (( $#cmd == 2)); then
                    cmd[1]=$cmd[2]
                fi
                ;&
            *)
                echo -n "k$host-$cmd[1]:t\\"
                return
                ;;
        esac

        local -A jt; jt=(${(kv)jobtexts})

        $cmd >>(read num rest
            cmd=(${(z)${(e):-\$jt$num}})
            echo -n "k$host-$cmd[1]:t\\") 2>/dev/null
    }
    chpwd
fi

#--------------------------------------------------------------------
# alias
#--------------------------------------------------------------------
alias d='cd_ext'
alias fg='fg_ext'
alias -g L="| $PAGER"
alias -g M="| $PAGER"
alias -g G='| grep'
alias -g C='| cat -n'
alias -g W='| wc'
alias -g H='| head'
alias -g T='| tail'

#--------------------------------------------------------------------
# keymap
#--------------------------------------------------------------------
bindkey -e                            # Emacsと同じキーバインドにする
stty stop undef                       # 前方検索を使いたいので

#--------------------------------------------------------------------
# completion
#--------------------------------------------------------------------
autoload -U compinit
compinit

# 補完の時に大文字小文字を区別しない (但し、大文字を打った場合は小文字に変換しない)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#--------------------------------------------------------------------
# history
#--------------------------------------------------------------------
HISTFILE=$HOME/.zsh-history           # 履歴をファイルに保存する
HISTSIZE=100000                       # メモリ内の履歴の数
SAVEHIST=100000                       # 保存される履歴の数
setopt extended_history               # 履歴ファイルに時刻を記録
setopt hist_ignore_all_dups hist_save_nodups # 重複するヒストリを持たない
setopt hist_ignore_dups
setopt hist_ignore_space
#setopt hist_verify
setopt append_history
setopt share_history                  # 履歴の共有
function history-all { history -E 1 } # 全履歴の一覧を出力する

#--------------------------------------------------------------------
# other shell options
#--------------------------------------------------------------------
setopt auto_cd                        # ファイル名だけでcdする
setopt auto_remove_slash              # いい感じに補完末尾の/を取る
setopt auto_list                      # 補完候補が複数ある時に、一覧表示する
setopt auto_menu                      # 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完する
setopt auto_param_keys                # カッコの対応などを自動的に補完する
setopt auto_param_slash               # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt correct                        # コマンドのスペルチェック
setopt NO_beep                        # ビープ音を鳴らさないようにする
setopt brace_ccl                      # {a-c} を a b c に展開する機能を使えるようにする

setopt autopushd                      # 自動でpushd
setopt pushd_ignore_dups              # 重複はpushしない

setopt extended_glob

#--------------------------------------------------------------------
# custome functions
#--------------------------------------------------------------------
function cd_ext() {
    dirs -v
    echo -n "select number: "
    read newdir
    if [ $newdir ]; then
        cd +"$newdir"
    fi
}

function fg_ext() {
    jobs
    echo -n "select number: "
    read job
    if [ $job ]; then
        \fg %"$job"
    else
        \fg
    fi
}
