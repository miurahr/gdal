#!/bin/bash

scripts_root=${TRAVIS_BUILD_DIR}/gdal/ci/travis/cmake

${scripts_root}/quicktest_clang.sh
err=$?
if [ $err -eq 0 ]
then
  echo "quicktest clang build (no plugin) success."
else
  echo "quicktest clang build (no plugin) fails."
  exit 1
fi

${scripts_root}/quicktest_clang_full.sh
err=$?
if [ $err -eq 0 ]
then
  echo "quicktest on clang build (plugin) success."
else
  echo "quicktest on clang build (plugin) fails."
  exit 3
fi

${scripts_root}/install_clang.sh
err=$?
if [ $err -eq 0 ]
then
  echo "install artifacts on clang build success."
else
  echo "install artifacts on clang build fails."
  exit 5
fi

# run test on clang plugin installation
${scripts_root}/run_autotest_clang.sh
err=$?
if [ $err -eq 0 ]
then
  echo "autotest success"
else
  echo "autotest failed"
  cat ${TRAVIS_BUILD_DIR}/cmake-build-trusty-clang-full-debug/autotest/Testing/Temporary/LastTest.log
  exit 6
fi

exit 0
