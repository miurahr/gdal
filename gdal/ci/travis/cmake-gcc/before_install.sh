#!/bin/sh

set -e

scripts_root=$TRAVIS_BUILD_DIR/gdal/ci/travis/cmake

${scripts_root}/install_packages.sh
${scripts_root}/install_dev_packages.sh
${scripts_root}/prepare_dependencies.sh
