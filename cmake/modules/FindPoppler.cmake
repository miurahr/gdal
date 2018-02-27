# Find POPPLER
# ~~~~~~~~~
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# If it's found it sets POPPLER_FOUND to TRUE
# and following variables are set:
#    POPPLER_INCLUDE_DIRS
#    POPPLER_LIBRARY
#    POPPLER_VERSION

# try to use framework on mac
# want clean framework path, not unix compatibility path
IF (POPPLER_INCLUDE_DIR AND POPPLER_LIBRARIES)
  # Already in cache, be silent
  SET(POPPLER_FIND_QUIETLY TRUE)
ENDIF()

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

FIND_PACKAGE(PkgConfig QUIET)
IF(PKG_CONFIG_FOUND)
    # try using pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    PKG_CHECK_MODULES(PC_POPPLER QUIET poppler)
ENDIF()

find_path(POPPLER_INCLUDE_DIR
          NAMES poppler/poppler-config.h
          PATHS /usr/include /usr/local/include
          HINTS ${PC_POPPLER_INCLUDE_DIRS}
)

find_path(POPPLER_GLIB_INCLUDE_DIR
        NAMES goo/gtypes.h
        PATHS /usr/include/poppler /usr/local/include/poppler
        HINTS ${PC_POPPLER_INCLUDE_DIRS}/poppler
)

set(POPPLER_INCLUDE_DIRS ${POPPLER_INCLUDE_DIR} ${POPPLER_GLIB_INCLUDE_DIR})

find_library(POPPLER_LIBRARY
        NAMES poppler libpoppler
        HINTS ${PC_POPPLER_LIBRARY_DIRS}
)

if(POPPLER_INCLUDE_DIR AND POPPLER_LIBRARY)
    # Check that we can accept Page::pageObj private member
    include(CheckCXXSourceCompiles)
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
            # FIXME: Ignore version < 0.20 that is too old.
            set(POPPLER_VERSION "0.20")
        endif()
    endif()
    if(HAVE_POPPLER)
        # if we get modversion, set it as POPPLER_VERSION
        if(PC_POPPLER_VERSION)
            # TODO: check integrity between source compile check and report of pkg-config
            # sometimes pkg-config returns wrong version.
            set(POPPLER_VERSION ${PC_POPPLER_VERSION})
        endif()
        # else it would retern 0.20 or 0.23 or 0.58
    endif()
endif()

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(POPPLER
                                  FOUND_VAR POPPLER_FOUND
                                  REQUIRED_VARS POPPLER_LIBRARY POPPLER_INCLUDE_DIR POPPLER_GLIB_INCLUDE_DIR
                                  VERSION_VAR  POPPLER_VERSION
                                  )

MARK_AS_ADVANCED(
    POPPLER_INCLUDE_DIRS
    POPPLER_LIBRARY
    POPPLER_VERSION
)
