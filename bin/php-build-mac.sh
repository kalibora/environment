#!/bin/bash

if [ $# -ne 1 ]; then
    echo $0 "<php version>"
    exit 1
fi

YACC="$(brew --prefix bison)/bin/bison"

PHP_BUILD_EXTRA_MAKE_ARGUMENTS="-j4"

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

php-build -i development {,~/.php/}$1
