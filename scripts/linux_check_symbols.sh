#!/bin/bash

## Copyright 2009-2020 Intel Corporation
## SPDX-License-Identifier: Apache-2.0

source scripts/unix_common.sh "$@"

# Helper function for checking version of symbols
function check_symbols
{
  for sym in `nm $1 | tr ' ' '\n' | grep $2_`
  do
    version=(`echo $sym | sed 's/.*@@\(.*\)$/\1/g' | grep -E -o "[0-9]+"`)
    if [ ${#version[@]} -ne 0 ]; then
      if [ ${#version[@]} -eq 1 ]; then version[1]=0; fi
      if [ ${#version[@]} -eq 2 ]; then version[2]=0; fi
      if [ ${version[0]} -gt $3 ]; then
        echo "Error: problematic $2 symbol " $sym
        exit 1
      fi
      if [ ${version[0]} -lt $3 ]; then continue; fi

      if [ ${version[1]} -gt $4 ]; then
        echo "Error: problematic $2 symbol " $sym
        exit 1
      fi
      if [ ${version[1]} -lt $4 ]; then continue; fi

      if [ ${version[2]} -gt $5 ]; then
        echo "Error: problematic $2 symbol " $sym
        exit 1
      fi
    fi
  done
}

cd $BUILD_DIR

check_symbols libOpenImageDenoise.so GLIBC 2 17 0
check_symbols libOpenImageDenoise.so GLIBCXX 3 4 19
check_symbols libOpenImageDenoise.so CXXABI 1 3 7

cd $ROOT_DIR

