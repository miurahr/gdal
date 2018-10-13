# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru,
# *			Hiroshi Miura <miurahr@linux.com>
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

find_package(PythonInterp REQUIRED)
find_package(PythonLibs REQUIRED)
include(GdalSwigBindings)

INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_DIRS})
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/osgeo/)

GDAL_SWIG_BINDINGS(
        BINDING python
        ARGS -I${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs -threads -outdir ${CMAKE_CURRENT_BINARY_DIR}/osgeo
        OUTPUT
            ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdal.py
            ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdalconst.py
            ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdalnumeric.py
            ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gnm.py
            ${CMAKE_CURRENT_BINARY_DIR}/osgeo/ogr.py
            ${CMAKE_CURRENT_BINARY_DIR}/osgeo/osr.py
)

# for gdal_array_wrap.cpp
set(ARRAY_INPUT  ${CMAKE_SOURCE_DIR}/gdal/swig/include/gdal_array.i )
set(ARRAY_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/extensions/gdal_array_wrap.cpp )
set(GDAL_SWIG_DEPENDS
        ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/typemaps_python.i
)
set(SWIG_ARGS -Wall  -I${GDAL_ROOT_SOURCE_DIR}/swig/include
            -I${CMAKE_SOURCE_DIR}/gdal/swig/include/python -I${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs
            -threads -outdir ${CMAKE_CURRENT_BINARY_DIR}/osgeo)
add_custom_command(
    OUTPUT  ${ARRAY_OUTPUT}
    COMMAND ${SWIG_EXECUTABLE} ${SWIG_ARGS} ${SWIG_DEFINES} -I${CMAKE_SOURCE_DIR}/gdal -c++ -python -o ${ARRAY_OUTPUT} ${ARRAY_INPUT}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/gdal/swig/${binding}
    DEPENDS ${GDAL_SWIG_COMMON_INCLUDE} ${GDAL_SWIG_DEPENDS} ${ARRAY_INPUT}
)
add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/osgeo/__init__.py
         COMMAND ${CMAKE_COMMAND} -E copy
            ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/__init__.py
            ${CMAKE_CURRENT_BINARY_DIR}/osgeo/
)

set(PY_SUFFIX so)
if(WIN32 AND NOT CYGWIN)
    set(PY_SUFFIX pyd)
    add_definitions(-D__MSVCRT_VERSION__=0x0601)
endif()

macro(py_ext name source)
    add_library(${name} SHARED extensions/${source})
    set_target_properties(${name} PROPERTIES PREFIX ""
                          DEPENS ${GDAL_SWIG_OUTPUT} ${ARRAY_OUTPUT})
    gdal_standard_includes(${name})
    target_include_directories(${name} PRIVATE
                               $<TARGET_PROPERTY:appslib,SOURCE_DIR>
                               $<TARGET_PROPERTY:gnm,SOURCE_DIR>
                               )
    if(WIN32 AND NOT CYGWIN)
        set_target_properties(${name} PROPERTIES SUFFIX ".pyd")
        target_link_libraries(${name} PRIVATE "-L${PYTHON_LIBRARIES}/libs/" "-lpython27")
    endif()
    target_link_libraries(${name} PRIVATE gdal)
    add_custom_command(
            OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/osgeo/${name}.${PY_SUFFIX}
            COMMAND ${CMAKE_COMMAND} -E copy
               ${name}.${PY_SUFFIX} osgeo/
            DEPENDS ${name}
    )
endmacro()

py_ext(_gdal gdal_wrap.cpp)
py_ext(_gdal_array gdal_array_wrap.cpp)
py_ext(_gdalconst gdalconst_wrap.c)
py_ext(_gnm gnm_wrap.cpp)
py_ext(_ogr ogr_wrap.cpp)
py_ext(_osr osr_wrap.cpp)

add_custom_target(python_binding ALL
                  DEPENDS osgeo/_gdal.${PY_SUFFIX} osgeo/_gdal_array.${PY_SUFFIX} osgeo/_gdalconst.${PY_SUFFIX}
                          osgeo/_gnm.${PY_SUFFIX} osgeo/_ogr.${PY_SUFFIX} osgeo/_osr.${PY_SUFFIX}
                          osgeo/__init__.py)
