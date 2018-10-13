#!/bin/bash

mkdir cmake-build-grass-debug
cd cmake-build-grass-debug
cmake \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
  -DCMAKE_C_COMPILER_LAUNCHER=ccache \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -C /vagrant/cmake/configurations/grass.cmake \
  /vagrant

cmake --build . --target ogr_GRASS
cmake --build . --target gdal_GRASS
