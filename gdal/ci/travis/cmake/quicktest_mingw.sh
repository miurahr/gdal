#!/usr/bin/env bash

set -e

cd cmake-build-mingw-w64-debug

echo "------------------------------------------"
echo "quicktest on mingw build"
echo "------------------------------------------"
cmake --build . --target quicktest