# Find Rasterlite
# ~~~~~~~~~~~~~~~
#
# Copyright (c) 2009, Sandro Furieri <a.furieri at lqt.it>
# Copyright (C) 2017, Hiroshi Miura
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# CMake module to search for SpatiaLite library
#
# If it's found it sets RASTERLITE_FOUND to TRUE
# and following variables are set:
#    RASTERLITE_INCLUDE_DIR
#    RASTERLITE_LIBRARY
#    RASTERLITE_VERSION_STRING

# FIND_PATH and FIND_LIBRARY normally search standard locations
# before the specified paths. To search non-standard paths first,
# FIND_* is invoked first with specified paths and NO_DEFAULT_PATH
# and then again with no specified paths to search the default
# locations. When an earlier FIND_* succeeds, subsequent FIND_*s
# searching for the same item do nothing. 

# try to use sqlite framework on mac
# want clean framework path, not unix compatibility path
if(APPLE)
    if(CMAKE_FIND_FRAMEWORK MATCHES "FIRST"
      OR CMAKE_FRAMEWORK_PATH MATCHES "ONLY"
      OR NOT CMAKE_FIND_FRAMEWORK)
        set(CMAKE_FIND_FRAMEWORK_save ${CMAKE_FIND_FRAMEWORK} CACHE STRING "" FORCE)
        set(CMAKE_FIND_FRAMEWORK "ONLY" CACHE STRING "" FORCE)
        find_path(RASTERLITE_INCLUDE_DIR rasterlite.h)
        # if no spatialite header, we don't want sqlite find below to succeed
        if(RASTERLITE_INCLUDE_DIR)
            find_library(RASTERLITE_LIBRARY rasterlite)
            # FIND_PATH doesn't add "Headers" for a framework
            set(RASTERLITE_INCLUDE_DIR ${RASTERLITE_LIBRARY}/Headers CACHE PATH "Path to a file." FORCE)
        endif()
        set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    endif()
endif()

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
    # try using pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    PKG_CHECK_MODULES(PC_RASTERLITE2 QUIET rasterlite2)
    SET(RASTERLITE2_VERSION_STRING ${PC_RASTERLITE2_VERSION} CACHE INTERNAL "")
endif()

FIND_PATH(RASTERLITE2_INCLUDE_DIR
          NAMES rasterlite2.h
          SUFFIX_PATHS rasterlite2
          HINSTS ${PC_RASTERLITE2_INCLUDE_DIR})
FIND_LIBRARY(RASTERLITE2_LIBRARY
             NAMES rasterlite2
             HINTS ${PC_RASTERLITE2_LIBRARY})

mark_as_advanced(RASTERLITE2_LIBRARY RASTERLITE2_INCLUDE_DIR)

# Handle the QUIETLY and REQUIRED arguments and set GEOS_FOUND to TRUE
# if all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(RASTERLITE2
                                  FOUND_VAR RASTERLITE2_FOUND
                                  REQUIRED_VARS RASTERLITE2_LIBRARY RASTERLITE2_INCLUDE_DIR
                                  VERSION_VAR RASTERLITE2_VERSION_STRING)

if(RASTERLITE2_FOUND)
    set(RASTERLITE2_LIBRARIES ${RASTERLITE2_LIBRARY})
    set(RASTERLITE2_INCLUDE_DIRS ${RASTERLITE2_INCLUDE_DIR})
endif()

