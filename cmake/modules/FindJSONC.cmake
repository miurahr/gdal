# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file COPYING-CMAKE-SCRIPTS or https://cmake.org/licensing for details.

#.rst
# FindJSONC
# ~~~~~~~~~
# Copyright (C) 2017-2018, Hiroshi Miura
# Copyright (c) 2012, Dmitry Baryshnikov <polimax at mail.ru>
#
# CMake module to search for jsonc library
#
# If it's found it sets JSONC_FOUND to TRUE
# and following variables are set:
#    JSONC_INCLUDE_DIR
#    JSONC_LIBRARY

# try to use framework on mac
# want clean framework path, not unix compatibility path
if(APPLE)
  if(CMAKE_FIND_FRAMEWORK MATCHES "FIRST"
      OR CMAKE_FRAMEWORK_PATH MATCHES "ONLY"
      OR NOT CMAKE_FIND_FRAMEWORK)
    set(CMAKE_FIND_FRAMEWORK_save ${CMAKE_FIND_FRAMEWORK} CACHE STRING "" FORCE)
    set(CMAKE_FIND_FRAMEWORK "ONLY" CACHE STRING "" FORCE)
    find_library(JSONC_LIBRARY JSONC)
    if(JSONC_LIBRARY)
      set(JSONC_INCLUDE_DIR ${JSONC_LIBRARY}/Headers CACHE PATH "Path to a file.")
    endif(JSONC_LIBRARY)
    set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
  endif()
endif()

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(PC_JSONC QUIET json-c)
endif()

find_path(JSONC_INCLUDE_DIR
          NAMES json.h
          HINTS ${PC_JSONC_INCLUDE_DIRS}
                ${JSONC_ROOT}/include
          PATH_SUFFIXES json-c)
find_library(JSONC_LIBRARY
             NAMES json-c json
             HINTS ${PC_JSONC_LIBRARY_DIRS}
                   ${JSONC_ROOT}/lib)
mark_as_advanced(JSONC_LIBRARY JSONC_INCLUDE_DIR)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(JSONC DEFAULT_MSG JSONC_LIBRARY JSONC_INCLUDE_DIR)

if(JSONC_FOUND)
  set(JSONC_INCLUDE_DIRS ${JSONC_INCLUDE_DIR})
  set(JSONC_LIBRARIES ${JSONC_LIBRARY})
  if(NOT TARGET JSONC::JSONC)
      add_library(JSONC::JSONC UNKNOWN IMPORTED)
      set_target_properties(JSONC::JSONC PROPERTIES
                            INTERFACE_INCLUDE_DIRECTORIES "${JSONC_INCLUDE_DIRS}"
                            IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                            IMPORTED_LOCATION "${JSONC_LIBRARY}")
  endif()
endif()