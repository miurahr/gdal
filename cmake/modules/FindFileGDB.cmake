# Find FGDB - ESRI File Geodatabaselibrary
# ~~~~~~~~~
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# If it's found it sets FILEGDB_FOUND to TRUE
# and following variables are set:
#    FILEGDB_INCLUDE_DIR
#    FILEGDB_LIBRARY
#    FILEGDB_VERSION
#
# FIND_PATH and FIND_LIBRARY normally search standard locations
# before the specified paths. To search non-standard paths first,
# FIND_* is invoked first with specified paths and NO_DEFAULT_PATH
# and then again with no specified paths to search the default
# locations. When an earlier FIND_* succeeds, subsequent FIND_*s
# searching for the same item do nothing.

# Select a FGDB API to use, or disable driver.

# find file location
find_path(FILEGDB_INCLUDE_DIR
        NAMES FileGDBAPI.h
        HINTS "$ENV{LIB_DIR}/"
            "$ENV{LIB_DIR}/include/"
            "$ENV{FILEGDB_ROOT}/"
            /usr/include/filegdb
            /usr/local/include/filegdb
            /usr/local/filegdb/include
            #mingw
            c:/msys/local/include/filegdb
        DOC "Path to FileGDB header"
        NO_DEFAULT_PATH)

find_library(FILEGDB_LIBRARY
        NAMES libFileGDBAPI libfgdbunixrtl
        PATHS  "$ENV{LIB_DIR}/lib"
              /usr/lib
              /usr/local/lib
              #mingw
              c:/msys/local/lib
        DOC "Path to FileGDB library"
        NO_DEFAULT_PATH)
find_library(FILEGDB_LIBRARY NAMES FileGDBAPI libFileGDBAPI)

if(FILEGDB_INCLUDE_DIR AND FILEGDB_LIBRARY)
    set(FileGDB_FOUND TRUE)
endif()

include(CheckCXXSourceCompiles)
include_directories(FILEGDB_INCLUDE_DIR)
check_cxx_source_compiles("#include <FileGDBAPI.h>\nusing namespace FileGDBAPI;
        int main() { Geodatabase oDB; std::wstring osStr; ::OpenGeodatabase(osStr, oDB); return 0; }" TEST_FILEGDB_COMPILE)
if(NOT TEST_FILEGDB_COMPILE)
    set(FileGDB_FOUND FALSE)
endif()

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(FILEGDB DEFAULT_MSG FILEGDB_LIBRARY  FILEGDB_INCLUDE_DIR)


