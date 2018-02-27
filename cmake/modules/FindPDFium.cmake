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

# try to use framework on mac
# want clean framework path, not unix compatibility path
IF (PDFIUM_INCLUDE_DIR AND PDFIUM_LIBRARIES)
  # Already in cache, be silent
  SET(PDFIUM_FIND_QUIETLY TRUE)
ENDIF()

if(APPLE)
    if(CMAKE_FIND_FRAMEWORK MATCHES "FIRST"
            OR CMAKE_FRAMEWORK_PATH MATCHES "ONLY"
            OR NOT CMAKE_FIND_FRAMEWORK)
        set(CMAKE_FIND_FRAMEWORK_save ${CMAKE_FIND_FRAMEWORK} CACHE STRING "" FORCE)
        set(CMAKE_FIND_FRAMEWORK "ONLY" CACHE STRING "" FORCE)
        find_library(PDFIUM_LIBRARY PDFIUM)
        if(PDFIUM_LIBRARY)
            # FIND_PATH doesn't add "Headers" for a framework
            SET (PDFIUM_INCLUDE_DIR ${PDFIUM_LIBRARY}/Headers CACHE PATH "Path to a file.")
        endif(PDFIUM_LIBRARY)
        set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    endif()
endif(APPLE)

FIND_PACKAGE(PkgConfig QUIET)
IF(PKG_CONFIG_FOUND)
    # try using pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    PKG_CHECK_MODULES(PC_PDFIUM QUIET pdfium)
ENDIF()

SET(PDFIUM_INCLUDE_PATHS
        "$ENV{LIB_DIR}/"
        "$ENV{LIB_DIR}/include/"
        /usr/include/pdfium
        /usr/local/include/pdfium
        #mingw
        c:/msys/local/include/pdfium
)

SET(PDFIUM_LIBRARIES_PATHS
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

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(PDFIUM DEFAULT_MSG PDFIUM_LIBRARY PDFIUM_INCLUDE_DIR)

