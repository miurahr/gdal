# Find json-c
# ~~~~~~~~~
# Copyright (C) 2017, Hiroshi Miura
# Copyright (c) 2012, Dmitry Baryshnikov <polimax at mail.ru>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# CMake module to search for jsonc library
#
# If it's found it sets JSONC_FOUND to TRUE
# and following variables are set:
#    JSONC_INCLUDE_DIR
#    JSONC_LIBRARY

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
    FIND_LIBRARY(JSONC_LIBRARY JSONC)
    IF (JSONC_LIBRARY)
      # FIND_PATH doesn't add "Headers" for a framework
      SET (JSONC_INCLUDE_DIR ${JSONC_LIBRARY}/Headers CACHE PATH "Path to a file.")
    ENDIF (JSONC_LIBRARY)
    SET (CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_save} CACHE STRING "" FORCE)
  ENDIF ()
ENDIF (APPLE)

FIND_PATH(JSONC_INCLUDE_DIR
          NAMES json.h
          HINTS /usr/include /usr/include/json-c)
FIND_LIBRARY(JSONC_LIBRARY NAMES json-c json)
MARK_AS_ADVANCED(JSONC_LIBRARY JSONC_INCLUDE_DIR)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(JSONC DEFAULT_MSG JSONC_LIBRARY JSONC_INCLUDE_DIR)

IF(JSONC_FOUND)
  SET(JSONC_INCLUDE_DIRS ${JSONC_INCLUDE_DIR})
  SET(JSONC_LIBRARIES ${JSONC_LIBRARY})
ENDIF()