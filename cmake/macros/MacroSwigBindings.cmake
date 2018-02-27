# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author:   Hiroshi Miura <miurahr@linux.com>
# ******************************************************************************
# * Copyright (C) 2017 Hiroshi Miura
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

set(SWIG_COMMON_INCLUDES
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/Band.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/ColorTable.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/cpl.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/cpl_exceptions.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/Dataset.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/Driver.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/gdal.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/gdal_array.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/gdal_typemaps.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/gnm.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/MajorObject.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/ogr.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/ogr_error_map.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/Operations.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/osr.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/RasterAttributeTable.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/Transform.i
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/XMLNode.i
)

macro(MACRO_SWIG_BINDINGS binding _args _output)
    file(MAKE_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions )
    find_package(SWIG REQUIRED)
    set(SWIG_ARGS -Wall ${${_args}} -I${GDAL_ROOT_SOURCE_DIR}/swig/include -I${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding})

    # for gdalconst.i
    set(SWIG_OUTPUT ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/gdalconst_wrap.c )
    set(SWIG_INPUT  ${GDAL_ROOT_SOURCE_DIR}/swig/include/gdalconst.i )
    set(GDAL_SWIG_DEPENDS
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding}/typemaps_${binding}.i
    )
    list(LENGTH ${_output} OLEN)
    if(OLEN EQUAL 0)
         add_custom_command(
            OUTPUT  ${SWIG_OUTPUT}
            COMMAND ${SWIG_EXECUTABLE} ${SWIG_ARGS} ${SWIG_DEFINES} -${binding} -o ${SWIG_OUTPUT} ${SWIG_INPUT}
            WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}/swig/${binding}/
            DEPENDS ${GDAL_SWIG_COMMON_INCLUDE} ${GDAL_SWIG_DEPENDS} ${SWIG_INPUT}
        )
        set_source_files_properties(${SWIG_OUTPUT} PROPERTIES GENERATED 1)
    else()
         add_custom_command(
            OUTPUT  ${SWIG_OUTPUT} ${${_output}}
            COMMAND ${SWIG_EXECUTABLE} ${SWIG_ARGS} ${SWIG_DEFINES} -${binding} -o ${SWIG_OUTPUT} ${SWIG_INPUT}
            WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}/swig/${binding}/
            DEPENDS ${GDAL_SWIG_COMMON_INCLUDE} ${GDAL_SWIG_DEPENDS} ${SWIG_INPUT}
        )
        set_source_files_properties(${SWIG_OUTPUT} PROPERTIES GENERATED 1)
        set_source_files_properties(${${_output}} PROPERTIES GENERATED 1)
    endif()

    # other wrappers
    _MACRO_SWIG_BINDINGS(${binding} gdal SWIG_ARGS)
    _MACRO_SWIG_BINDINGS(${binding} ogr  SWIG_ARGS)
    _MACRO_SWIG_BINDINGS(${binding} osr  SWIG_ARGS)
    _MACRO_SWIG_BINDINGS(${binding} gnm  SWIG_ARGS)
    add_custom_target(gdal_${binding}_wrappers
            DEPENDS
                ${SWIG_COMMON_INCLUDES}
                ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/gdalconst_wrap.c
                ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/gdal_wrap.cpp
                ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/ogr_wrap.cpp
                ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/osr_wrap.cpp
                ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/gnm_wrap.cpp
            )
endmacro()

macro(_MACRO_SWIG_BINDINGS binding target _args)
    set(SWIG_OUTPUT ${GDAL_ROOT_BINARY_DIR}/swig/${binding}/extensions/${target}_wrap.cpp)
    set(SWIG_INPUT  ${GDAL_ROOT_SOURCE_DIR}/swig/include/${target}.i)
    set(GDAL_SWIG_DEPENDS
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding}/typemaps_${binding}.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/${binding}/${target}_${binding}.i
    )
    add_custom_command(
        OUTPUT  ${SWIG_OUTPUT}
        COMMAND ${SWIG_EXECUTABLE} ${${_args}} ${SWIG_DEFINES} -I${GDAL_ROOT_SOURCE_DIR} -c++ -${binding} -o ${SWIG_OUTPUT} ${SWIG_INPUT}
        WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}/swig/${binding}
        DEPENDS ${GDAL_SWIG_COMMON_INCLUDE} ${GDAL_SWIG_DEPENDS}
    )
    set_source_files_properties(${SWIG_OUTPUT} PROPERTIES GENERATED 1)
endmacro()

macro(MACRO_SWIG_JAVA_BINDINGS target _args1 _args2)
    set(SWIG_OUTPUT ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/${target}/${target}_wrap.cpp)
    set(SWIG_INPUT  ${GDAL_ROOT_SOURCE_DIR}/swig/include/${target}.i)
    set(GDAL_SWIG_DEPENDS
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/java/typemaps_java.i
            ${GDAL_ROOT_SOURCE_DIR}/swig/include/java/${target}_java.i
    )
    add_custom_command(
        OUTPUT  ${SWIG_OUTPUT}
        COMMAND ${SWIG_EXECUTABLE} ${${_args1}} ${${_args2}} ${SWIG_DEFINES} -I${GDAL_ROOT_SOURCE_DIR} -c++ -java -o ${SWIG_OUTPUT} ${SWIG_INPUT}
        WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}/swig/java
        DEPENDS ${GDAL_SWIG_COMMON_INCLUDE} ${GDAL_SWIG_DEPENDS}
    )
    set_source_files_properties(${SWIG_OUTPUT} PROPERTIES GENERATED 1)
endmacro()

