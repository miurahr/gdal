# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author:   Hiroshi Miura
# ******************************************************************************
# * Copyright (C) 2018 Hiroshi Miura
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

find_package(SWIG REQUIRED)

function(gdal_swig_bindings)
    set(_options)
    set(_oneValueArgs BINDING)
    set(_multiValueArgs "ARGS;DEPENDS;OUTPUT")
    cmake_parse_arguments(_SWIG "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
    file(MAKE_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/${_SWIG_BINDING}/extensions )
    set(SWIG_ARGS -Wall ${_SWIG_ARGS} -I${GDAL_ROOT_SOURCE_DIR}/swig/include -I${GDAL_ROOT_SOURCE_DIR}/swig/include/${_SWIG_BINDING})
    # for gdalconst.i
    gdal_swig_binding_target(
            TARGET gdalconst
            BINDING ${_SWIG_BINDING}
            ARGS ${SWIG_ARGS}
            DEPENDS ${GDAL_SWIG_COMMON_INTERFACE_FILES}
                    ${_SWIG_DEPENDS}
                    ${GDAL_ROOT_SOURCE_DIR}/swig/include/${_SWIG_BINDING}/typemaps_${_SWIG_BINDING}.i
                    ${GDAL_ROOT_SOURCE_DIR}/swig/include/gdalconst.i
            )
    # for other interfaces
    foreach(tgt IN ITEMS gdal ogr osr gnm)
        gdal_swig_binding_target(
                TARGET ${tgt} CXX
                BINDING ${_SWIG_BINDING}
                ARGS ${SWIG_ARGS}
                DEPENDS ${GDAL_SWIG_COMMON_INTERFACE_FILES}
                    ${_SWIG_DEPENDS}
                    ${GDAL_ROOT_SOURCE_DIR}/swig/include/${_SWIG_BINDING}/typemaps_${_SWIG_BINDING}.i
                    ${GDAL_ROOT_SOURCE_DIR}/swig/include/${tgt}.i
                    ${GDAL_ROOT_SOURCE_DIR}/swig/include/${_SWIG_BINDING}/${tgt}_${_SWIG_BINDING}.i
        )
    endforeach()
endfunction()

# internal function
function(gdal_swig_binding_target)
    set(_options CXX)
    set(_oneValueArgs "TARGET;BINDING")
    set(_multiValueArgs "ARGS;DEPENDS;OUTPUT")
    cmake_parse_arguments(_SWIG "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
    if(_SWIG_CXX)
        set(_OUTPUT ${GDAL_ROOT_BINARY_DIR}/swig/${_SWIG_BINDING}/extensions/${_SWIG_TARGET}_wrap.cpp)
    else()
        set(_OUTPUT ${GDAL_ROOT_BINARY_DIR}/swig/${_SWIG_BINDING}/extensions/${_SWIG_TARGET}_wrap.c)
    endif()
    add_custom_command(
        OUTPUT ${_OUTPUT} ${_SWIG_OUTPUT}
        COMMAND ${SWIG_EXECUTABLE} ${_SWIG_ARGS} ${SWIG_DEFINES} -I${GDAL_ROOT_SOURCE_DIR}
                $<$<BOOL:${_SWIG_CXX}>:-c++> -${_SWIG_BINDING}
                -o ${_OUTPUT}
                ${GDAL_ROOT_SOURCE_DIR}/swig/include/${_SWIG_TARGET}.i
        WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}/swig/${_SWIG_BINDING}
        DEPENDS ${_SWIG_DEPENDS}
    )
    set_source_files_properties(${SWIG_OUTPUT} PROPERTIES GENERATED 1)
 endfunction()
