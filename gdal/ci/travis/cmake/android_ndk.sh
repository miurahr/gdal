#!/bin/sh

NDK=android-ndk-r17b
#NDK=android-ndk-r16b
#NDK=android-ndk-r15c
#NDK=android-ndk-r14b

NDKZIP=${NDK}-linux-x86_64.zip
BASEURL=https://dl.google.com/android/repository

echo "Download Android NDK ${NDKZIP}..."
wget ${BASEURL}/${NDKZIP}
echo "..downloaded. Now extract ndk into ${PWD}/${NDK} ..."
unzip -q ${NDKZIP}

CMAKEVER=3.12
CMAKEREV=1
echo "Downloading cmake binary package version ${CMAKEVER}.${CMAKEREV}..."
wget https://cmake.org/files/v${CMAKEVER}/cmake-${CMAKEVER}.${CMAKEREV}-Linux-x86_64.sh
sudo bash ./cmake-${CMAKEVER}.${CMAKEREV}-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir
