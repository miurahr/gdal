#!/bin/sh

set -e

sudo dpkg --add-architecture i386
sudo apt-get install -y --no-install-recommends -q wine1.4-amd64 mingw-w64 mingw-w64-i686-dev mingw-w64-x86-64-dev mingw-w64-tools
sudo apt-get install -y -q libgeos-mingw-w64-dev libproj-mingw-w64-dev

wine64 cmd /c dir
ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libstdc++-6.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libgcc_s_sjlj-1.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/lib/gcc/x86_64-w64-mingw32/4.8/libssp-0.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libproj-9.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libgeos-3-5-0.dll  $HOME/.wine/drive_c/windows
ln -sf /usr/x86_64-w64-mingw32/lib/libgeos_c-1.dll  $HOME/.wine/drive_c/windows
