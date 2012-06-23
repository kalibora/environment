PATH=$HOME/bin:$HOME/local/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/X11R6/bin; export PATH

BLOCKSIZE=K;  export BLOCKSIZE
EDITOR=emacs; export EDITOR
PAGER=less;   export PAGER

ENV=$HOME/.shrc; export ENV

[ -x /usr/games/fortune ] && /usr/games/fortune freebsd-tips

LANG=ja_JP.UTF-8; export LANG

### ls colors
# BSD ls
LSCOLORS=gxfxcxdxbxegedabagacdx; export LSCOLORS

LESS='-X -i -P ?f%f:(stdin).  ?lb%lb?L/%L..  [?eEOF:?pb%pb\%..]'; export LESS
