#!/usr/bin/env sh

in=$1

BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
RESET="\033[0m"

if [ -z "${1}" ]
then
    printf "${RED}error${RESET}: no file input\n"
    exit 1
fi

./build.sh $in

out="${in%.*}"
./bin/$out "${@:2}"

