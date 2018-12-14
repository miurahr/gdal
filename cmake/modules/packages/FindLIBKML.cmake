# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file COPYING-CMAKE-SCRIPTS or https://cmake.org/licensing for details.

#.rst
# Find Libkml
# ~~~~~~~~~
# Copyright (c) 2012, Dmitry Baryshnikov <polimax at mail.ru>
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

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_LIBKML QUIET libkml)
endif()

find_path(LIBKML_INCLUDE_DIR
          NAMES kml/engine.h kml/dom.h
          HINTS ${PC_LIBKML_INCLUDE_DIRS}
        )
find_library(LIBKML_BASE_LIBRARY
             NAMES kmlbase libkmlbase
             HINTS ${PC_LIBKML_LIBRARY_DIRS}
        )
find_library(LIBKML_DOM_LIBRARY
             NAMES kmldom libkmldom
             HINTS ${PC_LIBKML_LIBRARY_DIRS}
        )
find_library(LIBKML_CONVENIENCE_LIBRARY
             NAMES kmlconvenience libkmlconvenience
             HINTS ${PC_LIBKML_LIBRARY_DIRS}
        )
find_library(LIBKML_ENGINE_LIBRARY
             NAMES kmlengine libkmlengine
             HINTS ${PC_LIBKML_LIBRARY_DIRS}
        )
find_library(LIBKML_REGIONATOR_LIBRARY
             NAMES kmlregionator libkmlregionator
             HINTS ${PC_LIBKML_LIBRARY_DIRS}
        )
mark_as_advanced(LIBKML_INCLUDE_DIR
            LIBKML_BASE_LIBRARY LIBKML_CONVENIENCE_LIBRARY LIBKML_DOM_LIBRARY
            LIBKML_ENGINE_LIBRARY LIBKML_REGIONATOR_LIBRARY
        )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LIBKML FOUND_VAR LIBKML_FOUND
                                  REQUIRED_VARS
                                        LIBKML_BASE_LIBRARY LIBKML_CONVENIENCE_LIBRARY LIBKML_DOM_LIBRARY
                                        LIBKML_ENGINE_LIBRARY LIBKML_REGIONATOR_LIBRARY
                                        LIBKML_INCLUDE_DIR
                                  )

if(LIBKML_FOUND)
    set(LIBKML_LIBRARIES ${LIBKML_DOM_LIBRARY} ${LIBKML_ENGINE_LIBRARY} ${LIBKML_BASE_LIBRARY}
            ${LIBKML_CONVENIENCE_LIBRARY} ${LIBKML_REGIONATOR_LIBRARY})
    set(LIBKML_INCLUDE_DIRS ${LIBKML_INLCUDE_DIR})
endif()
