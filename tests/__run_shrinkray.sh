#! /bin/bash
cd ../

export PATH=~/yk/bin:${PATH}
make clean && YK_BUILD_TYPE=debug YKB_TRACER=swt make -j "$(nproc)"

cd ./tests

/opt/shrinkray/bin/shrinkray  --timeout 10 --parallelism 50 --no-clang-delta ./__interest.sh ./cstack.lua
