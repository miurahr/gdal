#.rst:
# FindPoppler
# -----------
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
#
# Try to find Poppler.
#
# This is a component-based find module, which makes use of the COMPONENTS
# and OPTIONAL_COMPONENTS arguments to find_module.  The following components
# are available::
#
#   Core  Cpp  Qt5  Qt4 Glib Find POPPLER
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# If it's found it sets POPPLER_FOUND to TRUE
# and following variables are set:
#    POPPLER_INCLUDE_DIRS
#    POPPLER_LIBRARY
#    POPPLER_VERSION
#
#=============================================================================
# Copyright 2015 Alex Richardson <arichardson.kde@gmail.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

# try to use framework on mac
# want clean framework path, not unix compatibility path
IF (POPPLER_INCLUDE_DIR AND POPPLER_LIBRARIES)
  # Already in cache, be silent
  SET(POPPLER_FIND_QUIETLY TRUE)
ENDIF()

set(Poppler_known_components
    Cpp
    Qt4
    Qt5
    Glib
)
foreach(_comp ${Poppler_known_components})
    string(TOLOWER "${_comp}" _lc_comp)
    set(Poppler_${_comp}_pkg_config "poppler-${_lc_comp}")
    set(Poppler_${_comp}_lib "poppler-${_lc_comp}")
    set(Poppler_${_comp}_header_subdir "poppler/${_lc_comp}")
endforeach()
set(Poppler_known_components Core ${Poppler_known_components})

set(Poppler_Core_pkg_config "poppler")
# poppler-config.h header is only installed with --enable-xpdf-headers
# fall back to using any header from a submodule with a path to make it work in that case too
set(Poppler_Core_header "poppler-config.h" "cpp/poppler-version.h" "qt5/poppler-qt5.h" "qt4/poppler-qt4.h" "glib/poppler.h")
set(Poppler_Core_header_subdir "poppler")
set(Poppler_Core_lib "poppler")

set(Poppler_Cpp_header "poppler-version.h")
set(Poppler_Qt5_header "poppler-qt5.h")
set(Poppler_Qt4_header "poppler-qt4.h")
set(Poppler_Glib_header "poppler.h")

if(APPLE)
    if(CMAKE_FIND_FRAMEWORK MATCHES "FIRST"
            OR CMAKE_FRAMEWORK_PATH MATCHES "ONLY"
            OR NOT CMAKE_FIND_FRAMEWORK)
        set(CMAKE_FIND_FRAMEWORK_save ${CMAKE_FIND_FRAMEWORK} CACHE STRING "" FORCE)
        set(CMAKE_FIND_FRAMEWORK "ONLY" CACHE STRING "" FORCE)
        find_library(POPPLER_LIBRARY POPPLER)
        if(POPPLER_LIBRARY)
            # FIND_PATH doesn't add "Headers" for a framework
            SET (POPPLER_INCLUDE_DIR ${POPPLER_LIBRARY}/Headers CACHE PATH "Path to a file.")
        endif(POPPLER_LIBRARY)
        set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    endif()
endif(APPLE)

