#!/bin/sh

DIR=$(cd $(dirname $0) && pwd)

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

for confdir in `find $HOME/.php -name 'conf.d' -type d`
do
    for path in `find $DIR -type f -name '*.ini'`
    do
        $DRYRUN ln -s $OPTION $path $confdir
    done
done
