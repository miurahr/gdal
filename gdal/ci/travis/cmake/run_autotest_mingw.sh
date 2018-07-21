#!/usr/bin/env bash

set -e

cd cmake-build-mingw-w64-debug

# Does not work under wine
rm autotest/gcore/gdal_api_proxy.py
rm autotest/gcore/rfc30.py

# For some reason this crashes in the matrix .travis.yml but not in standalone branch
rm autotest/pyscripts/test_gdal2tiles.py

echo "------------------------------------------"
echo "autotest on mingw build"
echo "------------------------------------------"
cmake --build . --target autotest