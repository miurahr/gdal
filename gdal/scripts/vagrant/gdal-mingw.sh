#!/bin/bash

# abort install if any errors occur and enable tracing
set -o errexit
set -o xtrace

echo "Configure for mingw-w64"

NUMTHREADS=2
if [[ -f /sys/devices/system/cpu/online ]]; then
	# Calculates 1.5 times physical threads
	NUMTHREADS=$(( ( $(cut -f 2 -d '-' /sys/devices/system/cpu/online) + 1 ) * 15 / 10  ))
fi
#NUMTHREADS=1 # disable MP
export NUMTHREADS

rsync -a /vagrant/gdal/ /home/vagrant/gnumake-build-mingw-w64
rsync -a --exclude='__pycache__' /vagrant/autotest/ /home/vagrant/gnumake-build-mingw-w64/autotest
echo rsync -a /vagrant/gdal/ /home/vagrant/gnumake-build-mingw-w64/ > /home/vagrant/gnumake-build-mingw-w64/resync.sh
echo rsync -a --exclude='__pycache__' /vagrant/autotest/ /home/vagrant/gnumake-build-mingw-w64/autotest >> /home/vagrant/gnumake-build-mingw-w64/resync.sh

chmod +x /home/vagrant/gnumake-build-mingw-w64/resync.sh

export CCACHE_CPP2=yes

wine64 cmd /c dir
ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libstdc++-6.dll  "$HOME/.wine/drive_c/windows"
ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libgcc_s_sjlj-1.dll  "$HOME/.wine/drive_c/windows"
ln -sf /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll  "$HOME/.wine/drive_c/windows"
ln -sf /usr/x86_64-w64-mingw32/bin/libsqlite3-0.dll "$HOME/.wine/drive_c/windows"
ln -sf /usr/x86_64-w64-mingw32/bin/libproj-13.dll "$HOME/.wine/drive_c/windows"
ln -sf /usr/x86_64-w64-mingw32/lib/libgeos_c-1.dll "$HOME/.wine/drive_c/windows"
ln -sf /usr/x86_64-w64-mingw32/lib/libgeos-3-5-0.dll "$HOME/.wine/drive_c/windows"

(cd /home/vagrant/gnumake-build-mingw-w64
    CC="ccache x86_64-w64-mingw32-gcc" CXX="ccache x86_64-w64-mingw32-g++" LD=x86_64-w64-mingw32-ld \
    PKG_CONFIG=/usr/bin/x86_64-w64-mingw32-pkg-config \
    ./configure --prefix=/usr/x86_64-w64-mingw32  --host=x86_64-w64-mingw32 \
     --with-geos=/usr/x86_64-w64-mingw32 --with-sqlite3=/usr/x86_64-w64-mingw32 \
     --with-proj=/usr/x86_64-w64-mingw32 --with-kea=no --with-ogdi=no
    ln -sf "$PWD/.libs/libgdal-20.dll" "$HOME/.wine/drive_c/windows"
)

# for Python binding
sudo wget -N -nv -P /var/cache/wget/ http://www.python.org/ftp/python/2.7.15/python-2.7.15.amd64.msi
wine64 msiexec /i /var/cache/wget/python-2.7.15.amd64.msi
wine64 $HOME/.wine/drive_c/Python27/python27.exe -m ensurepip

echo "------------------------------------------------------"
echo "You now can run cross building with mingw-w64, please run on $PWD"
echo "make -j $NUMTHREADS"
echo "cd swig/python; CXX=x86_64-w64-mingw32-g++ bash fallback_build_mingw32_under_unix.sh"
echo "cp -R build/lib.win-amd64-2.7/osgeo $HOME/.wine/drive_c/Python27/Libs/site-packages/"
echo "And then you can run autotest on $PWD/autotest"
echo "wine64 $HOME/.wine/drive_c/Python27/python27.exe -m pip install -r autotest/requirements.txt"
echo "wine64 $HOME/.wine/drive-c/python27/python27.exe -m pytest"
echo "------------------------------------------------------"
