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

if(CMAKE_VERSION VERSION_LESS 3.12)
    find_package(PythonLibs)
    if(PythonLibs_FOUND)
        set(Python_FOUND ON)
        set(Python_INCLUDE_DIRS ${PYTHON_INCLUDE_DIRS})
        set(Python_LIBRARIES ${PYTHON_LIBRARIES})
        set(Python_SITEARCH /usr/local/lib/python2.7/site-packages)
    endif()
else()
    find_package(Python COMPONENTS Development)
endif()

if(NOT Python_FOUND)
    return()
endif()

INCLUDE_DIRECTORIES(${Python_INCLUDE_DIRS})
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/osgeo/)

add_subdirectory(osgeo)

if(NumPy_FOUND)
    add_custom_target(python_binding ALL
                      DEPENDS _gdal _gdalconst _gnm _ogr _osr
                      _gdal_array
                      osgeo/__init__.py)
else()
    add_custom_target(python_binding ALL
                  DEPENDS _gdal _gdalconst _gnm _ogr _osr
                          osgeo/__init__.py)
endif()

if(Python_SITEARCH)
    install(DIRECTORY osgeo DESTINATION ${Python_SITEARCH})
endif()
