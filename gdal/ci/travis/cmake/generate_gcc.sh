#!/bin/sh

set -e

echo "------------------------------------------------------------"
echo " * generate gcc build tree (enable plugin)"
echo "------------------------------------------------------------"

# configure with gcc
mkdir cmake-build-trusty-gcc-debug
cd cmake-build-trusty-gcc-debug
CC=gcc
CXX=g++
cmake \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_CXX_COMPILER=g++ \
  -DCMAKE_C_COMPILER=gcc \
  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
  -DCMAKE_C_COMPILER_LAUNCHER=ccache \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DGDAL_ENABLE_PLUGIN=ON \
  -DPYTHON_VERSION=2.7 \
  ../
