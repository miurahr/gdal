#!/usr/bin/env bash

set -e

cd cmake-build-trusty-clang-full-debug
echo "------------------------------------------"
echo "quicktest on clang build with full drivers and enabling plugin"
echo "------------------------------------------"
cmake --build . --target quicktest
