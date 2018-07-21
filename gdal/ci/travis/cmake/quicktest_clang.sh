#!/usr/bin/env bash

set -e

cd cmake-build-trusty-clang-debug
echo "------------------------------------------"
echo "Quick test on clang build (no plugin)"
echo "------------------------------------------"
cmake --build . --target quicktest
