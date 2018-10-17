# Find GEOS
# ~~~~~~~~~
# Copyright (C) 2017-2018, Hiroshi Miura
# Copyright (c) 2008, Mateusz Loskot <mateusz@loskot.net>
# (based on FindGDAL.cmake by Magnus Homann)
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# CMake module to search for GEOS library
#
# If it's found it sets GEOS_FOUND to TRUE
# and following variables are set:
#    GEOS_INCLUDE_DIR
#    GEOS_LIBRARY
#

# try to use framework on mac
# want clean framework path, not unix compatibility path
if(APPLE)
    if(CMAKE_FIND_FRAMEWORK MATCHES "FIRST"
        OR CMAKE_FRAMEWORK_PATH MATCHES "ONLY"
        OR NOT CMAKE_FIND_FRAMEWORK)
        set(CMAKE_FIND_FRAMEWORK_save ${CMAKE_FIND_FRAMEWORK} CACHE STRING "" FORCE)
        set(CMAKE_FIND_FRAMEWORK "ONLY" CACHE STRING "" FORCE)
        find_library(GEOS_LIBRARY GEOS)
        if(GEOS_LIBRARY)
            # they're all the same in a framework
            set(GEOS_INCLUDE_DIR ${GEOS_LIBRARY}/Headers CACHE PATH "Path to a file.")
            # set GEOS_CONFIG to make later test happy, not used here, may not exist
            set(GEOS_CONFIG ${GEOS_LIBRARY}/unix/bin/geos-config CACHE FILEPATH "Path to a program.")
            # version in info.plist
            get_version_plist(${GEOS_LIBRARY}/Resources/Info.plist GEOS_VERSION)
            if(NOT GEOS_VERSION)
                MESSAGE (FATAL_ERROR "Could not determine GEOS version from framework.")
            endif()
            string(REGEX REPLACE "([0-9]+)\\.([0-9]+)\\.([0-9]+)" "\\1" GEOS_VERSION_MAJOR "${GEOS_VERSION}")
            string(REGEX REPLACE "([0-9]+)\\.([0-9]+)\\.([0-9]+)" "\\2" GEOS_VERSION_MINOR "${GEOS_VERSION}")
            if(GEOS_VERSION_MAJOR LESS 3)
                message (FATAL_ERROR "GEOS version is too old (${GEOS_VERSION}). Use 3.0.0 or higher.")
            endif()
        endif()
        set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    endif()
endif()

find_program(GEOS_CONFIG geos-config)
if(GEOS_CONFIG)
    exec_program(${GEOS_CONFIG}
                 ARGS --version
                 OUTPUT_VARIABLE GEOS_VERSION)
    exec_program(${GEOS_CONFIG}
                 ARGS --prefix
                 OUTPUT_VARIABLE GEOS_PREFIX)
endif()

find_path(GEOS_INCLUDE_DIR
          NAMES geos_c.h
          HINSTS ${GEOS_PREFIX}/include)
find_library(GEOS_LIBRARY
             NAMES geos_c
             HINTS ${GEOS_PREFIX}/lib)

mark_as_advanced(GEOS_INCLUDE_DIR GEOS_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GEOS FOUND_VAR GEOS_FOUND REQUIRED_VARS GEOS_INCLUDE_DIR GEOS_LIBRARY)

if(GEOS_FOUND)
    set(GEOS_LIBRARIES ${GEOS_LIBRARY})
    set(GEOS_INCLUDE_DIRS ${GEOS_INCLUDE_DIR})

    if(NOT TARGET GEOS::GEOS)
        add_library(GEOS::GEOS UNKNOWN IMPORTED)
        set_target_properties(GEOS::GEOS PROPERTIES
                              INTERFACE_INCLUDE_DIRECTORIES "${GEOS_INCLUDE_DIR}"
                              IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                              IMPORTED_LOCATION "${GEOS_LIBRARY}")
    endif()
endif()