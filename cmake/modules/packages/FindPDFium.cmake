# Find PDFium
# ~~~~~~~~~
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# If it's found it sets PDFIUM_FOUND to TRUE
# and following variables are set:
#    PDFIUM_INCLUDE_DIR
#    PDFIUM_LIBRARY
#    PDFIUM_VERSION
#
# FIND_PATH and FIND_LIBRARY normally search standard locations
# before the specified paths. To search non-standard paths first,
# FIND_* is invoked first with specified paths and NO_DEFAULT_PATH
# and then again with no specified paths to search the default
# locations. When an earlier FIND_* succeeds, subsequent FIND_*s
# searching for the same item do nothing.

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_PDFIUM QUIET pdfium)
endif()

set(PDFIUM_INCLUDE_PATHS
        "$ENV{LIB_DIR}/"
        "$ENV{LIB_DIR}/include/"
        /usr/include/pdfium
        /usr/local/include/pdfium
        #mingw
        c:/msys/local/include/pdfium
)

set(PDFIUM_LIBRARIES_PATHS
      "$ENV{LIB_DIR}/lib"
      /usr/lib
      /usr/local/lib
      #mingw
      c:/msys/local/lib
)

find_path(PDFIUM_INCLUDE_DIR
        NAMES POFDoc.h
        PATHS ${PDFIUM_INCLUDE_PATHS}
        HINTS ${PC_PDFIUM_INCLUDE_DIRS}
)

find_library(PDFIUM_LIBRARY
        NAMES pdfium libpdfium
        PATHS ${PDFIUM_LIBRARIES_PATHS}
        HINTS ${PC_PDFIUM_LIBRARY_DIRS}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PDFIUM DEFAULT_MSG PDFIUM_LIBRARY PDFIUM_INCLUDE_DIR)

