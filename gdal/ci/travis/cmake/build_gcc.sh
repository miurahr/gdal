#!/bin/sh

set -e

cd cmake-build-trusty-gcc-debug
CXX=g++
CC=gcc

echo "------------------------------------------"
echo "build with gcc"
echo "------------------------------------------"
cmake --build . --target all
