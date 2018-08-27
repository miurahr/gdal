# Find DAP - Data Access Protocol library
# ~~~~~~~~~
#
# Copyright (c) 2017, Hiroshi Miura <miurahr@linux.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# If it's found it sets DAP_FOUND to TRUE
# and following variables are set:
#    DAP_INCLUDE_DIR
#    DAP_LIBRARY
#    DAP_CLIENT_LIBRARY
#    DAP_SERVER_LIBRARY
#    DAP_VERSION
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
        find_library(DAP_LIBRARY DAP)
        find_library(DAP_CLIENT_LIBRARY DAPCLIENT)
        find_library(DAP_SERVER_LIBRARY DAPSERVER)
        if(DAP_LIBRARY)
            # FIND_PATH doesn't add "Headers" for a framework
            SET (DAP_INCLUDE_DIR ${DAP_LIBRARY}/Headers CACHE PATH "Path to a file.")
        endif(DAP_LIBRARY)
        set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    endif()
endif(APPLE)

FIND_PACKAGE(PkgConfig QUIET)
IF(PKG_CONFIG_FOUND)
    # try using pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    PKG_CHECK_MODULES(PC_DAP QUIET libdap)
ENDIF()

find_path(DAP_INCLUDE_DIR
        NAMES DapObj.h
        HINTS ${PC_DAP_INCLUDE_DIRS}
)

find_library(DAP_LIBRARY
        NAMES dap
        HINTS ${PC_DAP_LIBRARY_DIRS}
)

find_library(DAP_CLIENT_LIBRARY
        NAMES dapclient
        HINTS ${PC_DAP_LIBRARY_DIRS}
)

find_library(DAP_SERVER_LIBRARY
        NAMES dapserver
        HINTS ${PC_DAP_LIBRARY_DIRS}
)
MARK_AS_ADVANCED(DAP_INCLUDE_DIR DAP_LIBRARY DAP_CLIENT_LIBRARY DAP_SERVER_LIBRARY)

if(DAP_INCLUDE_DIR AND DAP_LIBRARY)
    set(DAP_CONFIG_EXE dap-config)
    execute_process(COMMAND ${DAP_CONFIG_EXE} --version
           OUTPUT_VARIABLE DAP_VERSION
           OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif()

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(DAP DEFAULT_MSG DAP_LIBRARY DAP_CLIENT_LIBRARY DAP_SERVER_LIBRARY DAP_INCLUDE_DIR)

if(DAP_FOUND)
    set(DAP_INCLUDE_DIRS ${DAP_INCLUDE_DIR})
    set(DAP_LIBRARIES ${DAP_LIBRARY} ${DAP_CLIENT_LIBRARY} ${DAP_SERVER_LIBRARY})

    if(NOT TARGET DAP::DAP)
        if(DAP_INCLUDE_DIR)
            add_library(DAP::DAP UNKNOWN IMPORTED)
            set_target_properties(DAP::DAP PROPERTIES
                                  INTERFACE_INCLUDE_DIRECTORIES ${DAP_INCLUDE_DIR})
            if(EXISTS "${DAP_LIBRARY}")
                set_target_properties(DAP::DAP PROPERTIES
                                      IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                                      IMPORTED_LOCATION "${DAP_LIBRARY}")
            endif()
        endif()
        if(EXISTS "${DAP_CLIENT_LIBRARY}")
            add_library(DAP::CLIENT UNKNOWN IMPORTED)
            set_target_properties(DAP::CLIENT PROPERTIES
                                  IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                                  IMPORTED_LOCATION "${DAP_CLIENT_LIBRARY}")
        endif()
        if(EXISTS "${DAP_SERVER_LIBRARY}")
            add_library(DAP::SERVER UNKNOWN IMPORTED)
            set_target_properties(DAP::SERVER PROPERTIES
                                  IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                                  IMPORTED_LOCATION "${DAP_SERVER_LIBRARY}")
        endif()
    endif()
endif(DAP_FOUND)

