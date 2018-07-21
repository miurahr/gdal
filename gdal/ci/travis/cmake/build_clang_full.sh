#!/bin/sh

set -e

cd cmake-build-trusty-clang-full-debug
echo "------------------------------------------"
echo "build with clang with full drivers"
echo "------------------------------------------"
cmake --build . --target all
cmake --build . --target fuzzer_check
