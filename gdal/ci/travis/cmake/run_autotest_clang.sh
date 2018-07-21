#!/bin/sh

set -e

cd cmake-build-trusty-clang-full-debug
cmake --build . --target autotest
