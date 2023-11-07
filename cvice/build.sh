#!/bin/bash

set -e

cp -r ../src ./src

# cp onelua.Makefile ./src/onelua.Makefile
# cp one.Makefile ./src/one.Makefile

cp Makefile ./src/Makefile
cp ./one.c ./src/one.c

cd ./src

make clean

make

cp ../reduce.sh ./reduce.sh