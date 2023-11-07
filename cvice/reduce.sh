#!/bin/bash

# $ cvise ./reduce.sh onelua.c
# TODO: Make sure we dont work on original onelua.c file

set -e


export YK_BUILD_TYPE=debug
export PATH=/home/pd/yk/bin/:${PATH}

cp /home/pd/yklua-fork/cvice/Makefile Makefile
make clean
make
"${PWD}/onelua" -e "print('hello from onelua')" | grep hello
