# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file COPYING-CMAKE-SCRIPTS or https://cmake.org/licensing for details.

#.rst
# Find QHULL library
# ~~~~~~~~~
#
# Copyright (c) 2017,2018, Hiroshi Miura <miurahr@linux.com>
#
# If it's found it sets QHULL_FOUND to TRUE
# and following variables are set:
#    QHULL_INCLUDE_DIR
#    QHULL_INCLUDE_SUBDIR (qhull/libqhull)
#    QHULL_LIBRARY
#    QHULL_NEWQHULL (TRUE/FALSE)
#
# FIND_PATH and FIND_LIBRARY normally search standard locations
# before the specified paths. To search non-standard paths first,
# FIND_* is invoked first with specified paths and NO_DEFAULT_PATH
# and then again with no specified paths to search the default
# locations. When an earlier FIND_* succeeds, subsequent FIND_*s
# searching for the same item do nothing.

find_path(QHULL_INCLUDE_DIR qhull/libqhull.h)
if(QHULL_INCLUDE_DIR)
    set(QHULL_INCLUDE_SUBDIR "qhull")
else()
    find_path(LIBQHULL_INCLUDE_DIR libqhull/libqhull.h)
    if(LIBQHULL_INCLUDE_DIR)
        set(QHULL_INCLUDE_SUBDIR "libqhull")
    endif()
endif()

find_library(QHULL_LIBRARY NAMES qhull libqhull)
mark_as_advanced(QHULL_INCLUDE_SUBDIR QHULL_INCLUDE_DIR QHULL_LIBRARY)

INCLUDE(CheckLibraryExists)
CHECK_LIBRARY_EXISTS(qhull gqh_new_qhull ${QHULL_LIBRARY} QHULL_NEWQHULL)

# handle the QUIETLY and REQUIRED arguments and set QHULL_FOUND to TRUE if
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(QHULL
    REQUIRED_VARS QHULL_LIBRARY QHULL_INCLUDE_DIR
    VERSION_VAR QHULL_NEWQHULL
)
