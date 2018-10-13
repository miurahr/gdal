#!/usr/bin/env bash

wget -N -nv -P /var/cache/wget  https://www.python.org/ftp/python/2.7.3/python-2.7.3.amd64.msi
wine64 msiexec /i /var/cache/wget/python-2.7.3.amd64.msi
cd $HOME/.wine/drive_c/Python27
gendef $HOME/.wine/drive_c/Python27/python27.dll
x86_64-w64-mingw32-dlltool --dllname $HOME/.wine/drive_c/Python27/python27.dll --input-def python27.def --output-lib $HOME/.wine/drive_c/Python27/libs/libpython27.a
