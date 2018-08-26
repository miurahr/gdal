# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# *	Author:	Hiroshi Miura
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

find_package(PHP REQUIRED)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
include(GdalSwigBindings)
gdal_swig_bindings(
        TARGET php
        ARGS -prefix "gdal::" -outdir ${CMAKE_CURRENT_BINARY_DIR}
        OUTPUT
            ${CMAKE_CURRENT_BINARY_DIR}/gdal.php
            ${CMAKE_CURRENT_BINARY_DIR}/gdalconst.php
            ${CMAKE_CURRENT_BINARY_DIR}/gnm.php
            ${CMAKE_CURRENT_BINARY_DIR}/ogr.php
            ${CMAKE_CURRENT_BINARY_DIR}/osr.php
)

foreach(tgt IN ITEMS php_gdalconst php_gdal php_gnm php_ogr php_osr)
    if(tgt STREQUAL php_gdalconst)
        add_library(${tgt} MODULE ${CMAKE_CURRENT_BINARY_DIR}/extensions/${tgt}_wrap.c)
    else()
        add_library(${tgt} MODULE ${CMAKE_CURRENT_BINARY_DIR}/extensions/${tgt}_wrap.cpp)
    endif()
    gdal_standard_includes(${tgt})
    target_include_directories(${tgt} PRIVATE ${PHP_INCLUDE_DIRS})
    target_include_directories(${tgt} PRIVATE $<TARGET_PROPERTY:appslib,SOURCE_DIR>)
    target_include_directories(${tgt} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
endforeach()
add_custom_target(php_binding ALL
                  DEPENDS
                  php_gdal php_gnm php_ogr php_osr php_gdalconst
                  )
