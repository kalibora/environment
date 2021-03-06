# .bashrc

#--------------------------------------------------------------------
# common source
#--------------------------------------------------------------------
source .alias

#--------------------------------------------------------------------
# environment
#--------------------------------------------------------------------
ENV=$HOME/.bashrc; export ENV

#--------------------------------------------------------------------
# prompt
#--------------------------------------------------------------------
PS1="\[\033]2;[\h:\w] \u \007\]\[\033[4;00m\]\u@\h [\w]\n\$\[\033[0m\] "

# mysql
#export MYSQL_PS1="[\u@\h:\d]mysql> "

#--------------------------------------------------------------------
# alias
#--------------------------------------------------------------------
alias ..='cd ..'

# no create core file
#ulimit -c 0
