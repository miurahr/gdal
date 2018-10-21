#!/bin/bash

set -e

scripts_root=${TRAVIS_BUILD_DIR}/gdal/ci/travis/cmake

${scripts_root}/quicktest_clang.sh
${scripts_root}/install_clang.sh
${scripts_root}/run_autotest_clang.sh

exit 0
