# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# Find Epsilon library
# ~~~~~~~~~~~~~~~~~~~~
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
#
# ::
#
# If it's found it sets EPSILON_FOUND to TRUE
# and following variables are set:
#    EPSILON_INCLUDE_DIR
#    EPSILON_LIBRARY

find_path(EPSILON_INCLUDE_DIR NAMES epsilon.h
          DOC "Path to EPSILON headers")
find_library(EPSILON_LIBRARY NAMES epsilon
             DOC "Path to EPSILON library")
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(EPSILON
                                  REQUIRED_VARS EPSILON_LIBRARY EPSILON_INCLUDE_DIR)
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
