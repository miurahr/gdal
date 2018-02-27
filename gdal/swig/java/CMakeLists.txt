# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru,
# *			Hiroshi Miura <miurahr@linux.com>
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


FIND_PACKAGE(SWIG REQUIRED)
find_package(JNI REQUIRED)

include_directories(${JNI_INCLUDE_DIRS})
include_directories(${GDAL_ROOT_SOURCE_DIR}/alg)
include_directories(${GDAL_ROOT_SOURCE_DIR}/gcore)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts)
include_directories(${GDAL_ROOT_SOURCE_DIR}/apps)
include_directories(${GDAL_ROOT_SOURCE_DIR}/gnm)
include_directories(${GDAL_ROOT_BINARY_DIR}/swig/java/)

file(MAKE_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal)
file(MAKE_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/gdal)
file(MAKE_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/gdalconst)
file(MAKE_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/ogr)
file(MAKE_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/osr)
file(MAKE_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/gnm)

include(MacroSwigBindings)
set(SWIG_ARGS1 -Wall -I${GDAL_ROOT_SOURCE_DIR}/swig/include -I${GDAL_ROOT_SOURCE_DIR}/swig/include/java)
set(SWIG_ARGS2 -outdir ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/gdalconst/ -package "org.gdal.gdalconst" )

# for gdalconst.i
set(SWIG_OUTPUT ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/gdalconst/gdalconst_wrap.c )
set(SWIG_INPUT  ${GDAL_ROOT_SOURCE_DIR}/swig/include/gdalconst.i )
set(GDAL_SWIG_DEPENDS
        ${GDAL_ROOT_SOURCE_DIR}/swig/include/java/typemaps_java.i
)
add_custom_command(
    OUTPUT  ${SWIG_OUTPUT}
    COMMAND ${SWIG_EXECUTABLE} ${SWIG_ARGS1} ${SWIG_ARGS2} ${SWIG_DEFINES} -java -o ${SWIG_OUTPUT} ${SWIG_INPUT}
    WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}/swig/java/
    DEPENDS ${GDAL_SWIG_COMMON_INCLUDE} ${GDAL_SWIG_DEPENDS} ${SWIG_INPUT}
)
set_source_files_properties(${SWIG_OUTPUT} PROPERTIES GENERATED 1)

set(SWIG_ARGS2 -outdir ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/gdal/ -package "org.gdal.gdal" )
MACRO_SWIG_JAVA_BINDINGS(gdal SWIG_ARGS1 SWIG_ARGS2)

set(SWIG_ARGS2 -outdir ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/ogr/ -package "org.gdal.ogr" )
MACRO_SWIG_JAVA_BINDINGS(ogr  SWIG_ARGS1 SWIG_ARGS2)

set(SWIG_ARGS2 -outdir ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/osr/ -package "org.gdal.osr" )
MACRO_SWIG_JAVA_BINDINGS(osr  SWIG_ARGS1 SWIG_ARGS2)

set(SWIG_ARGS2 -outdir ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/gnm/ -package "org.gdal.gnm" )
MACRO_SWIG_JAVA_BINDINGS(gnm  SWIG_ARGS1 SWIG_ARGS2)

add_library(gdaljni MODULE
            ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/gdal/gdal_wrap.cpp
            )
add_library(ogrjni MODULE
            ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/ogr/ogr_wrap.cpp
            )
add_library(osrjni MODULE
            ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/osr/osr_wrap.cpp
            )
add_library(gnmjni MODULE
            ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/gnm/gnm_wrap.cpp
)
add_library(gdalconstjni MODULE
            ${GDAL_ROOT_BINARY_DIR}/swig/java/org/gdal/gdalconst/gdalconst_wrap.c
            )
add_custom_target(java_binding
                  DEPENDS
                      gdaljni ogrjni osrjni gnmjni gdalconstjni
)