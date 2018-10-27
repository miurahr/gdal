#!/bin/sh

cd cmake-build-osx-debug

env GDAL_SKIP=JP2ECW cmake --build . --target quicktest
err=$?
if [ $err -eq 0 ]
then
echo "quick test success"
else
echo "quick test fails"
cat autotest/Testing/Temporary/LastTest.log
exit 1
fi

cmake --build . --target gdalapps
echo "Show which shared libs got used:"
otool -L gdal/apps/ogrinfo

sudo cmake --build . --target install
export PATH=$HOME/install-gdal/bin:$PATH
cmake --build . --target autotest
err=$?
if [ $err -eq 0 ]
then
echo "test success"
else
echo "test fails"
cat autotest/Testing/Temporary/LastTest.log
exit 2
fi

