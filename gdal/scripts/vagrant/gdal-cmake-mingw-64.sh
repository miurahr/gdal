#!/bin/bash

# cross compile with mingw-w64
mkdir cmake-build-mingw-w64-debug
cd cmake-build-mingw-w64-debug
cmake \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_TOOLCHAIN_FILE=/vagrant/cmake/platforms/mingw-w64-linux.toolchain.cmake \
  -C /vagrant/cmake/configurations/mingw.cmake \
  -DSWIG_PYTHON=ON \
  /vagrant

wine64 cmd /c dir
cd ..
ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libstdc++-6.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libgcc_s_sjlj-1.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libssp-0.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libproj-9.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libgeos-3-5-0.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libgeos_c-1.dll  $HOME/.wine/drive_c/windows
echo "To build with mingw  run 'ninja' in ./cmake-build-mingw-w64-debug directory."
