#!/bin/bash

# abort install if any errors occur and enable tracing
set -o errexit
set -o xtrace

ANDROID_NDK=$HOME/android-ndk
ANDROID_PLATFORM=android-16
ANDROID_TOOLCHAIN=clang  #or gcc
# requires cmake>=3.6
CMAKE=/opt/cmake/bin/cmake

mkdir cmake-build-android-debug
cd cmake-build-android-debug
${CMAKE} -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
  -DANDROID_TOOLCHAIN=${ANDROID_TOOLCHAIN} \
  -DANDROID_PLATFORM=${ANDROID_PLATFORM} \
  -C /vagrant/cmake/configurations/android.cmake \
  /vagrant

echo "To build for Android, run 'ninja' in ./cmake-build-android-debug directory."
