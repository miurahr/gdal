#!/bin/bash

mkdir cmake-build-clang-debug
cd cmake-build-clang-debug
## when debugging command lines for compilation, add
##  -DCMAKE_RULE_MESSAGES=OFF -DCMAKE_VERBOSE_MAKEFILE=ON
##
##  build with Clang
##
cmake \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_CXX_COMPILER=clang++-3.9 \
  -DCMAKE_C_COMPILER=clang-3.9 \
  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
  -DCMAKE_C_COMPILER_LAUNCHER=ccache \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DSWIG_PYTHON=ON \
  -DPYTHON_VERSION=2.7 \
  -DSWIG_PERL=ON \
  -DSWIG_JAVA=ON \
  -DSWIG_CSHARP=ON \
  -C /vagrant/cmake/configurations/full_drivers.cmake \
  /vagrant

cd ..
echo "To build, run 'make -j' in ./cmake-build-clang-debug directory"
