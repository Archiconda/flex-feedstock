#!/bin/bash
set -ex

# skip the creation of man pages by faking existance of help2man
if [ `uname` == Darwin ]; then
    export HELP2MAN=/usr/bin/true
fi
if [ `uname` == Linux ]; then
    export HELP2MAN=/bin/true
fi

echo host  is: ${HOST}
echo build is: ${BUILD}

if [[ ${HOST} =~ .*linux.* ]]; then
    export CC=${GCC}
    # TODO :: Handle cross-compilation properly here
    export CC_FOR_BUILD=${GCC}
fi


# The issue is that technically we are cross compiling, we have to figure out
# how to tell configure that we have a gnu compatible malloc
# + echo host is: aarch64-conda_cos7-linux-gnu
# host is: aarch64-conda_cos7-linux-gnu
# + echo build is: aarch64-conda_cos6-linux-gnu
# build is: aarch64-conda_cos6-linux-gnu

# checking for GNU libc compatible malloc... no
# configure: WARNING: result no guessed because of cross compilation
# checking for stdlib.h... (cached) yes
# checking for GNU libc compatible realloc... no
# configure: WARNING: result no guessed because of cross compilation

./configure --prefix="$PREFIX"  \
            --host=${HOST}      \
            --build=${BUILD}

make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install
