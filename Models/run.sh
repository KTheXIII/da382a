#!/usr/bin/env sh

target=$1

if [ -z "${1}" ]
then
    echo "No file to run"
    exit 1
fi

./build.sh $target

target="${target%.*}"
args="${@:2}"

./bin/$target $args

