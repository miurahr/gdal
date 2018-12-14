# Find PODOFO
# ~~~~~~~~~
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# If it's found it sets PODOFO_FOUND to TRUE
# and following variables are set:
#    PODOFO_INCLUDE_DIR
#    PODOFO_LIBRARY
#    PODOFO_VERSION
#
# FIND_PATH and FIND_LIBRARY normally search standard locations
# before the specified paths. To search non-standard paths first,
# FIND_* is invoked first with specified paths and NO_DEFAULT_PATH
# and then again with no specified paths to search the default
# locations. When an earlier FIND_* succeeds, subsequent FIND_*s
# searching for the same item do nothing.

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_PODOFO QUIET podofo)
endif()

set(PODOFO_INCLUDE_PATHS
        "$ENV{LIB_DIR}/"
        "$ENV{LIB_DIR}/include/"
        /usr/include/podofo
        /usr/local/include/podofo
        #mingw
        c:/msys/local/include/podofo
)

set(PODOFO_LIBRARIES_PATHS
      "$ENV{LIB_DIR}/lib"
      /usr/lib
      /usr/local/lib
      #mingw
      c:/msys/local/lib
)

find_path(PODOFO_INCLUDE_DIR
        NAMES POFDoc.h
        PATHS ${PODOFO_INCLUDE_PATHS}
        HINTS ${PC_PODOFO_INCLUDE_DIRS}
)

find_library(PODOFO_LIBRARY
        NAMES podofo libpodofo
        PATHS ${PODOFO_LIBRARIES_PATHS}
        HINTS ${PC_PODOFO_LIBRARY_DIRS}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PODOFO DEFAULT_MSG PODOFO_LIBRARY PODOFO_INCLUDE_DIR)

include(FeatureSummary)
set_package_properties(PODOFO PROPERTIES
                       DESCRIPTION "a free, portable C++ library which includes classes to parse PDF files and modify their contents into memory."
                       URL "http://podofo.sourceforge.net/"
)