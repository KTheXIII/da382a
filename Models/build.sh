#!/usr/bin/env sh

set -e

out_name=$1
out_name="${out_name%.*}"

cpp_version=-std=c++20
warnings="-Wall -Wextra -Wpedantic -Werror -Wno-missing-field-initializers"
input_file=$1
target_dir=bin
include_dir="-I. -I${STB_PATH}"
compile_flags="${cpp_version} ${warnings} ${include_dir}"

mkdir -p $target_dir

c++ $compile_flags $input_file -o $target_dir/$out_name

