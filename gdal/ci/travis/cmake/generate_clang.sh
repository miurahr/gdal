#!/bin/sh

set -e

echo "------------------------------------------------------------"
echo " * generate CLANG build tree (no plugin)"
echo "------------------------------------------------------------"

# configure with clang
mkdir cmake-build-trusty-clang-debug
cd cmake-build-trusty-clang-debug
CC=clang
CXX=clang++
cmake \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
  -DCMAKE_C_COMPILER_LAUNCHER=ccache \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DSWIG_PYTHON=ON \
  -DPYTHON_VERSION=2.7 \
  -C ../cmake/configurations/full_drivers.cmake \
  ../
