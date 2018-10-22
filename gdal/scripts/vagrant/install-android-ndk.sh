#!/bin/sh

set -o errexit

NDK=android-ndk-r18b
#NDK=android-ndk-r17b
#NDK=android-ndk-r16b
#NDK=android-ndk-r15c
#NDK=android-ndk-r14b

NDKZIP=${NDK}-linux-x86_64.zip
BASEURL=https://dl.google.com/android/repository

echo "Download Android NDK ${NDKZIP} (> 900MB) that will take several minutes..."
wget -N -P /var/cache/wget ${BASEURL}/${NDKZIP}
echo "..downloaded. Now extract ndk..."
unzip -q -o /var/cache/wget/${NDKZIP}

if [ -d android-ndk ]; then
rm -f android-ndk
fi
ln -s ${NDK} android-ndk
