# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Hiroshi Miura, Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru
# ******************************************************************************
# * Copyright (C) 2017,2018 Hiroshi Miura
# *
# * Permission is hereby granted, free of charge, to any person obtaining a
# * copy of this software and associated documentation files (the "Software"),
# * to deal in the Software without restriction, including without limitation
# * the rights to use, copy, modify, merge, publish, distribute, sublicense,
# * and/or sell copies of the Software, and to permit persons to whom the
# * Software is furnished to do so, subject to the following conditions:
# *
# * The above copyright notice and this permission notice shall be included
# * in all copies or substantial portions of the Software.
# *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# * DEALINGS IN THE SOFTWARE.
# ******************************************************************************
#
#  Symptoms ADD_GDAL_DRIVER( TARGET <target_name>
#                            [SOURCES <source file> [<source file>[...]]]
#                            [BUILTIN]
#                          )
#           GDAL_STANDARD_INCLUDES(<target_name>)
#           GDAL_TARGET_LINK_LIBRARIES(TARGET <target_name> LIBRARIES <library> [<library2> [..]])
#
#
#  Symptoms GDAL_DRIVER( TARGET <target_name>
#                        [SOURCES <source file> [<source file>[...]]]
#                        [INCLUDES <include_dir> [<include dir2> [...]]]
#                        [LIBRARIES <library1> [<library2> [...]][
#                        [DEFINITIONS -DFOO=1 [-DBOO [...]]]
#                        [FORCE_BUILTIN]
#          )
#
#  All driver which is not specify 'BUILTIN' beocmes PLUGIN when
#  configuration GDAL_ENABLE_PLUGIN = true.
#
#  There aree several examples to show how to write build cmake script.
#
# ex.1  Driver which is depend on some external libraries
#       These definitions are detected in cmake/macro/CheckDependentLibraries.cmake
#       If you cannot find your favorite library in the macro, please add it to
#       CheckDependentLibraries.cmake.
#
#   GDAL_DRIVER(TARGET    gdal_WEBP
#               SOURCES   gdal_webp.c gdal_webp.h
#               INCLUDES  ${WEBP_INCLUDE_DIRS} ${TIFF_INCLUDE_DIRS}
#               LIBRARIES ${WEBP_LIBRARIES} ${TIFF_LIBRARIES})
#
#
# ex.2  Driver which is depend on internal bundled thirdparty libraries
#       To refer thirdparty library dev files, pls use '$<BUILD_INTERFACE:(path)>'
#       and '$<TARGET_LINKER_FILE:(name)>' cmake directive.
#       You may use 'IF(GDAL_USE_SOME_LIBRARY_INTERNAL)...ELSE()...ENDIF()' cmake directive too.
#
#   GDAL_DRIVER(TARGET gdal_CALS
#               SOURCES calsdataset.cpp
#               INCLUDES $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/gtiff/libtiff>
#               LIBRARIES $<TARGET_LINKER_FILE:gdal_libtiff>
#
# ex.3 Driver which is referrenced by other drivers
#      Such driver should built-in into library to resolve reference.
#      Please use 'FORCE_BUILTIN' option keyword which indicate to link it into libgdal.so.
#
#   add_gdal_driver(TARGET gdal_iso8211 SOURCES iso8211.cpp BUILTIN)
#
# ex.4 Driver that refer other driver as dependency
#      Please do not specify LIBRARIES for linking target for other driver,
#      That should be bulit into libgdal.
#
#   add_gdal_driver(TARGET gdal_ADRG SOURCES foo.cpp)
#   target_include_directories(gdal_ADRG PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/iso8211>)
#
macro(GDAL_DRIVER)
    set(_options FORCE_BUILTIN)
    set(_oneValueArgs TARGET)
    set(_multiValueArgs SOURCES INCLUDES LIBRARIES DEFINITIONS)
    cmake_parse_arguments(_DRIVER "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
    if(NOT _DRIVER_TARGET)
        message(FATAL_ERROR "GDAL_DRIVER(): TARGET is a mandatory argument.")
    endif()
    if(NOT _DRIVER_SOURCES)
        message(FATAL_ERROR "GDAL_DRIVER(): SOURCES is a mandatory argument.")
    endif()
    if(_DRIVER_FORCE_BUILTIN)
        ADD_GDAL_DRIVER(TARGET ${_DRIVER_TARGET} SOURCES ${_DRIVER_SOURCES} BUILTIN)
    else()
        ADD_GDAL_DRIVER(TARGET ${_DRIVER_TARGET} SOURCES ${_DRIVER_SOURCES})
    endif()
    gdal_driver_standard_includes(${_DRIVER_TARGET})
    if(_DRIVER_INCLUDES)
        target_include_directories(${_DRIVER_TARGET} PRIVATE ${_DRIVER_INCLUDES})
    endif()
    if(_DRIVER_LIBRARIES)
        GDAL_target_link_libraries(TARGET ${_DRIVER_TARGET} LIBRARIES ${_DRIVER_LIBRARIES})
    endif()
    if(_DRIVER_DEFINITIONS)
        target_compile_definitions(${_DRIVER_TARGET} PRIVATE ${_DRIVER_DEFINITIONS})
    endif()
    unset(_DRIVER_TARGET)
    unset(_DRIVER_SOURCES)
    unset(_DRIVER_INCLUDES)
    unset(_DRIVER_DEFINITIONS)
    unset(_DRIVER_LIBRARIES)
endmacro()

function(ADD_GDAL_DRIVER)
    set(_options BUILTIN)
    set(_oneValueArgs TARGET)
    set(_multiValueArgs SOURCES)
    cmake_parse_arguments(_DRIVER "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
    if(NOT _DRIVER_TARGET)
        message(FATAL_ERROR "ADD_GDAL_DRIVER(): TARGET is a mandatory argument.")
    endif()
    if(NOT _DRIVER_SOURCES)
        message(FATAL_ERROR "ADD_GDAL_DRIVER(): SOURCES is a mandatory argument.")
    endif()
    set(_DRIVER_PLUGIN_BUILD TRUE)
    if(_DRIVER_BUILTIN)
        set(_DRIVER_PLUGIN_BUILD FALSE)
    elseif(GDAL_ENABLE_PLUGIN)
        set(_DRIVER_PLUGIN_BUILD TRUE)
    else()
        set(_DRIVER_PLUGIN_BUILD FALSE)
    endif()
    string(FIND "${_DRIVER_TARGET}" "ogr" IS_OGR)
    if(_DRIVER_PLUGIN_BUILD)
        # target become *.so *.dll or *.dylib
        add_library(${_DRIVER_TARGET} MODULE ${_DRIVER_SOURCES})
        set_target_properties(${_DRIVER_TARGET} PROPERTIES PREFIX "")
        install(FILES $<TARGET_LINKER_FILE:${_DRIVER_TARGET}> DESTINATION ${INSTALL_PLUGIN_DIR}
                RENAME "${_DRIVER_TARGET}${CMAKE_SHARED_LIBRARY_SUFFIX}" NAMELINK_SKIP)
    else()
        add_library(${_DRIVER_TARGET} OBJECT ${_DRIVER_SOURCES})
        target_sources(gdal PUBLIC $<TARGET_OBJECTS:${_DRIVER_TARGET}>)
        if(IS_OGR EQUAL -1) # gdal driver
            string(TOLOWER ${_DRIVER_TARGET} _FORMAT)
            string(REPLACE "gdal" "FRMT" _DEF ${_FORMAT})
            target_compile_definitions(gdalallregister PRIVATE -D${_DEF})
        else() # ogr driver
            string(REPLACE "ogr_" "" _FORMAT ${_DRIVER_TARGET})
            string(TOUPPER ${_FORMAT} _KEY)
            target_compile_definitions(ogralldriverregistrar PRIVATE -D${_KEY}_ENABLED)
        endif()
    endif()
    set_target_properties(${_DRIVER_TARGET} PROPERTIES CXX_STANDARD 11)
endfunction()

function(GDAL_TARGET_LINK_LIBRARIES)
    set(_oneValueArgs TARGET)
    set(_multiValueArgs LIBRARIES)
    cmake_parse_arguments(_DRIVER "" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
    if(NOT _DRIVER_TARGET)
        message(FATAL_ERROR "GDAL_TARGET_LINK_LIBRARIES(): TARGET is a mandatory argument.")
    endif()
    if(NOT _DRIVER_LIBRARIES)
        message(FATAL_ERROR "GDAL_TARGET_LINK_LIBRARIES(): LIBRARIES is a mandatory argument.")
    endif()
    # Detect whether driver is built as PLUGIN or not.
    get_property(_DRIVER_TYPE TARGET ${_DRIVER_TARGET} PROPERTY TYPE)
    if(${_DRIVER_TYPE} EQUAL MODULE_LIBRARY)
        target_link_libraries(${_DRIVER_TARGET} PRIVATE ${_DRIVER_LIBRARIES})
    else()
        target_link_libraries(gdal INTERFACE ${_DRIVER_LIBRARIES})
    endif()
endfunction()

include(GdalStandardIncludes)
macro(GDAL_DRIVER_STANDARD_INCLUDES _TARGET)
    gdal_standard_includes(${_TARGET})
endmacro()

#
#  Macro for including  driver directories.
#  Following macro should use only in the directories:
#
#  gdal/ogr/ogrsf_frmts/
#  gdal/frmts/
#

include(CMakeDependentOption)

# GDAL_DEPENDENT_FORMAT(format desc depend) do followings:
# - add subdirectory 'format'
# - define option "GDAL_ENABLE_FRMT_NAME" then set to default OFF/ON
# - when enabled, add definition"-DFRMT_format"
# - when dependency specified by depend fails, force OFF
macro(GDAL_DEPENDENT_FORMAT format desc depends)
    string(TOUPPER ${format} key)
    CMAKE_DEPENDENT_OPTION(GDAL_ENABLE_FRMT_${key} "Set ON to build ${desc} format" ON
                           "${depends}" OFF)
    if(GDAL_ENABLE_FRMT_${key})
        set(GDAL_FORMATS ${GDAL_FORMATS} ${format})
        add_subdirectory(${format})
    endif()
endmacro()

macro(gdal_format format)
    string(TOUPPER ${format} key)
    set(GDAL_ENABLE_FRMT_${key} ON CACHE BOOL "" FORCE)
    add_subdirectory(${format})
    set(GDAL_FORMATS ${GDAL_FORMATS} ${format})
endmacro()

macro(gdal_optional_format format desc)
    string(TOUPPER ${format} key)
    option(GDAL_ENABLE_FRMT_${key} "Set ON to build ${desc} format" OFF)
    if(GDAL_ENABLE_FRMT_${key})
        set(GDAL_FORMATS ${GDAL_FORMATS} ${format})
        add_subdirectory(${format})
    endif()
endmacro()

# OGR_DEPENDENT_DRIVER(NAME desc depend) do followings:
# - define option "OGR_ENABLE_<name>" with default OFF
# - add subdirectory 'name'
# - when dependency specified by depend fails, force OFF

macro(OGR_DEPENDENT_DRIVER name desc depend)
    string(TOUPPER ${name} key)
    CMAKE_DEPENDENT_OPTION(OGR_ENABLE_${key} "Set ON to build OGR ${desc} driver" ON
                           "${depend}" OFF)
    if (OGR_ENABLE_${key})
        set(GDAL_FORMATS ${GDAL_FORMATS} ${name})
        add_subdirectory(${name})
    endif()
endmacro()

# OGR_OPTIONAL_DRIVER(name desc) do followings:
# - define option "OGR_ENABLE_<name>" with default OFF
# - add subdirectory 'name' when enabled
macro(OGR_OPTIONAL_DRIVER name desc)
    string(TOUPPER ${name} key)
    option(OGR_ENABLE_${key} "Set ON to build OGR ${desc} driver" OFF)
    if (OGR_ENABLE_${key})
        set(GDAL_FORMATS ${GDAL_FORMATS} ${name})
        add_subdirectory(${name})
    endif()
endmacro()

# OGR_DEFAULT_DRIVER(name desc)
# - set "OGR_ENABLE_<name>" is ON but configurable.
# - add subdirectory "name"
macro(OGR_DEFAULT_DRIVER name desc)
    string(TOUPPER ${name} key)
    set(OGR_ENABLE_${key} ON CACHE BOOL "${desc}" FORCE)
    set(GDAL_FORMATS ${GDAL_FORMATS} ${name})
    add_subdirectory(${name})
endmacro()
