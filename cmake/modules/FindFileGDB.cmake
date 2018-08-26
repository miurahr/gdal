# Find FGDB - ESRI File Geodatabaselibrary
# ~~~~~~~~~
#
# Copyright (c) 2017,2018 Hiroshi Miura <miurahr@linux.com>
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

set(FILEGDB_DIR CACHE PATH "")

# find file location
find_path(FILEGDB_INCLUDE_DIR
          NAMES FileGDBAPI.h)
find_path(FILEGDB_INCLUDE_DIR
        NAMES FileGDBAPI.h
        PATHS "$ENV{FILEGDB_DIR}/include"
            /usr/include/filegdb
            /usr/local/include/filegdb
            /usr/local/filegdb/include
            #mingw
            c:/msys/local/include/filegdb
        SUFFIX_PATHS filegdb
        DOC "Path to FileGDB header"
        NO_DEFAULT_PATH)
if(UNIX)
    set(FILEGDB_NAMES FileGDBAPI fgdbunixrtl)
else()
    set(FILEGDB_NAMES FileGDBAPI)
endif()

if(FILEGDB_INCLUDE_DIR)
    find_library(FILEGDB_LIBRARY NAMES ${FILEGDB_NAME})
    find_library(FILEGDB_LIBRARY
            NAMES ${FILEGDB_NAMES}
            PATHS "$ENV{FILEGDB_DIR}/lib"
                  #mingw
                  c:/msys/local/lib
            DOC "Path to FileGDB library"
            NO_DEFAULT_PATH)
    include(CheckCXXSourceCompiles)
    include_directories(FILEGDB_INCLUDE_DIR)
    check_cxx_source_compiles("#include <FileGDBAPI.h>\nusing namespace FileGDBAPI;
            int main() { Geodatabase oDB; std::wstring osStr; ::OpenGeodatabase(osStr, oDB); return 0; }" TEST_FILEGDB_COMPILE)
    if(NOT TEST_FILEGDB_COMPILE)
        set(FILEGDB_FOUND FALSE)
    endif()
endif()
mark_as_advanced(FILEGDB_INCLUDE_DIR FILEGDB_LIBRARY)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(FILEGDB DEFAULT_MSG FILEGDB_LIBRARY  FILEGDB_INCLUDE_DIR)


if(FILEGDB_FOUND)
    set(FILEGDB_INCLUDE_DIRS ${FILEGDB_INCLUDE_DIR})
    set(FILEGDB_LIBRARIES ${FILEGDB_LIBRARY})
    if(NOT TARGET FILEGDB::FileGDB)
        add_library(FILEGDB::FileGDB UNKNOWN IMPORTED)
        set_target_properties(FILEGDB::FileGDB PROPERTIES
                              INTERFACE_INCLUDE_DIRECTORIES "${FILEGDB_INCLUDE_DIR}"
                              IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                              IMPORTED_LOCATION "${FILEGDB_LIBRARY}")
    endif()
endif()