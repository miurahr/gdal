# Find OGDI - Open Geographic Datastore Interface Library
# ~~~~~~~~~
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# If it's found it sets OGDI_FOUND to TRUE
# and following variables are set:
#    OGDI_INCLUDE_DIRS
#    OGDI_LIBRARIES
#    OGDI_VERSION
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
        find_library(OGDI_LIBRARY OGDI)
        if(OGDI_LIBRARY)
            # FIND_PATH doesn't add "Headers" for a framework
            SET (OGDI_INCLUDE_DIR ${DAP_LIBRARY}/Headers CACHE PATH "Path to a file.")
        endif(OGDI_LIBRARY)
        set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    endif()
endif(APPLE)

find_path(OGDI_INCLUDE_DIR ecs.h PATH_SUFFIX ogdi)
find_library(OGDI_LIBRARY NAMES ogdi libogdi vpf libvpf)

if(OGDI_INCLUDE_DIR AND OGDI_LIBRARY)
    find_program(OGDI_CONFIG_EXE ogdi-config)
    execute_process(COMMAND ${OGDI_CONFIG_EXE} --version
            OUTPUT_VARIABLE OGDI_VERSION
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif(OGDI_INCLUDE_DIR AND OGDI_LIBRARY)

# handle the QUIETLY and REQUIRED arguments and set OGDI_FOUND to TRUE if
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(OGDI
    REQUIRED_VARS OGDI_LIBRARY OGDI_INCLUDE_DIR
    VERSION_VAR OGDI_VERSION
)

if(OGDI_FOUND)
    set(OGDI_LIBRARIES ${OGDI_LIBRARY})
    set(OGDI_INCLUDE_DIRS ${OGDI_INCLUDE_DIR})
    if(NOT TARGET OGDI::OGDI)
        add_library(OGDI::OGDI UNKNOWN IMPORTED)
        set_target_properties(OGDI::OGDI PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${OGDI_INCLUDE_DIR}")
        set_property(TARGET OGDI::OGDI APPEND PROPERTY IMPORTED_LOCATION "${OGDI_LIBRARY}")
    endif()
endif()