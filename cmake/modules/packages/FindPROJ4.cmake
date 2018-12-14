# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file COPYING-CMAKE-SCRIPTS or https://cmake.org/licensing for details.

#.rst:
# FindPROJ4
# ---------
#
# CMake module to search for PROJ.4 library
#
# On success, the macro sets the following variables:
# PROJ4_FOUND        = if the library found
# PROJ4_LIBRARIES    = full path to the library
# PROJ4_INCLUDE_DIRS = where to find the library headers
#
# Copyright (c) 2009 Mateusz Loskot <mateusz@loskot.net>
# Copyright (c) 2015 NextGIS <info@nextgis.com>
# Copyright (c) 2018 Hiroshi Miura
#
#

if(MSVC)
    set(PROJ4_NAMES proj proj_i)
elseif(MINGW OR CYGWIN)
    set(PROJ4_NAMES proj libproj-0 libproj-9 libproj-10 libproj-11 libproj-12)
else()
    set(PROJ4_NAMES proj)
endif()

find_path(PROJ4_INCLUDE_DIR proj_api.h
    PATHS ${PROJ4_ROOT}/include
    DOC "Path to PROJ.4 library include directory")

find_library(PROJ4_LIBRARY
    NAMES ${PROJ4_NAMES}
    PATHS ${PROJ4_ROOT}/lib
    DOC "Path to PROJ.4 library file")

if(PROJ4_INCLUDE_DIR)
    set(PROJ4_VERSION_MAJOR 0)
    set(PROJ4_VERSION_MINOR 0)
    set(PROJ4_VERSION_PATCH 0)
    set(PROJ4_VERSION_NAME "EARLY RELEASE")

    if(EXISTS "${PROJ4_INCLUDE_DIR}/proj_api.h")
        file(READ "${PROJ4_INCLUDE_DIR}/proj_api.h" PROJ_API_H_CONTENTS)
        string(REGEX MATCH "PJ_VERSION[ \t]+([0-9]+)"
          PJ_VERSION ${PROJ_API_H_CONTENTS})
        string (REGEX MATCH "([0-9]+)"
          PJ_VERSION ${PJ_VERSION})

        string(SUBSTRING ${PJ_VERSION} 0 1 PROJ4_VERSION_MAJOR)
        string(SUBSTRING ${PJ_VERSION} 1 1 PROJ4_VERSION_MINOR)
        string(SUBSTRING ${PJ_VERSION} 2 1 PROJ4_VERSION_PATCH)
        unset(PROJ_API_H_CONTENTS)
    endif()

    set(PROJ4_VERSION_STRING "${PROJ4_VERSION_MAJOR}.${PROJ4_VERSION_MINOR}.${PROJ4_VERSION_PATCH}")
endif ()

# Handle the QUIETLY and REQUIRED arguments and set SPATIALINDEX_FOUND to TRUE
# if all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PROJ4
                                  REQUIRED_VARS PROJ4_LIBRARY PROJ4_INCLUDE_DIR
                                  VERSION_VAR PROJ4_VERSION_STRING)

if(PROJ4_FOUND)
  set(PROJ4_LIBRARIES ${PROJ4_LIBRARY})
  set(PROJ4_INCLUDE_DIRS ${PROJ4_INCLUDE_DIR})
endif()

# Hide internal variables
mark_as_advanced(
  PROJ4_INCLUDE_DIR
  PROJ4_LIBRARY)

#======================
