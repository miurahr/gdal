#!/bin/sh

set -e

cd cmake-build-trusty-clang-debug
echo "------------------------------------------"
echo "build with clang"
echo "------------------------------------------"
cmake --build . --target documents 2>&1 > docs_log.txt
if cat docs_log.txt | grep -i warning | grep -v russian | grep -v brazilian | grep -v setlocale | grep -v 'has become obsolete' | grep -v 'To avoid this warning'; then echo 'Doxygen warnings found' && cat docs_log.txt && /bin/false; else echo 'No Doxygen warnings found'; fi
cmake --build . --target manpages  2>&1 > man_log.txt
if cat man_log.txt | grep -i warning | grep -v setlocale | grep -v 'has become obsolete' | grep -v 'To avoid this warning'; then echo 'Doxygen warnings found' && cat docs_log.txt && /bin/false; else echo 'No Doxygen warnings found'; fi

cmake --build . -- USER_DEFS=-Werror -j3
