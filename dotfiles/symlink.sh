#!/bin/sh

#
# dotfiles
#

DOTDIR=$(cd $(dirname $0) && pwd)

OPTION=""
DRYRUN=""
while getopts nfv OPT
do
    case $OPT in
        "n" ) DRYRUN="echo"       ;;  # dryrun
        "f" ) OPTION="$OPTION -f" ;;  # force
        "v" ) OPTION="$OPTION -v" ;;  # verbose
        *   ) echo "usage: $0 [-fvn]"
            exit 1;;
    esac
done

for path in `find $DOTDIR -type f -name '.*' | grep -v .svn`
do
    $DRYRUN ln -s $OPTION $path $HOME/
done

for path in `find $DOTDIR -type d -name '.*' | grep -v .svn`
do
    $DRYRUN ln -s $OPTION $path $HOME/
done
