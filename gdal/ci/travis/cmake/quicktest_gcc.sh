#!/usr/bin/env bash

set -e

cd cmake-build-trusty-gcc-debug
CXX=g++
CC=gcc

echo "------------------------------------------"
echo "quicktest on gcc build (enable plugin)"
echo "------------------------------------------"
cmake --build . --target quicktest