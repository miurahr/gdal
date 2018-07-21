#!/bin/sh

set -e

export PATH=/usr/local/bin:$PATH

# setup GDAL build tree
mkdir cmake-build-osx-debug
cd cmake-build-osx-debug
cmake \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
  -DCMAKE_C_COMPILER_LAUNCHER=ccache \
  -DGDAL_ENABLE_FRMT_GTIFF=ON \
  -DGDAL_USE_LIBTIFF_INTERNAL=ON \
  -DGDAL_USE_LIBGEOTIFF_INTERNAL=ON \
  -DGDAL_USE_LIBPNG_INTERNAL=ON \
  -DCMAKE_INSTALL_PREFIX=$HOME/install-gdal \
  -DGDAL_ENABLE_PLUGIN=OFF \
  -DSWIG_PYTHON=ON \
  -DPYTHON_VERSION=2.7.12 \
  ../
