#!/bin/bash

# abort install if any errors occur and enable tracing
set -o errexit
set -o xtrace

NUMTHREADS=2
if [[ -f /sys/devices/system/cpu/online ]]; then
	# Calculates 1.5 times physical threads
	NUMTHREADS=$(( ( $(cut -f 2 -d '-' /sys/devices/system/cpu/online) + 1 ) * 15 / 10  ))
fi
#NUMTHREADS=1 # disable MP
export NUMTHREADS

mkdir cmake-build-gcc4.8-debug
cd cmake-build-gcc4.8-debug
cmake \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
  -DCMAKE_C_COMPILER_LAUNCHER=ccache \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DSWIG_PYTHON=ON \
  -DSWIG_PERL=ON \
  -DSWIG_PHP=ON \
  -DSWIG_JAVA=ON \
  -DSWIG_CSHARP=ON \
  -C /vagrant/cmake/configurations/full_drivers.cmake \
  /vagrant

cmake --build . --target documents 2>&1 > docs_log.txt
if cat docs_log.txt | grep -i warning | grep -v russian | grep -v brazilian | grep -v setlocale | grep -v 'has become obsolete' | grep -v 'To avoid this warning'; then echo 'Doxygen warnings found' && cat docs_log.txt && /bin/false; else echo 'No Doxygen warnings found'; fi
cmake --build . --target manpages  2>&1 > man_log.txt
if cat man_log.txt | grep -i warning | grep -v setlocale | grep -v 'has become obsolete' | grep -v 'To avoid this warning'; then echo 'Doxygen warnings found' && cat docs_log.txt && /bin/false; else echo 'No Doxygen warnings found'; fi

# build default target
cmake --build . --target all -- -j $NUMTHREADS
cmake --build . --target quicktest -- -j $NUMTHREADS

# A previous version of GDAL has been installed by PostGIS
sudo rm -f /usr/lib/libgdal.so*
sudo rm -f /usr/lib/x86_64-linux-gnu/libgdal.so*
sudo rm -fr /usr/include/gdal/
sudo rm -fr /usr/share/gdal/
sudo rm -rf /usr/lib/gdalplugins/
sudo cmake --build . --target install
sudo ldconfig
