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
if (POLICY_CMP0023)
    cmake_policy(SET CMP0023 NEW)
endif()
if (POLICY CMP0025)
    # AppleClang
    cmake_policy(SET CMP0025 NEW)
endif ()
if (POLICY_CMP0033)
    cmake_policy(SET CMP0033 NEW)
endif()
if (POLICY_CMP0034)
    cmake_policy(SET CMP0034 NEW)
endif()
if (POLICY_CMP0037)
    cmake_policy(SET CMP0037 NEW)
endif()
if (POLICY_CMP0038)
    cmake_policy(SET CMP0038 NEW)
endif()
if (POLICY_CMP0039)
    cmake_policy(SET CMP0039 NEW)
endif()
if (POLICY_CMP0040)
    cmake_policy(SET CMP0040 NEW)
endif()
if (POLICY_CMP0041)
    cmake_policy(SET CMP0041 NEW)
endif()
if (POLICY_CMP0042)
    # MACOSX_RPATH
    cmake_policy(SET CMP0042 NEW)
endif()
if (POLICY_CMP0044)
    cmake_policy(SET CMP0044 NEW)
endif()
if (POLICY_CMP0046)
    cmake_policy(SET CMP0046 NEW)
endif()
if (POLICY_CMP0048)
    # *NOT* set VERSION and GDAL_VERSION_(MAJOR|MINOR) etc. variables by project() command
    cmake_policy(SET CMP0048 OLD)
endif()
if (POLICY CMP0050)
    cmake_policy(SET CMP0050 NEW)
endif()
if (POLICY CMP0054)
    cmake_policy(SET CMP0054 NEW)
endif()
if (POLICY CMP0058)
	# Ninja requires custom command byproducts to be explicit
	cmake_policy(SET CMP0058 NEW)
endif()
if (POLICY CMP0062)
    cmake_policy(SET CMP0062 NEW)
endif()
if (POLICY CMP0064)
    # TEST operator for if() command
    cmake_policy(SET CMP0064 NEW)
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
    cmake_policy(SET CMP0075 NEW)
endif()

project(gdal LANGUAGES C CXX)

# setup cmake modules paths
include(cmake/modules/init.cmake)

# cotire cmake speedup addon
include(cotire)

set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configs" FORCE)

################################################################
# set common variables
# WARN: these will be deprecated in future
set(GDAL_ROOT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/gdal)
set(GDAL_ROOT_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/gdal)

# template files path
set(GDAL_CMAKE_TEMPLATE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/template)

################################################################
# Custom global properties
define_property(GLOBAL PROPERTY GDAL_FORMATS
                BRIEF_DOCS "Builtin format"
                FULL_DOCS "Builtin format"
                )
define_property(GLOBAL PROPERTY OGR_FORMATS
                BRIEF_DOCS "Builtin ogr drivers"
                FULL_DOCS "Builtin ogr drivers"
                )
define_property(GLOBAL PROPERTY PLUGIN_MODULES
                BRIEF_DOCS "Plugin modules"
                FULL_DOCS "Plugin modules"
                )
define_property(TARGET PROPERTY PLUGIN_OUTPUT_DIR
                BRIEF_DOCS "Plugin modules build directories"
                FULL_DOCS "Plugin modules build directories"
                )

################################################################
# check compiler and set preferences.
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(CMAKE_COMPILER_IS_GNUCXX)
    execute_process(COMMAND ${CMAKE_C_COMPILER} -dumpversion OUTPUT_VARIABLE GCC_VERSION)
    if (GCC_VERSION VERSION_GREATER 5.1 OR GCC_VERSION VERSION_EQUAL 5.1)
        message(STATUS "GNU C++ 5.1 or later detected. It uses C++11 New ABI.")
        set(GNUCXX_NEW_ABI true)
    endif()
endif()
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    add_compile_options(-Wno-unused-command-line-argument)
endif()
if(CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
endif()

if(MSVC)
    set(CMAKE_DEBUG_POSTFIX "d")
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -wd4127 -wd4251 -wd4275 -wd4786 -wd4100 -wd4245 -wd4206 -wd4018 -wd4389")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4127 -wd4251 -wd4275 -wd4786 -wd4100 -wd4245 -wd4206 -wd4018 -wd4389")
    add_definitions(-DNOMINMAX)
endif()

if(UNIX)
    add_definitions(-D_FORTIFY_SOURCE)
    set(CMAKE_POSITION_INDEPENDENT_CODE ON)
endif()

if(TARGET_CPU MATCHES "x86_64")
    if(MINGW)
        add_definitions(-m64)
    endif()
endif()

################################################################
add_subdirectory(gdal)

# please comment out if you want to exclude autotest from distribution.
enable_testing()
add_subdirectory(autotest)

# vim: ts=4 sw=4 sts=4 et
