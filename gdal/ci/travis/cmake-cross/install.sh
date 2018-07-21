#!/bin/sh

set -e

scripts_root=$TRAVIS_BUILD_DIR/gdal/ci/travis/cmake

${scripts_root}/generate_mingw.sh
${scripts_root}/build_mingw.sh
${scripts_root}/generate_android.sh
${scripts_root}/build_android.sh
