#!/bin/sh

set -e

cd cmake-build-trusty-clang-debug
cmake --build . --target autotest
