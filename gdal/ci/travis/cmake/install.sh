#!/bin/sh

set -e

scripts_root=${TRAVIS_BUILD_DIR}/gdal/ci/travis/cmake

pyenv global system
python --version
python3 --version

${scripts_root}/generate_clang.sh
${scripts_root}/build_clang.sh
err=$?
if [ $err -eq 0 ]
then
  echo "build with clang success."
else
  echo "build with clang failed."
  cat ${TRAVIS_BUILD_DIR}/cmake-build-trusty-clang-debug/autotest/Testing/Temporary/LastTest.log
  exit 2
fi

${scripts_root}/build_clang_full.sh
err=$?
if [ $err -eq 0 ]
then
  echo "success to bulid many drivers"
else
  echo "fail to bulid many drivers"
  cat ${TRAVIS_BUILD_DIR}/cmake-build-trusty-clang-full-debug/autotest/Testing/Temporary/LastTest.log
  exit 3
fi
