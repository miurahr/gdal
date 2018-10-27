#!/bin/sh

set -e

export PATH=/usr/local/bin:$PATH

# build proj
brew list --versions
curl http://download.osgeo.org/proj/proj-5.0.1.tar.gz > proj-5.0.1.tar.gz
tar xvzf proj-5.0.1.tar.gz
cd proj-5.0.1/nad
curl http://download.osgeo.org/proj/proj-datumgrid-1.5.tar.gz > proj-datumgrid-1.5.tar.gz
tar xvzf proj-datumgrid-1.5.tar.gz
cd ..
./configure --prefix=$HOME/install-proj
make -j3 > /dev/null
make install >/dev/null
cd ..

# build GDAL
mkdir cmake-build-osx-debug
cd cmake-build-osx-debug
cmake \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
  -DCMAKE_C_COMPILER_LAUNCHER=ccache \
  -DGDAL_ENABLE_FRMT_GTIFF=ON \
  -DGDAL_ENABLE_FRMT_OZI=ON \
  -DGDAL_ENABLE_FRMT_PCIDSK=ON \
  -DGDAL_ENABLE_FRMT_USGSDEM=ON \
  -DOGR_ENABLE_IDRISI=ON \
  -DOGR_ENABLE_PDS=ON \
  -DOGR_ENABLE_SQLITE=ON \
  -DGDAL_USE_LIBTIFF_INTERNAL=ON \
  -DGDAL_USE_LIBGEOTIFF_INTERNAL=ON \
  -DGDAL_USE_LIBPNG_INTERNAL=ON \
  -DGDAL_USE_LIBPCIDSK_INTERNAL=ON \
  -DPROJ_INCLUDE_DIR=$HOME/install-proj/include \
  -DPROJ_LIBRARY=$HOME/install-proj/lib/libproj.dylib \
  -DCMAKE_INSTALL_PREFIX=$HOME/install-gdal \
  -DSWIG_PYTHON=ON \
  -DPYTHON_VERSION=2.7.12 \
  ../
cmake --build .
