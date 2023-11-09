set -e

# UPDATE: YKLUA path
YKLUA="/home/pd/yklua-fork-cvice"
# UPDATE: YK path
YK="/home/pd/yk"

export YK_BUILD_TYPE=debug
export PATH="${YK}/bin/:${PATH}"

cp -r "${YKLUA}/src" ./
cd ./src

make onelua

# UPDATE: the oracle
./onelua -e "print('hello world')" | grep "hello world"
