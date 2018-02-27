# Find Libkml
# ~~~~~~~~~
# Copyright (c) 2012, Dmitry Baryshnikov <polimax at mail.ru>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# CMake module to search for Libkml library
# cache vars
#    LIBKML_INCLUDE_DIR
#    LIBKML_BASE_LIBRARY
#    LIBKML_DOM_LIBRARY
#    LIBKML_ENGINE_LIBRARY
#    LIBKML_CONVENIENCE_LIBRARY
#    LIBKML_XSD_LIBRARY
#
# If it's found it sets LIBKML_FOUND to TRUE
# and following result variables are set:
#    LIBKML_INCLUDE_DIRS
#    LIBKML_LIBRARIES
#

# FIND_PATH and FIND_LIBRARY normally search standard locations
# before the specified paths. To search non-standard paths first,
# FIND_* is invoked first with specified paths and NO_DEFAULT_PATH
# and then again with no specified paths to search the default
# locations. When an earlier FIND_* succeeds, subsequent FIND_*s
# searching for the same item do nothing. 

# try to use framework on mac
# want clean framework path, not unix compatibility path
IF (APPLE)
    IF (CMAKE_FIND_FRAMEWORK MATCHES "FIRST"
            OR CMAKE_FRAMEWORK_PATH MATCHES "ONLY"
            OR NOT CMAKE_FIND_FRAMEWORK)
        SET (CMAKE_FIND_FRAMEWORK_save ${CMAKE_FIND_FRAMEWORK} CACHE STRING "" FORCE)
        SET (CMAKE_FIND_FRAMEWORK "ONLY" CACHE STRING "" FORCE)
        #FIND_PATH(LIBKML_INCLUDE_DIR LIBKML/dom.h)
        FIND_LIBRARY(LIBKML_LIBRARY LIBKML)
        IF (LIBKML_LIBRARY)
            # FIND_PATH doesn't add "Headers" for a framework
            SET (LIBKML_INCLUDE_DIR ${LIBKML_LIBRARY}/Headers CACHE PATH "Path to a file.")
        ENDIF (LIBKML_LIBRARY)
        SET (CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
    ENDIF ()
ENDIF (APPLE)

FIND_PACKAGE(PkgConfig QUIET)
IF(PKG_CONFIG_FOUND)
    # try using pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    PKG_CHECK_MODULES(PC_LIBKML QUIET libkml)
ENDIF()

FIND_PATH(LIBKML_INCLUDE_DIR
          NAMES kml/engine.h kml/dom.h
          HINTS ${PC_LIBKML_INCLUDE_DIRS}
        )
FIND_LIBRARY(LIBKML_BASE_LIBRARY
             NAMES kmlbase libkmlbase
             HINTS ${PC_LIBKML_LIBRARY_DIRS}
        )
FIND_LIBRARY(LIBKML_DOM_LIBRARY
             NAMES kmldom libkmldom
             HINTS ${PC_LIBKML_LIBRARY_DIRS}
        )
FIND_LIBRARY(LIBKML_CONVENIENCE_LIBRARY
             NAMES kmlconvenience libkmlconvenience
             HINTS ${PC_LIBKML_LIBRARY_DIRS}
        )
FIND_LIBRARY(LIBKML_ENGINE_LIBRARY
             NAMES kmlengine libkmlengine
             HINTS ${PC_LIBKML_LIBRARY_DIRS}
        )
FIND_LIBRARY(LIBKML_REGIONATOR_LIBRARY
             NAMES kmlregionator libkmlregionator
             HINTS ${PC_LIBKML_LIBRARY_DIRS}
        )
mark_as_advanced(LIBKML_INCLUDE_DIR
            LIBKML_BASE_LIBRARY LIBKML_CONVENIENCE_LIBRARY LIBKML_DOM_LIBRARY
            LIBKML_ENGINE_LIBRARY LIBKML_REGIONATOR_LIBRARY
        )

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIBKML FOUND_VAR LIBKML_FOUND
                                  REQUIRED_VARS LIBKML_INCLUDE_DIR
                                        LIBKML_BASE_LIBRARY LIBKML_CONVENIENCE_LIBRARY LIBKML_DOM_LIBRARY
                                        LIBKML_ENGINE_LIBRARY LIBKML_REGIONATOR_LIBRARY
                                  )

if(LIBKML_FOUND)
    set(LIBKML_LIBRARIES ${LIBKML_DOM_LIBRARY} ${LIBKML_ENGINE_LIBRARY} ${LIBKML_BASE_LIBRARY}
            ${LIBKML_CONVENIENCE_LIBRARY} ${LIBKML_REGIONATOR_LIBRARY})
    set(LIBKML_INCLUDE_DIRS ${LIBKML_INLCUDE_DIR})
endif()
