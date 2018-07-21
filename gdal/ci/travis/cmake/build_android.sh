#!/bin/sh

set -e

cd cmake-build-android-debug

echo "------------------------------------------"
echo "Start build with Android NDK"
echo "------------------------------------------"
/usr/local/bin/cmake --build . -- USER_DEFS=-Werror -j3
