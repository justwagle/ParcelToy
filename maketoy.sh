#!/bin/bash

#basic script for building pingpong as a seperate application on cori

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
BUILD_PATH=$SCRIPTPATH/toyexe

if [ "$1" = "clean" ]; then
    rm -rf $BUILD_PATH
    exit 0
fi


if [ ! -d "$BUILD_PATH" ]; then
  mkdir -p "$BUILD_PATH"

  cd "$BUILD_PATH"

  cmake -DCMAKE_BUILD_TYPE=Release                                  \
	-DCMAKE_TOOLCHAIN_FILE=${hpxtoolchain} \
        -DHPX_WITH_MALLOC="tcmalloc"                                       \
        -DHPX_DIR:PATH=${basedir}/haswell-build/hpx-tcmalloc-Release/lib/cmake/HPX       \
        -Wdev                                                              \
         $SCRIPTPATH/src/toy
fi

cd "$BUILD_PATH"

make $1 -j 3

