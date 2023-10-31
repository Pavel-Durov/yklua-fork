#!/bin/bash

set -e

cp -r ../src ./src

cp onelua.Makefile ./src/onelua.Makefile
cp one.Makefile ./src/one.Makefile
cp ./one.c ./src/one.c

cd ./src
# clean
make clean
# build 
make -f one.Makefile 2>&1 && make -f onelua.Makefile

# ./src/onelua -e "print('hello from onelua')" | grep hello
cp ./reduce.sh ./src/reduce.sh