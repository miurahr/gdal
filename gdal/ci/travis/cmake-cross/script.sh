#!/bin/bash

set -e

scripts_root=${TRAVIS_BUILD_DIR}/gdal/ci/travis/cmake

${scripts_root}/quicktest_mingw.sh
