#!/bin/sh

set -e

scripts_root=${TRAVIS_BUILD_DIR}/gdal/ci/travis/cmake

${scripts_root}/generate_gcc.sh
${scripts_root}/build_gcc.sh
err=$?
if [ $err -eq 0 ]
then
  echo "success to build with gcc"
else
  echo "fail to build with gcc"
  cat ${TRAVIS_BUILD_DIR}/cmake-build-trusty-gcc-debug/autotest/Testing/Temporary/LastTest.log
  exit 4
fi