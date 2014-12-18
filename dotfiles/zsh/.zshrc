# .zshrc

#--------------------------------------------------------------------
# common source
#--------------------------------------------------------------------
HOST_LIST_DEV=()
HOST_LIST_TEST=()
HOST_LIST_PROD=()

source .alias

#--------------------------------------------------------------------
# PATH
#--------------------------------------------------------------------
PATH=$HOME/bin:$HOME/local/bin:$HOME/.composer/vendor/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

#--------------------------------------------------------------------
# environment
#--------------------------------------------------------------------
ENV=$HOME/.zshrc; export ENV
export LESSCHARSET=utf-8

#--------------------------------------------------------------------
# php-version
#--------------------------------------------------------------------
export PHP_VERSIONS=$HOME/local/php/versions
PHP_VERSION=5.4.4

which brew > /dev/null 2>&1
if [ $? -eq 0 ]; then
    PHP_VERSIONS_SH=$(brew --prefix php-version)/php-version.sh
    test -f $PHP_VERSIONS_SH && source $PHP_VERSIONS_SH && php-version $PHP_VERSION >/dev/null

    export APACHE_PATH=$(brew --prefix httpd)
fi

#--------------------------------------------------------------------
# nvm
#--------------------------------------------------------------------
export NVM_DIR=$HOME/.nvm
test -f $NVM_DIR/nvm.sh && source $NVM_DIR/nvm.sh

#--------------------------------------------------------------------
# go
#--------------------------------------------------------------------
export GOPATH=$HOME/.go
PATH=$GOPATH/bin:$PATH

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

for h in $HOST_LIST_DEV; do
    if [ "$h" = "$HOST" ]; then
        local DYNAMIC_COLOR=$GREEN
    fi
done
for h in $HOST_LIST_TEST; do
    if [ "$h" = "$HOST" ]; then
        local DYNAMIC_COLOR=$BROWN
    fi
done
for h in $HOST_LIST_PROD; do
    if [ "$h" = "$HOST" ]; then
        local DYNAMIC_COLOR=$MAGENTA
    fi
done

#--------------------------------------------------------------------
# prompt & title
#--------------------------------------------------------------------

# See http://liosk.blog103.fc2.com/blog-entry-209.html
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' formats       '%b '
zstyle ':vcs_info:*' actionformats '%b|%a '

#PROMPT='%n@%m%(!.#.$) '
#RPROMPT='[%~]'
#RPROMPT=$DYNAMIC_COLOR'[%~]'$DEFAULT
if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
    # ssh
    PROMPT=$DYNAMIC_COLOR'[%D %T] %n@%2m%(!.#.$) '$DEFAULT
else
    # no ssh(local)
    PROMPT=$DYNAMIC_COLOR'[%D %T] %n%(!.#.$) '$DEFAULT
fi

# term title
precmd() {
  LANG=en_US.UTF-8 vcs_info
  RPROMPT=$DYNAMIC_COLOR'[${vcs_info_msg_0_}%~]'$DEFAULT

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
# ssh agent
# See: http://www.gcd.org/blog/2006/09/100/
#--------------------------------------------------------------------
agent="$HOME/tmp/ssh-agent-$USER"
if [ -S "$SSH_AUTH_SOCK" ]; then
    case $SSH_AUTH_SOCK in
        /tmp/*/agent.[0-9]*)
            ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
    esac
elif [ -S $agent ]; then
    export SSH_AUTH_SOCK=$agent
else
    echo "no ssh-agent"
fi

#--------------------------------------------------------------------
# alias
#--------------------------------------------------------------------
alias d='cd_stack_peco'
alias dd='cd_stack_ext'
alias dfind='cd_find_peco'
alias fg='fg_peco'
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

# mosh でも ssh の補完
compdef mosh=ssh

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
setopt transient_rprompt              # 最後の行だけRPROMPTを表示

#--------------------------------------------------------------------
# custome functions
#--------------------------------------------------------------------
function cd_find_peco() {
    # .git系など不可視フォルダは除外
    local newdir="$(find . -maxdepth 5 -type d ! -path "*/.*"| peco)"
    if [ -d "$newdir" ]; then
        cd "$newdir"
    fi
}

function cd_stack_peco() {
    local newdir="$(dirs -p -l | peco | head -n 1)"
    if [ ! -z "$newdir" ] ; then
        cd "$newdir"
    fi
}

function cd_stack_ext() {
    dirs -v
    echo -n "select number: "
    read newdir
    if [ $newdir ]; then
        cd +"$newdir"
    fi
}

function fg_peco() {
    local job=$(jobs | grep '^\[' | peco | head -n 1 | awk '{print $1}' | sed 's,\(\[\|\]\),,g')

    if [ $job ]; then
        \fg %"$job"
    else
        \fg
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

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
#    zle accept-line

    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history
