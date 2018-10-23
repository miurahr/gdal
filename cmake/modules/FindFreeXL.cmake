# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindFreeXL
----------

Find the FreeXL includes and get all installed freexl library settings

The following vars are set if freexl is found.

.. variable:: FREEXL_FOUND

  True if found, otherwise all other vars are undefined

.. variable:: FREEXL_INCLUDE_DIR

  The include dir for main *.h files

.. variable:: FREEXL_VERSION_STRING

  full version (e.g. 4.2.0)

.. variable:: FREEXL_VERSION_MAJOR

  major part of version (e.g. 4)

.. variable:: FREEXL_VERSION_MINOR

  minor part (e.g. 2)

#]=======================================================================]


include(FindPackageHandleStandardArgs)
include(SelectLibraryConfigurations)

# try to use framework on mac
# want clean framework path, not unix compatibility path
if(APPLE)
    if(CMAKE_FIND_FRAMEWORK MATCHES "FIRST"
        OR CMAKE_FRAMEWORK_PATH MATCHES "ONLY"
        OR NOT CMAKE_FIND_FRAMEWORK)
        set(CMAKE_FIND_FRAMEWORK_save ${CMAKE_FIND_FRAMEWORK} CACHE STRING "" FORCE)
        set(CMAKE_FIND_FRAMEWORK "ONLY" CACHE STRING "" FORCE)
        find_library(FREEXL_LIBRARY freexl)
        if(FREEXL_LIBRARY)
            # they're all the same in a framework
            set(FREEXL_INCLUDE_DIR ${FREEXL_LIBRARY}/Headers CACHE PATH "Path to a file.")
            # version in info.plist
            get_version_plist(${FREEXL_LIBRARY}/Resources/Info.plist FREEXL_VERSION)
            if(NOT FREEXL_VERSION)
                MESSAGE (FATAL_ERROR "Could not determine FreeXL version from framework.")
            endif()
            string(REGEX REPLACE "([0-9]+)\\.([0-9]+)\\.([0-9]+)" "\\1" FREEXL_VERSION_MAJOR "${FREEXL_VERSION}")
            string(REGEX REPLACE "([0-9]+)\\.([0-9]+)\\.([0-9]+)" "\\2" FREEXL_VERSION_MINOR "${FREEXL_VERSION}")
        endif()
        set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    endif()
endif()

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_FREEXL QUIET freexl)
endif()

find_path(FREEXL_INCLUDE_DIR
          NAMES freexl.h
          HINSTS ${PC_FREEXL_INCLUDE_DIRS})
find_library(FREEXL_LIBRARY
             NAMES freexl
             HINTS ${PC_FREEXL_LIBRARY_DIRS})

mark_as_advanced(FREEXL_INCLUDE_DIR FREEXL_LIBRARY)
find_package_handle_standard_args(FREEXL FOUND_VAR FREEXL_FOUND
                                  REQUIRED_VARS FREEXL_LIBRARY FREEXL_INCLUDE_DIR)

if(FREEXL_FOUND)
    set(FREEXL_LIBRARIES ${FREEXL_LIBRARY})
    set(FREEXL_INCLUDE_DIRS ${FREEXL_INCLUDE_DIR})

    if(NOT TARGET FREEXL::freexl)
        add_library(FREEXL::freexl UNKNOWN IMPORTED)
        set_target_properties(FREEXL::freexl PROPERTIES
                              INTERFACE_INCLUDE_DIRECTORIES "${FREEXL_INCLUDE_DIR}"
                              IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                              IMPORTED_LOCATION "${FREEXL_LIBRARY}")
    endif()
endif()