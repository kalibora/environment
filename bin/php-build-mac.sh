#!/bin/bash

#
# 先に下記のコマンドで php-build をインストールしておいてください
#
# ```
# ghq get git://github.com/php-build/php-build.git
# ln -s ~/ghq/github.com/php-build/php-build/bin/php-build ~/bin/php-build
# ```
#
# 依存するライブラリも brew install で入れておいてください
#
# デフォルトの configure options は
# share/php-build/default_configure_options に定義されています
#
# PHP_BUILD_INSTALL_EXTENSION に定義できるものは
# share/php-build/extension/definition に定義されているものだけです
#

if [ $# -ne 1 ]; then
    echo "# Usage"
    echo $0 "<php version>"
    echo ""
    echo "# The versions that can be specified are as follows"
    php-build --definitions | sort -V
    echo ""
    echo "## How to update versions list"
    echo "cd $(ghq root)/github.com/php-build/php-build && git fetch && git pull --rebase origin master"
    echo ""
    echo "# List of installed versions"
    ls -1 $HOME/.php
    exit 1
fi

if [ ! -d "$HOME/.php" ]; then
    mkdir $HOME/.php
fi

YACC="$(brew --prefix bison)/bin/bison"
PHP_BUILD_EXTRA_MAKE_ARGUMENTS="-j4"

if [ "$(printf '%s\n' "7" "$1" | sort -V | head -n1)" = "7" ]; then
    # Version 7 or higher
    PHP_BUILD_INSTALL_EXTENSION="apcu=@"

    PHP_BUILD_CONFIGURE_OPTS="
    --with-gmp
    --with-zlib=$(brew --prefix zlib)
    --with-bz2=$(brew --prefix bzip2)
    --with-curl=$(brew --prefix curl)
    --with-iconv=$(brew --prefix libiconv)
    --with-libedit=$(brew --prefix libedit)
    --with-tidy=$(brew --prefix tidy-html5)
    "
else
    # Version 5.6 or under
    PHP_BUILD_INSTALL_EXTENSION="apcu=4.0.11"

    PHP_BUILD_CONFIGURE_OPTS="
    --with-gmp
    --with-zlib=$(brew --prefix zlib)
    --with-bz2=$(brew --prefix bzip2)
    --with-curl=$(brew --prefix curl)
    --with-iconv=$(brew --prefix libiconv)
    --with-libedit=$(brew --prefix libedit)
    --with-onig=$(brew --prefix oniguruma-5.9.6)
    --without-tidy
    "
fi

php-build -i development {,~/.php/}$1
