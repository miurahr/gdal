# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru, Hiroshi Miura
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

cmake_minimum_required (VERSION 3.5)
if (POLICY CMP0025)
    cmake_policy(SET CMP0025 NEW)
endif ()
if (POLICY CMP0054)
    cmake_policy(SET CMP0054 NEW)
endif()
if (POLICY CMP0058)
	# Ninja requires custom command byproducts to be explicit
	cmake_policy(SET CMP0058 NEW)
endif()
if (POLICY CMP0068)
    #mac os x rpath effect
    cmake_policy(SET CMP0068 NEW)
endif()
if (POLICY CMP0069)
    # INTERPROCEDURAL_OPTIMIZATION
    cmake_policy(SET CMP0069 NEW)
endif()
if (POLICY CMP0070)
    # file(GENERATE)
    cmake_policy(SET CMP0070 NEW)
endif()
if (POLICY CMP0073)
    # _LIB_DEPENDS
    cmake_policy(SET CMP0073 NEW)
endif()
if (POLICY CMP0074)
    # Packagename_ROOT
    cmake_policy(SET CMP0074 NEW)
endif()
if (POLICY CMP0075)
    # supress warning in >3.12
    cmake_policy(SET CMP0075 NEW)
endif()

project(gdal C CXX)

# set common variables
set(GDAL_LIB_NAME gdal)
set(GDAL_FORMATS) # used for plugin path in autotest

set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configs" FORCE)
set(GDAL_ROOT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/gdal)
set(GDAL_ROOT_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/gdal)

# 'GDAL_ROOT_TEST_DIR' is used for tests on out of source,
# to determine where test data exists.
set(GDAL_ROOT_TEST_DIR   ${CMAKE_CURRENT_SOURCE_DIR}/autotest)

# CMake Find* modules
set(GDAL_CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules)
# CMake macros and templates
set(GDAL_CMAKE_MACRO_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/macros)
set(GDAL_CMAKE_TEMPLATE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/template)
set(CMAKE_MODULE_PATH ${GDAL_CMAKE_MODULE_PATH} ${GDAL_CMAKE_MACRO_PATH} ${CMAKE_MODULE_PATH})

include(cotire)
# check compiler and set preferences.
include(GdalCheckCompiler)

################################################################

add_subdirectory(gdal)

# please comment out if you want to exclude autotest from distribution.
enable_testing()
add_subdirectory(autotest)

# vim: ts=4 sw=4 sts=4 et
