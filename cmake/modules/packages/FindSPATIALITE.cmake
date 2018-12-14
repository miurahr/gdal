# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file COPYING-CMAKE-SCRIPTS or https://cmake.org/licensing for details.

#.rst
# Find SpatiaLite
# ~~~~~~~~~
#
# CMake module to search for SpatiaLite library
#
# Copyright (c) 2009, Sandro Furieri <a.furieri at lqt.it>
# Copyright (C) 2017,2018, Hiroshi Miura
#
# If it's found it sets SPATIALITE_FOUND to TRUE
# and following variables are set:
#    SPATIALITE_INCLUDE_DIR
#    SPATIALITE_LIBRARY
#    SPATIALITE_VERSION_STRING

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_SPATIALITE QUIET spatialite)
    set(SPATIALITE_VERSION_STRING ${PC_SPATIALITE_VERSION} CACHE INTERNAL "")
endif()

find_path(SPATIALITE_INCLUDE_DIR
          NAMES spatialite.h
          HINSTS ${PC_SPATIALITE_INCLUDE_DIR})
find_library(SPATIALITE_LIBRARY
             NAMES spatialite
             HINTS ${PC_SPATIALITE_LIBRARY})
mark_as_advanced(SPATIALITE_LIBRARY SPATIALITE_INCLUDE_DIR)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SPATIALITE
                                  FOUND_VAR SPATIALITE_FOUND
                                  REQUIRED_VARS SPATIALITE_LIBRARY SPATIALITE_INCLUDE_DIR
                                  VERSION_VAR SPATIALITE_VERSION_STRING)
if(SPATIALITE_FOUND)
    set(SPATIALITE_LIBRARIES ${SPATIALITE_LIBRARY})
    set(SPATIALITE_INCLUDE_DIRS ${SPATIALITE_INCLUDE_DIR})
    if(NOT TARGET SPATIALITE::SPATIALITE)
        add_library(SPATIALITE::SPATIALITE UNKNOWN IMPORTED)
        set_target_properties(SPATIALITE::SPATIALITE PROPERTIES
                              INTERFACE_INCLUDE_DIRECTORIES ${SPATIALITE_INCLUDE_DIR}
                              IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                              IMPORTED_LOCATION ${SPATIALITE_LIBRARY})
    endif()
endif()
