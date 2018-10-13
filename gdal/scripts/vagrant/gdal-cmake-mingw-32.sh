#!/bin/bash

# cross compile with mingw-w64
mkdir cmake-build-mingw32-debug
cd cmake-build-mingw32-debug
cmake \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_TOOLCHAIN_FILE=/vagrant/cmake/platforms/mingw32-linux.toolchain.cmake \
  -C /vagrant/cmake/configurations/mingw.cmake \
  -DSWIG_PYTHON=OFF \
  /vagrant

wine cmd /c dir
cd ..
ln -sf /usr/lib/gcc/i686-w64-mingw32/4.8/libstdc++-6.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/lib/gcc/i686-w64-mingw32/4.8/libgcc_s_sjlj-1.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/lib/gcc/i686-w64-mingw32/4.8/libssp-0.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/i686-w64-mingw32/lib/libwinpthread-1.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/i686-w64-mingw32/lib/libproj-9.dll  $HOME/.wine/drive_c/windows
echo "To build with mingw  run 'ninja' in ./cmake-build-mingw32-debug directory."
