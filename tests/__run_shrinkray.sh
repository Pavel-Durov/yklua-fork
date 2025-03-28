#! /bin/bash
cd ../

export PATH=~/yk/bin:${PATH}
# build yklua
make clean && YK_BUILD_TYPE=debug YKB_TRACER=swt make -j "$(nproc)"

cd ./tests

# run shrinkray
/opt/shrinkray/bin/shrinkray  --timeout 10 --parallelism 50 --no-clang-delta ./__interest.sh ./cstack.minimal.lua