find_package(PkgConfig QUIET)
foreach(_comp IN LISTS ${Poppler_known_components})
    if(PKG_CONFIG_FOUND)
        # try using pkg-config to get the directories and then use these values
        # in the FIND_PATH() and FIND_LIBRARY() calls
        pkg_check_modules(PC_Poppler_${_comp} QUIET ${Poppler_${_comp}_pkg_config})
    endif()
    find_path(Poppler_${_comp}_INCLUDE_DIR
              NAMES ${Poppler_${_comp}_header}
              PATH_SUFFIXES ${Poppler_${_comp}_header_subdir}
              HINTS ${PC_Poppler_${_comp}_INCLUDE_DIRS}
              )
    find_library(Poppler_${_comp}_LIBRARY
            NAMES ${Poppler_${_comp}_lib
            HINTS ${PC_Poppler_${_comp}_LIBRARY_DIRS}
    )
endforeach()
set(Poppler_INCLUDE_DIR "${Poppler_Core_INCLUDE_DIR}")
set(Poppler_LIBRARY "${Poppler_Core_LIBRARY}")

if(Poppler_INCLUDE_DIR AND Poppler_LIBRARY)
    if(PC_Poppler_Core_VERSION)
        set(Poppler_VERSION ${PC_Poppler_Core_VERSION})
    endif()
    if(NOT Poppler_VERSION)
        find_file(Poppler_VERSION_HEADER
            NAMES "poppler-config.h" "cpp/poppler-version.h"
            HINTS ${Poppler_INCLUDE_DIRS}
            PATH_SUFFIXES ${Poppler_Core_header_subdir}
        )
        mark_as_advanced(Poppler_VERSION_HEADER)
        if(Poppler_VERSION_HEADER)
            file(READ ${Poppler_VERSION_HEADER} _poppler_version_header_contents)
            string(REGEX REPLACE
                "^.*[ \t]+POPPLER_VERSION[ \t]+\"([0-9d.]*)\".*$"
                "\\1"
                Poppler_VERSION
                "${_poppler_version_header_contents}"
            )
            unset(_poppler_version_header_contents)
        endif()
    endif()

    if(NOT Poppler_VERSION)
        # Check that we can accept Page::pageObj private member
        include(CheckCXXSourceCompiles)
        set(POPPLER_TEST_SOURCE "#define private public\n#include <poppler/Page.h>\n#include <poppler/splash/SplashBitmap.h>\n
        int main(int argc, char** argv) { return &(((Page*)0x8000)->pageObj) == 0; }")
        check_cxx_source_compiles(POPPLER_TEST_SOURCE   TEST_POPPLER_PAGEOBJ)
        if(TEST_POPPLER_PAGEOBJ)
            set(HAVE_POPPLER TRUE)
            set(Poppler_VERSION "0.58")
        else()
            # poppler 0.23.0 needs to be linked against pthread
            set (CMAKE_REQUIRED_FLAGS "${CMAKE_CXX_FLAGS} -lpthread -I${POPPLER_INCLUDE_DIR}")
            check_cxx_source_compiles(POPPLER_TEST_SOURCE TEST_POPPLER_PTHREAD)
            set(CMAKE_REQUIRED_FLAGS "")
            if(TEST_POPPLER_PTHREAD)
                set(HAVE_POPPLER TRUE)
                set(Poppler_VERSION "0.23")
            else()
                set(Poppler_VERSION "0.20")
            endif()
        endif()
    endif()
endif()

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Poppler
                                  FOUND_VAR Poppler_FOUND
                                  REQUIRED_VARS Poppler_LIBRARY Poppler_INCLUDE_DIR
                                  VERSION_VAR  Poppler_VERSION
                                  HANDLE_COMPONENTS
                                  )

    MARK_AS_ADVANCED(
    Poppler_INCLUDE_DIR
    Poppler_LIBRARY
)

if(Poppler_FOUND)
    set(Poppler_INCLUDE_DIRS ${Poppler_INCLUDE_DIR})
    set(Poppler_LIBRARIES ${Poppler_LIBRARY})

    if(NOT TARGET POPPLER::POPPLER)
        add_library(POPPLER::POPPLER UNKNOWN IMPORTED)
        set_target_properties(POPPLER::POPPLER PROPERTIES
                              INTERFACE_INCLUDE_DIRECTORIES ${Poppler_INCLUDE_DIR}
                              IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                              IMPORTED_LOCATION "${Poppler_LIBRARY}")
        foreach(tgt IN LIST Poppler_known_components)
            add_library(POPPLER::${tgt} UNKNOWN IMPORTED)
            set_target_properties(POPPLER::${tgt} PROPERTIES
                                  INTERFACE_INCLUDE_DIRECTORIES ${Poppler_${tgt}_INCLUDE_DIR}
                                  IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                                  IMPORTED_LOCATION ${Poppler_${tgt}_LIBRARY})
        endforeach()
    endif()
endif()

include(FeatureSummary)
set_package_properties(Poppler PROPERTIES
    DESCRIPTION "A PDF rendering library"
    URL "http://poppler.freedesktop.org"
)