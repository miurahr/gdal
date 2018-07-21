#!/bin/sh
set -e

echo "------------------------------------------------------------"
echo " * generate android build tree"
echo "------------------------------------------------------------"

ANDROID_NDK=${TRAVIS_BUILD_DIR}/android-ndk-r17b
ANDROID_TOOLCHAIN=clang

mkdir cmake-build-android-debug
cd cmake-build-android-debug
/usr/local/bin/cmake \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
  -DANDROID_TOOLCHAIN=${ANDROID_TOOLCHAIN} \
  -C ../cmake/configurations/android.cmake \
  -DSWIG_PYTHON=OFF \
  ../
cd ..
