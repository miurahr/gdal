# Find KEA - KEA library
# ~~~~~~~~~
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# If it's found it sets KEA_FOUND to TRUE
# and following variables are set:
#    KEA_INCLUDE_DIR
#    KEA_LIBRARY
#    KEA_VERSION
#
# FIND_PATH and FIND_LIBRARY normally search standard locations
# before the specified paths. To search non-standard paths first,
# FIND_* is invoked first with specified paths and NO_DEFAULT_PATH
# and then again with no specified paths to search the default
# locations. When an earlier FIND_* succeeds, subsequent FIND_*s
# searching for the same item do nothing.

# try to use framework on mac
# want clean framework path, not unix compatibility path
if(APPLE)
    if(CMAKE_FIND_FRAMEWORK MATCHES "FIRST"
            OR CMAKE_FRAMEWORK_PATH MATCHES "ONLY"
            OR NOT CMAKE_FIND_FRAMEWORK)
        set(CMAKE_FIND_FRAMEWORK_save ${CMAKE_FIND_FRAMEWORK} CACHE STRING "" FORCE)
        set(CMAKE_FIND_FRAMEWORK "ONLY" CACHE STRING "" FORCE)
        find_library(KEA_LIBRARY KEA)
        if(KEA_LIBRARY)
            # FIND_PATH doesn't add "Headers" for a framework
            SET (KEA_INCLUDE_DIR ${KEA_LIBRARY}/Headers CACHE PATH "Path to a file.")
        endif(KEA_LIBRARY)
        set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    endif()
endif(APPLE)

# file locations
find_path(KEA_INCLUDE_DIR
          NAMES KEACommon.h kea-config.h
          SUFFIX_PATHS libkea
)
find_library(KEA_LIBRARY NAMES kea)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(KEA FOUND_VAR KEA_FOUND
                                  REQUIRED_VARS KEA_LIBRARY KEA_INCLUDE_DIR)
