#!/bin/sh

set -e

cd cmake-build-trusty-clang-full-debug
echo "------------------------------------------"
echo "Install a gdal library"
echo "------------------------------------------"
sudo rm -f /usr/lib/x86_64-linux-gnu/libgdal.so*
sudo cmake --build . --target install
sudo ldconfig
