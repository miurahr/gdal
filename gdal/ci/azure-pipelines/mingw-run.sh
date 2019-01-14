#!/usr/bin/env bash

set -e

SOURCE_DIR=${SOURCE_DIR:-/src}
BUILD_DIR=${BUILD_DIR:-/build}
BUILD_TYPE=${BUILD_TYPE:-Debug}

CC=${CC:-x86_64-w64-mingw32-gcc-posix}
CXX=${CXX:-x86_64-w64-mingw32-g++-posix}

sudo ${SOURCE_DIR}/gdal/ci/azure-pipelines/mingw-install.sh
/opt/wine-devel/bin/wine64 cmd /c dir
ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libstdc++-6.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libgcc_s_sjlj-1.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libssp-0.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libproj-9.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libgeos-3-5-0.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libgeos_c-1.dll  $HOME/.wine/drive_c/windows
cd ${BUILD_DIR}
cmake -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_C_COMPILER=${CC} -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=${SOURCE_DIR}/cmake/platforms/mingw-w64-linux.toolchain.cmake -C${SOURCE_DIR}/cmake/configurations/mingw.cmake -DGDAL_USE_LIBTIFF_INTERNAL=ON -DSWIG_PYTHON=OFF ${SOURCE_DIR}
cmake --build . --target quicktest