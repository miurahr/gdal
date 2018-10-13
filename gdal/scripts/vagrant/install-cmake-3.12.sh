#!/bin/bash

# abort install if any errors occur and enable tracing
set -o errexit
CMAKEVER=3.12
CMAKEREV=1

echo "Downloading cmake binary package version ${CMAKEVER}.${CMAKEREV}..."
wget -nc -c -P /var/cache/wget https://cmake.org/files/v${CMAKEVER}/cmake-${CMAKEVER}.${CMAKEREV}-Linux-x86_64.tar.gz
cat /var/cache/wget/cmake-${CMAKEVER}.${CMAKEREV}-Linux-x86_64.tar.gz | (cd /opt; sudo tar xzf -)
if [ -e /opt/cmake ]; then
    sudo rm -f /opt/cmake
fi
sudo ln -s /opt/cmake-${CMAKEVER}.${CMAKEREV}-Linux-x86_64/ /opt/cmake
