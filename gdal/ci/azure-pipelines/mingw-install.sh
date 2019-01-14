#!/usr/bin/env bash

wget -nc https://dl.winehq.org/wine-builds/winehq.key
apt-key add winehq.key
if [ $(lsb_release -sc) = "trusty" ]; then
    apt-add-repository -y 'deb http://dl.winehq.org/wine-builds/ubuntu/ trusty main'
elif [ $(lsb_release -sc) = "xenial" ]; then
    apt-add-repository -y 'deb http://dl.winehq.org/wine-builds/ubuntu/ xenial main'
elif [ $(lsb_release -sc) = 'bionic' ]; then
    apt-add-repository -y 'deb http://dl.winehq.org/wine-builds/ubuntu/ bionic main'
fi
dpkg --add-architecture i386
apt-get update -qq --allow-unauthenticated
apt-get install -y -q --allow-unauthenticated --install-recommends winehq-devel mingw-w64 mingw-w64-i686-dev mingw-w64-x86-64-dev
apt-get install -y -q --allow-unauthenticated libgeos-mingw-w64-dev libproj-mingw-w64-dev

if [ $(lsb_release -sc) = "xenial" ]; then
    update-alternatives --set x86_64-w64-mingw32-g++  /usr/bin/x86_64-w64-mingw32-g++-posix
    update-alternatives --set x86_64-w64-mingw32-gcc  /usr/bin/x86_64-w64-mingw32-gcc-posix
fi
/opt/wine-devel/bin/wine64 cmd /c dir
if [ $(lsb_release -sc) = "trusty" ]; then
  ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libstdc++-6.dll  $HOME/.wine/drive_c/windows
  ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libgcc_s_sjlj-1.dll  $HOME/.wine/drive_c/windows
  ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libssp-0.dll  $HOME/.wine/drive_c/windows
elif [ $(lsb_release -sc) = "xenial" ]; then
  ln -sf /usr/lib/gcc/x86_64-w64-mingw32/5.3-posix/libstdc++-6.dll  $HOME/.wine/drive_c/windows
  ln -sf /usr/lib/gcc/x86_64-w64-mingw32/5.3-posix/libgcc_s_seh-1.dll  $HOME/.wine/drive_c/windows
  ln -sf /usr/lib/gcc/x86_64-w64-mingw32/5.3-posix/libssp-0.dll  $HOME/.wine/drive_c/windows
fi
ln -sf /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libproj-9.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libgeos-3-5-0.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libgeos_c-1.dll  $HOME/.wine/drive_c/windows
# Python bindings
wget https://www.python.org/ftp/python/2.7.15/python-2.7.15.amd64.msi
wine64 msiexec /i python-2.7.15.amd64.msi
gendef $HOME/.wine/drive_c/windows/system32/python27.dll
x86_64-w64-mingw32-dlltool --dllname $HOME/.wine/drive_c/windows/system32/python27.dll --input-def python27.def --output-lib $HOME/.wine/drive_c/Python27/libs/libpython27.a
