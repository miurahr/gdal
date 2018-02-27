# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# *	Author:	Hiroshi Miura <miurahr@linux.com>
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
find_package(PHP REQUIRED)

include_directories(${PHP_INCLUDE_DIRS})
include_directories(${GDAL_ROOT_SOURCE_DIR}/alg)
include_directories(${GDAL_ROOT_SOURCE_DIR}/gcore)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr)
include_directories(${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts)
include_directories(${GDAL_ROOT_SOURCE_DIR}/apps)
include_directories(${GDAL_ROOT_SOURCE_DIR}/gnm)
include_directories(${GDAL_ROOT_BINARY_DIR}/swig/php/)

file(MAKE_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/php/)

set(SWIG_ARGS -prefix "gdal::" -outdir ${GDAL_ROOT_BINARY_DIR}/swig/php )
set(GDAL_SWIG_OUTPUT
        ${GDAL_ROOT_BINARY_DIR}/swig/php/gdal.php
        ${GDAL_ROOT_BINARY_DIR}/swig/php/gdalconst.php
        ${GDAL_ROOT_BINARY_DIR}/swig/php/gnm.php
        ${GDAL_ROOT_BINARY_DIR}/swig/php/ogr.php
        ${GDAL_ROOT_BINARY_DIR}/swig/php/osr.php
)
include(MacroSwigBindings)
MACRO_SWIG_BINDINGS(php SWIG_ARGS GDAL_SWIG_OUTPUT)

add_library(php_gdal MODULE
            ${GDAL_ROOT_BINARY_DIR}/swig/php/extensions/gdal_wrap.cpp
            )
add_library(php_gdalconst MODULE
            ${GDAL_ROOT_BINARY_DIR}/swig/php/extensions/gdalconst_wrap.c
            )
add_library(php_gnm MODULE
            ${GDAL_ROOT_BINARY_DIR}/swig/php/extensions/gnm_wrap.cpp
            )
add_library(php_ogr MODULE
            ${GDAL_ROOT_BINARY_DIR}/swig/php/extensions/ogr_wrap.cpp
            )
add_library(php_osr MODULE
            ${GDAL_ROOT_BINARY_DIR}/swig/php/extensions/osr_wrap.cpp
            )
add_custom_target(php_binding
                  DEPENDS
                  php_gdal php_gnm php_ogr php_osr php_gdalconst
                  )
