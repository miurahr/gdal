#!/usr/bin/env bash

if [ $(lsb_release -si) = "Ubuntu" ]; then
    wget -nc https://dl.winehq.org/wine-builds/winehq.key
    apt-key add winehq.key
    apt-add-repository -y 'deb http://dl.winehq.org/wine-builds/ubuntu/ xenial main'
    dpkg --add-architecture i386
    apt-get update -qq --allow-unauthenticated
    apt-get install -y -q --allow-unauthenticated --install-recommends winehq-devel mingw-w64 mingw-w64-i686-dev mingw-w64-x86-64-dev
    apt-get install -y -q --allow-unauthenticated libgeos-mingw-w64-dev libproj-mingw-w64-dev
    update-alternatives --set x86_64-w64-mingw32-g++  /usr/bin/x86_64-w64-mingw32-g++-posix
    update-alternatives --set x86_64-w64-mingw32-gcc  /usr/bin/x86_64-w64-mingw32-gcc-posix
    /opt/wine-devel/bin/wine64 cmd /c dir
    ln -sf /usr/lib/gcc/x86_64-w64-mingw32/5.3-posix/libstdc++-6.dll  $HOME/.wine/drive_c/windows
    ln -sf /usr/lib/gcc/x86_64-w64-mingw32/5.3-posix/libgcc_s_seh-1.dll  $HOME/.wine/drive_c/windows
    ln -sf /usr/lib/gcc/x86_64-w64-mingw32/5.3-posix/libssp-0.dll  $HOME/.wine/drive_c/windows
    ln -sf /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll  $HOME/.wine/drive_c/windows
    ln -sf /usr/x86_64-w64-mingw32/lib/libproj-13.dll  $HOME/.wine/drive_c/windows
    ln -sf /usr/x86_64-w64-mingw32/lib/libgeos-3-5-0.dll  $HOME/.wine/drive_c/windows
    ln -sf /usr/x86_64-w64-mingw32/lib/libgeos_c-1.dll  $HOME/.wine/drive_c/windows
elif [ $(lsb_release -si) = "Arch" ]; then
    pacman -S --noconfirm wine mingw-w64-gcc mingw-w64-cmake \
        mingw-w64-proj mingw-w64-geos mingw-w64-curl mingw-w64-giflib mingw-w64-hdf5 mingw-w64-jasper \
        mingw-w64-libfreexl mingw-w64-libgeotiff mingw-w64-libjpeg mingw-w64-libpng mingw-w64-libtiff \
        mingw-w64-netcdf mingw-w64-postgresql mingw-w64-sqlite mingw-w64-configure mingw-w64-poppler
    wine cmd /c dir
    ln -sf /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll  $HOME/.wine/drive_c/windows
    ln -sf /usr/x86_64-w64-mingw32/lib/libproj-13.dll  $HOME/.wine/drive_c/windows
    ln -sf /usr/x86_64-w64-mingw32/lib/libgeos-3-7-0.dll  $HOME/.wine/drive_c/windows
    ln -sf /usr/x86_64-w64-mingw32/lib/libgeos_c-1.dll  $HOME/.wine/drive_c/windows
fi

# Python bindings
wget https://www.python.org/ftp/python/2.7.15/python-2.7.15.amd64.msi
wine64 msiexec /i python-2.7.15.amd64.msi
gendef $HOME/.wine/drive_c/windows/system32/python27.dll
x86_64-w64-mingw32-dlltool --dllname $HOME/.wine/drive_c/windows/system32/python27.dll --input-def python27.def --output-lib $HOME/.wine/drive_c/Python27/libs/libpython27.a
