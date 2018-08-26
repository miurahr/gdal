# Find Epsilon library
# ~~~~~~~~~
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# If it's found it sets EPSILON_FOUND to TRUE
# and following variables are set:
#    EPSILON_INCLUDE_DIR
#    EPSILON_LIBRARY
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
        find_library(EPSILON_LIBRARY EPSILON)
        if(EPSILON_LIBRARY)
            # FIND_PATH doesn't add "Headers" for a framework
            SET (EPSILON_INCLUDE_DIR ${EPSILON_LIBRARY}/Headers CACHE PATH "Path to a file.")
        endif()
        set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    endif()
endif()

find_path(EPSILON_INCLUDE_DIR
        NAMES epsilon.h
        DOC "Path to EPSILON headers")

find_library(EPSILON_LIBRARY
        NAMES epsilon
        DOC "Path to EPSILON library")

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(EPSILON
    REQUIRED_VARS EPSILON_LIBRARY EPSILON_INCLUDE_DIR
)

mark_as_advanced(EPSILON_LIBRARY EPSILON_INCLUDE_DIR)

if(EPSILON_FOUND)
    set(EPSILON_LIBRARIES ${EPSILON_LIBRARY})
    set(EPSILON_INCLUDE_DIRS ${EPSILON_INCLUDE_DIR})

    if (NOT TARGET EPSILON::EPSILON)
        add_library(EPSILON::EPSILON UNKNOWN IMPORTED)
        set_target_properties(EPSILON::EPSILON PROPERTIES
                              INTERFACE_INCLUDE_DIRECTORIES "${EPSILON_INCLUDE_DIR}"
                              IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                              IMPORTED_LOCATION "${EPSILON_LIBRARY}")
    endif()
endif()
