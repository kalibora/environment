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

for path in `find $DIR -type f | grep -v symlink.sh`
do
    if [ ! -d $HOME/bin ]; then
        $DRYRUN mkdir $HOME/bin
    fi

    $DRYRUN ln -s $OPTION $path $HOME/bin
done
