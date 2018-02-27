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

# try to use framework on mac
# want clean framework path, not unix compatibility path
IF (PODOFO_INCLUDE_DIR AND PODOFO_LIBRARIES)
  # Already in cache, be silent
  SET(PODOFO_FIND_QUIETLY TRUE)
ENDIF()

if(APPLE)
    if(CMAKE_FIND_FRAMEWORK MATCHES "FIRST"
            OR CMAKE_FRAMEWORK_PATH MATCHES "ONLY"
            OR NOT CMAKE_FIND_FRAMEWORK)
        set(CMAKE_FIND_FRAMEWORK_save ${CMAKE_FIND_FRAMEWORK} CACHE STRING "" FORCE)
        set(CMAKE_FIND_FRAMEWORK "ONLY" CACHE STRING "" FORCE)
        find_library(PODOFO_LIBRARY PODOFO)
        if(PODOFO_LIBRARY)
            # FIND_PATH doesn't add "Headers" for a framework
            SET (PODOFO_INCLUDE_DIR ${PODOFO_LIBRARY}/Headers CACHE PATH "Path to a file.")
        endif(PODOFO_LIBRARY)
        set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    endif()
endif(APPLE)

FIND_PACKAGE(PkgConfig QUIET)
IF(PKG_CONFIG_FOUND)
    # try using pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    PKG_CHECK_MODULES(PC_PODOFO QUIET podofo)
ENDIF()

SET(PODOFO_INCLUDE_PATHS
        "$ENV{LIB_DIR}/"
        "$ENV{LIB_DIR}/include/"
        /usr/include/podofo
        /usr/local/include/podofo
        #mingw
        c:/msys/local/include/podofo
)

SET(PODOFO_LIBRARIES_PATHS
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

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(PODOFO DEFAULT_MSG PODOFO_LIBRARY PODOFO_INCLUDE_DIR)

