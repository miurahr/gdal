#!/bin/sh

set -e

cd cmake-build-mingw-w64-debug

echo "------------------------------------------"
echo "build with mingw(64bit)"
echo "------------------------------------------"
wine cmd /c dir
CXX=x86_64-w64-mingw32-g++
CC=x86_64-w64-mingw32-gcc
ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libstdc++-6.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libgcc_s_sjlj-1.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll $HOME/.wine/drive_c/windows

cmake --build . --target gdal
ln -sf $PWD/gdal/libgdal.dll $HOME/.wine/drive_c/windows
cmake --build .
wine gdal/apps/gdalinfo.exe  --version
