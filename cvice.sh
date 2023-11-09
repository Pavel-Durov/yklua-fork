#!/bin/bash

set -e

DIR=".cvice"

if [ -d "${DIR}" ]; then
    rm -fr "${DIR}"
fi

mkdir "${DIR}"

cp -r "./src" "${DIR}/src"
cp ./cvice_reduce.sh "${DIR}/src/cvice_reduce.sh"

cd "${DIR}/src"

echo Building onelua
make onelua

echo Running cvice reduce
cvise ./cvice_reduce.sh onelua.c
