# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file COPYING-CMAKE-SCRIPTS or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindPROJ
---------

CMake module to search for PROJ(PROJ.4 and PROJ) library

On success, the macro sets the following variables:
``PROJ_FOUND``
  if the library found

``PROJ_LIBRARIES``
  full path to the library

``PROJ_INCLUDE_DIRS``
  where to find the library headers

``PROJ_VERSION_STRING``
  version string of PROJ

Copyright (c) 2009 Mateusz Loskot <mateusz@loskot.net>
Copyright (c) 2015 NextGIS <info@nextgis.com>
Copyright (c) 2018 Hiroshi Miura

#]=======================================================================]


if(MSVC)
    set(PROJ_NAMES proj proj_i)
elseif(MINGW OR CYGWIN)
    set(PROJ_NAMES proj libproj-0 libproj-9 libproj-10 libproj-11 libproj-12 libproj-13)
else()
    set(PROJ_NAMES proj)
endif()

find_path(PROJ_INCLUDE_DIR proj_api.h
    PATHS ${PROJ_ROOT}/include
    DOC "Path to PROJ library include directory")

find_library(PROJ_LIBRARY
    NAMES ${PROJ_NAMES}
    PATHS ${PROJ_ROOT}/lib
    DOC "Path to PROJ library file")

if(PROJ_INCLUDE_DIR)
    set(PROJ_VERSION_MAJOR 0)
    set(PROJ_VERSION_MINOR 0)
    set(PROJ_VERSION_PATCH 0)
    set(PROJ_VERSION_NAME "EARLY RELEASE")

    if(EXISTS "${PROJ_INCLUDE_DIR}/proj_api.h")
        file(READ "${PROJ_INCLUDE_DIR}/proj_api.h" PROJ_API_H_CONTENTS)
        string(REGEX MATCH "PJ_VERSION[ \t]+([0-9]+)"
          PJ_VERSION ${PROJ_API_H_CONTENTS})
        string (REGEX MATCH "([0-9]+)"
          PJ_VERSION ${PJ_VERSION})

        string(SUBSTRING ${PJ_VERSION} 0 1 PROJ_VERSION_MAJOR)
        string(SUBSTRING ${PJ_VERSION} 1 1 PROJ_VERSION_MINOR)
        string(SUBSTRING ${PJ_VERSION} 2 1 PROJ_VERSION_PATCH)
        unset(PROJ_API_H_CONTENTS)
    endif()

    set(PROJ_VERSION_STRING "${PROJ_VERSION_MAJOR}.${PROJ_VERSION_MINOR}.${PROJ_VERSION_PATCH}")
endif ()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PROJ
                                  REQUIRED_VARS PROJ_LIBRARY PROJ_INCLUDE_DIR
                                  VERSION_VAR PROJ_VERSION_STRING)
mark_as_advanced(PROJ_INCLUDE_DIR PROJ_LIBRARY)

if(PROJ_FOUND)
  set(PROJ_LIBRARIES ${PROJ_LIBRARY})
  set(PROJ_INCLUDE_DIRS ${PROJ_INCLUDE_DIR})
  if(NOT TARGET PROJ::PROJ)
    add_library(PROJ::PROJ UNKNOWN IMPORTED)
    set_target_properties(PROJ::PROJ PROPERTIES
                          INTERFACE_INCLUDE_DIRECTORIES ${PROJ_INCLUDE_DIR}
                          IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                          IMPORTED_LOCATION ${PROJ_LIBRARY})
  endif()
endif()

