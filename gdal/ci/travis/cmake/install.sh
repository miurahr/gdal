#!/bin/sh

set -e

scripts_root=${TRAVIS_BUILD_DIR}/gdal/ci/travis/cmake

pyenv global system
python --version
python3 --version

${scripts_root}/generate_clang.sh
${scripts_root}/build_clang.sh
