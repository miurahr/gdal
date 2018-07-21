#!/bin/sh

set -e

echo "------------------------------------------------------------"
echo " * generate MINGW-w64 build tree"
echo "------------------------------------------------------------"

# configure for cross compile with mingw-w64
mkdir cmake-build-mingw-w64-debug
cd cmake-build-mingw-w64-debug
unset CXX
unset CC
cmake \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_TOOLCHAIN_FILE=../cmake/platforms/mingw-w64-linux.toolchain.cmake \
  -C ../cmake/configurations/mingw.cmake \
  -DGDAL_USE_LIBTIFF_INTERNAL=ON \
  -DSWIG_PYTHON=OFF \
  ../
cd ..
