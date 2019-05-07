# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# Find TileDB - TileDB library
# ~~~~~~~~~
#
# Copyright (c) 2019 Hiroshi Miura <miurahr@linux.com>
#
# ::
#
# If it's found it sets TILEDB_FOUND to TRUE
# and following variables are set:
#    TILEDB_INCLUDE_DIR
#    TILEDB_LIBRARY
#

if(CMAKE_VERSION VERSION_LESS 3.13)
    set(TILEDB_ROOT CACHE PATH "")
endif()

find_path(TILEDB_INCLUDE_DIR NAMES tiledb.h SUFFIX_PATHS tiledb)
if(TILEDB_INCLUDE_DIR)
    find_library(TILEDB_LIBRARY NAMES tiledb)
endif()
mark_as_advanced(TILEDB_INCLUDE_DIR TILEDB_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TileDB DEFAULT_MSG TILEDB_LIBRARY  TILEDB_INCLUDE_DIR)

if(TILEDB_FOUND)
    set(TILEDB_INCLUDE_DIRS ${TILEDB_INCLUDE_DIR})
    set(TILEDB_LIBRARIES ${TILEDB_LIBRARY})
    if(NOT TARGET TILEDB::TileDB)
        add_library(TILEDB::TileDB UNKNOWN IMPORTED)
        set_target_properties(TILEDB::TileDB PROPERTIES
                              INTERFACE_INCLUDE_DIRECTORIES "${TILEDB_INCLUDE_DIR}"
                              IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                              IMPORTED_LOCATION "${TILEDB_LIBRARY}")
    endif()
endif()
