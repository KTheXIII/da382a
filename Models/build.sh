#!/usr/bin/env sh

set -e

in=$1
out="${in%.*}"

bin=bin
obj=obj

cpp_version=-std=c++20
warnings="-Wall -Wextra -Wpedantic -Werror -Wno-missing-field-initializers"
includes="-I. -I${STB_PATH}"
#others="-O3"

compile_flags="${cpp_version} ${warnings} ${includes} ${others}"

mkdir -p $bin

c++ $compile_flags $in -o $bin/$out

