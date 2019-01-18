# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file COPYING-CMAKE-SCRIPTS or https://cmake.org/licensing for details.

#.rst:
# FindPoppler
# -----------
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
# Copyright (c) 2015, Alex Richardson <arichardson.kde@gmail.com>
#
# Try to find Poppler.
#
# This is a component-based find module, which makes use of the COMPONENTS
# and OPTIONAL_COMPONENTS arguments to find_package.  The following components
# are available::
#
#   Cpp  Qt5  Qt4 Glib
#
# If it's found it sets POPPLER_FOUND to TRUE
# and following variables are set:
#    POPPLER_INCLUDE_DIRS
#    POPPLER_LIBRARY
#    POPPLER_VERSION
#
include(FeatureSummary)
include(FindPackageHandleStandardArgs)
include(CheckCXXSourceCompiles)

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_Poppler QUIET poppler)
endif()
find_path(POPPLER_INCLUDE_DIR NAMES "poppler-config.h" "cpp/poppler-version.h" "qt5/poppler-qt5.h" "qt4/poppler-qt4.h"
          "glib/poppler.h"
          HINTS ${PC_Poppler_INCLUDE_DIRS}
          PATH_SUFFIXES poppler)

find_library(POPPLER_LIBRARY
             NAMES poppler
             HINTS ${PC_Poppler_LIBRARY_DIRS}
             )

set(Poppler_known_components
    Cpp
    Qt4
    Qt5
    Glib
)
foreach(_comp IN LISTS Poppler_known_components)
    string(TOLOWER "${_comp}" _lc_comp)
    set(Poppler_${_comp}_pkg_config "poppler-${_lc_comp}")
    set(Poppler_${_comp}_lib "poppler-${_lc_comp}")
    set(Poppler_${_comp}_header_subdir "poppler/${_lc_comp}")
endforeach()
set(Poppler_known_components Core ${Poppler_known_components})

# poppler-config.h header is only installed with --enable-xpdf-headers
# fall back to using any header from a submodule with a path to make it work in that case too
set(Poppler_Cpp_header "poppler-version.h")
set(Poppler_Qt5_header "poppler-qt5.h")
set(Poppler_Qt4_header "poppler-qt4.h")
set(Poppler_Glib_header "poppler.h")

foreach(_comp IN LISTS Poppler_FIND_COMPONENTS)
  set(POPPLER_${_comp}_FOUND FALSE)
endforeach()

foreach(_comp IN LISTS Poppler_known_components)
    list(FIND Poppler_FIND_COMPONENTS "${_comp}" _nextcomp)
    if(_nextcomp GREATER -1)
        find_path(POPPLER_${_comp}_INCLUDE_DIR
                  NAMES ${Poppler_${_comp}_header}
                  PATH_SUFFIXES poppler
                  HINTS ${PC_Poppler_${_comp}_INCLUDE_DIRS}
                  )
        find_library(POPPLER_${_comp}_LIBRARY
                NAMES ${Poppler_${_comp}_lib}
                HINTS ${PC_Poppler_${_comp}_LIBRARY_DIRS}
        )
    endif()
endforeach()

if(POPPLER_INCLUDE_DIR AND POPPLER_LIBRARY)
    if(PC_Poppler_VERSION)
        set(POPPLER_VERSION ${PC_Poppler_VERSION})
    endif()
    if(NOT POPPLER_VERSION)
        find_file(POPPLER_VERSION_HEADER
            NAMES "poppler-config.h" "cpp/poppler-version.h"
            HINTS ${Poppler_INCLUDE_DIR}
            PATH_SUFFIXES poppler
        )
        mark_as_advanced(POPPLER_VERSION_HEADER)
        if(POPPLER_VERSION_HEADER)
            file(READ ${POPPLER_VERSION_HEADER} _poppler_version_header_contents)
            string(REGEX REPLACE
                "^.*[ \t]+POPPLER_VERSION[ \t]+\"([0-9d.]*)\".*$"
                "\\1"
                Poppler_VERSION
                "${_poppler_version_header_contents}"
            )
            unset(_poppler_version_header_contents)
        endif()
    endif()

    if(NOT POPPLER_VERSION)
        # Check that we can accept Page::pageObj private member
        set(POPPLER_TEST_SOURCE "#define private public\n#include <poppler/Page.h>\n#include <poppler/splash/SplashBitmap.h>\n
        int main(int argc, char** argv) { return &(((Page*)0x8000)->pageObj) == 0; }")
        check_cxx_source_compiles(POPPLER_TEST_SOURCE   TEST_POPPLER_PAGEOBJ)
        if(TEST_POPPLER_PAGEOBJ)
            set(HAVE_POPPLER TRUE)
            set(POPPLER_VERSION "0.58")
        else()
            # poppler 0.23.0 needs to be linked against pthread
            set (CMAKE_REQUIRED_FLAGS "${CMAKE_CXX_FLAGS} -lpthread -I${POPPLER_INCLUDE_DIR}")
            check_cxx_source_compiles(POPPLER_TEST_SOURCE TEST_POPPLER_PTHREAD)
            set(CMAKE_REQUIRED_FLAGS "")
            if(TEST_POPPLER_PTHREAD)
                set(HAVE_POPPLER TRUE)
                set(POPPLER_VERSION "0.23")
            else()
                set(POPPLER_VERSION "0.20")
            endif()
        endif()
    endif()
endif()

find_package_handle_standard_args(Poppler
                                  REQUIRED_VARS POPPLER_LIBRARY POPPLER_INCLUDE_DIR
                                  VERSION_VAR  POPPLER_VERSION
                                  HANDLE_COMPONENTS)

mark_as_advanced(Poppler_INCLUDE_DIR Poppler_LIBRARY)

if(POPPLER_FOUND)
    set(POPPLER_INCLUDE_DIRS ${POPPLER_INCLUDE_DIR})
    set(POPPLER_LIBRARIES ${POPPLER_LIBRARY})

    if(NOT TARGET POPPLER::Poppler)
        add_library(POPPLER::Poppler UNKNOWN IMPORTED)
        set_target_properties(POPPLER::Poppler PROPERTIES
                              INTERFACE_INCLUDE_DIRECTORIES ${POPPLER_INCLUDE_DIR}
                              IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                              IMPORTED_LOCATION "${POPPLER_LIBRARY}")
        foreach(tgt IN LISTS Poppler_known_components)
            add_library(POPPLER::${tgt} UNKNOWN IMPORTED)
            set_target_properties(POPPLER::${tgt} PROPERTIES
                                  INTERFACE_INCLUDE_DIRECTORIES ${POPPLER_${tgt}_INCLUDE_DIR}
                                  IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                                  IMPORTED_LOCATION ${POPPLER_${tgt}_LIBRARY})
        endforeach()
    endif()
endif()

set_package_properties(Poppler PROPERTIES
    DESCRIPTION "A PDF rendering library"
    URL "http://poppler.freedesktop.org"
)