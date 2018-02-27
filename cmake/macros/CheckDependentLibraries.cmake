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

include (CheckFunctionExists)
include(FindPackageHandleStandardArgs)
include(CMakeDependentOption)

macro(gdal_find_package pkgname include_file library_file)
  string(TOUPPER ${pkgname} key)
  find_path(${pkgname}_INCLUDE_DIR ${include_file})
  find_library(${pkgname}_LIBRARY ${library_file})
  find_package_handle_standard_args(${pkgname}
      REQUIRED_VARS ${pkgname}_INCLUDE_DIR ${pkgname}_LIBRARY)
  if(${pkgname}_FOUND)
      # set result variables
      set(HAVE_${key} ON CACHE INTERNAL "HAVE_${key}")
      set(${key}_INCLUDE_DIRS ${pkgnam}_INCLUDE_DIR)
      set(${key}_LIBRARIES ${pkgname}_LIBRARY)
  else()
      set(HAVE_${key} OFF CACHE INTERNAL "HAVE_${key}")
  endif()
endmacro()

# macro
macro(gdal_check_package name)
    string(TOUPPER ${name} key)
    find_package(${name} CONFIG QUIET)
    if(NOT ${key}_FOUND AND NOT ${name}_FOUND)
        find_package(${name} MODULE)
    endif()
    if(${key}_FOUND OR ${name}_FOUND)
        set(HAVE_${key} ON CACHE INTERNAL "HAVE_${key}")
    else()
        set(HAVE_${key} OFF CACHE INTERNAL "HAVE_${key}")
    endif()
endmacro()

function(split_libpath _lib)
if(_lib)
   # split lib_line into -L and -l linker options
   GET_FILENAME_COMPONENT(_path ${${_lib}} PATH)
   GET_FILENAME_COMPONENT(_name ${${_lib}} NAME_WE)
   STRING(REGEX REPLACE "^lib" "" _name ${_name})
   SET(${_lib} -L${_path} -l${_name})
endif()
endfunction()

option(GDAL_USE_ODBC "Set ON to use odbc" OFF)
option(GDAL_USE_XMLREFORMAT "Set ON to use xmlreformat" OFF)

# basic libaries
find_package(Boost)
if(Boost_FOUND)
    set(HAVE_BOOST ON CACHE INTERNAL "HAVE_BOOST")
        # FIXME: should specify where consumed
    add_definitions(-DHAVE_BOOST)
endif()
gdal_check_package(CURL)
cmake_dependent_option(GDAL_USE_CURL "Set ON to use libcurl" ON "HAVE_CURL" OFF)
if(GDAL_USE_CURL)
    if(NOT HAVE_CURL)
        message(FATAL_ERROR "Configured to use libcurl, but not found")
    endif()
endif()

gdal_check_package(Iconv)
gdal_check_package(LibXml2)

gdal_check_package(EXPAT)
gdal_check_package(XercesC)
if(HAVE_EXPAT OR HAVE_XERCESC)
    set(HAVE_XMLPARSER ON)
else()
    set(HAVE_XMLPARSER OFF)
endif()

option(GDAL_USE_LIBZ "Set ON to use libz" ON)
gdal_check_package(ZLIB)
if(GDAL_USE_LIBZ)
    if(NOT HAVE_ZLIB)
        set(GDAL_USE_LIBZ_INTERNAL ON CACHE INTERNAL "")
    endif()
endif()

find_package(TIFF)
if(TIFF_FOUND)
    set(HAVE_TIFF ON CACHE INTERNAL "HAVE_TIFF")
    set(CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES} ${TIFF_INCLUDE_DIR})
    set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES} ${TIFF_LIBRARIES})
    check_function_exists(TIFFScanlineSize64 HAVE_BIGTIFF)
endif()
if(NOT HAVE_TIFF)
    set(GDAL_USE_LIBTIFF_INTERNAL ON CACHE INTERNAL "")
    set(HAVE_BIGTIFF ON)
endif()
if(HAVE_BIGTIFF)
    add_definitions(-DBIGTIFF_SUPPORT)
endif()
gdal_check_package(GeoTIFF)
if(NOT HAVE_GEOTIFF)
    set(GDAL_USE_LIBGEOTIFF_INTERNAL ON CACHE INTERNAL "")
endif()
gdal_check_package(PNG)
if(NOT HAVE_PNG)
	set(GDAL_USE_LIBPNG_INTERNAL ON CACHE INTERNAL "")
endif()
gdal_check_package(JPEG)
if(NOT HAVE_JPEG)
    set(GDAL_USE_LIBJPEG_INTERNAL ON CACHE INTERNAL "")
endif()
gdal_check_package(GIF)
if(NOT HAVE_GIF)
    set(GDAL_USE_GIFLIB_INTERNAL ON CACHE INTERNAL "")
endif()
gdal_check_package(JSONC)
if(NOT HAVE_JSONC)
    set(GDAL_USE_LIBJSONC_INTERNAL ON CACHE INTERNAL "")
endif()
gdal_check_package(OpenCAD)
if(NOT HAVE_OPENCAD)
    set(GDAL_USE_OPENCAD_INTERNAL ON CACHE INTERNAL "")
endif()
gdal_check_package(QHULL)
if(NOT HAVE_QHULL)
    set(GDAL_USE_QHULL_INTERNAL ON CACHE INTERNAL "")
endif()

option(GDAL_USE_LIBCSF_INTERNAL "Set ON to build pcraster driver with internal libcdf" ON)
option(GDAL_USE_LIBLERC_INTERNAL "Set ON to build mrf driver with internal libLERC" ON)

find_package(SQLite3)
if(SQLITE3_FOUND)
    set(HAVE_SQLITE3 ON CACHE INTERNAL "HAVE_SQLITE3")
    if(EXISTS ${SQLITE3_PCRE_LIBRARY})
        set(HAVE_SQLITE3_PCRE ON)
    endif()
endif()

gdal_check_package(SPATIALITE)
option(SPATIALITE_AMALGAMATION "Use amalgamation for spatialite(for windows)" OFF)
mark_as_advanced(SPATIALITE_AMALGAMATION)

# 3rd party libraries
gdal_check_package(Rasterlite2)
gdal_check_package(LIBKML)
gdal_check_package(Jasper)
gdal_check_package(PROJ4)
gdal_check_package(WEBP)
gdal_check_package(GTA)
gdal_check_package(MRSID)
gdal_check_package(DAP)
gdal_check_package(Armadillo)
gdal_check_package(CFITSIO)
gdal_check_package(Epsilon)
gdal_check_package(GEOS)
gdal_check_package(HDF4)
gdal_check_package(HDF5)
option(KEAHDF5_STATIC_LIBS "Build against static KEA and HDF5" OFF)
gdal_check_package(KEA)
gdal_check_package(NetCDF)
gdal_check_package(OGDI)
gdal_check_package(OpenCL)
gdal_check_package(POSTGRES)
gdal_check_package(SOSI)
gdal_check_package(LibLZMA)
gdal_check_package(DB2)
gdal_check_package(CharLS)
gdal_find_package(BPG libbpg.h bpg)
gdal_find_package(Crnlib crnlib.h crunch)
gdal_find_package(IDB it.h idb)

# OpenJPEG's cmake-CONFIG is broken, so call module explicitly
find_package(OpenJPEG MODULE)
if(OPENJPEG_FOUND)
    set(HAVE_OPENJPEG ON CACHE INTERNAL "")
else()
    set(HAVE_OPENJPEG OFF CACHE INTERNAL "")
endif()

# Only GRASS 7 is currently supported but we keep dual version support in cmake for possible future switch to GRASS 8.
set(TMP_GRASS OFF)
foreach(GRASS_SEARCH_VERSION 7)
    # Cached variables: GRASS7_FOUND, GRASS_PREFIX7, GRASS_INCLUDE_DIR7
    # HAVE_GRASS: TRUE if at least one version of GRASS was found
    set(GRASS_CACHE_VERSION ${GRASS_SEARCH_VERSION})
    if(WITH_GRASS${GRASS_CACHE_VERSION})
        find_package(GRASS ${GRASS_SEARCH_VERSION} MODULE)
        if(${GRASS${GRASS_CACHE_VERSION}_FOUND})
            set(GRASS_PREFIX${GRASS_CACHE_VERSION} ${GRASS_PREFIX${GRASS_SEARCH_VERSION}} CACHE PATH "Path to GRASS ${GRASS_SEARCH_VERSION} base directory")
            set(TMP_GRASS ON)
        endif()
    endif()
endforeach()
if(TMP_GRASS)
    set(HAVE_GRASS ON CACHE INTERNAL "HAVE_GRASS")
else()
    set(HAVE_GRASS OFF CACHE INTERNAL "HAVE_GRASS")
endif()
unset(TMP_GRASS)

# PDF library: one of them enables PDF driver
gdal_check_package(Poppler)
gdal_check_package(PDFium)
gdal_check_package(Podofo)
if(HAVE_POPPLER OR HAVE_PDFIUM OR HAVE_PODOFO)
    set(WITH_PDFLIB ON)
else()
    set(WITH_PDFLIB OFF)
endif()

gdal_check_package(TEIGHA)

# proprietary libraries
# Esri ArcSDE(Spatial Database Engine)
gdal_check_package(SDE)
# KAKADU
gdal_check_package(KDU)
# LURATECH JPEG2000 SDK
set(LURATECH_JP2SDK_DIRECTORY "" CACHE STRING "LURATECH JP2SDK library base directory")

# bindings
gdal_check_package(SWIG)
find_package(PythonInterp)
if(PYTHONINTERP_FOUND)
    set(HAVE_PYTHON ON CACHE INTERNAL "HAVE_PYTHON")
endif()
find_package(PHP)
if(PHP_FOUND)
    set(HAVE_PHP ON CACHE INTERNAL "HAVE_PHP")
endif()
find_package(Perl)
if(PERL_FOUND)
    set(HAVE_PERL ON CACHE INTERNAL "HAVE_PERL")
endif()
find_Package(JNI)
if(JNI_FOUND)
    set(HAVE_JAVA ON CACHE INTERNAL "HAVE_JAVA")
endif()
find_package(CSharp)
if(CSHARP_FOUND)
    set(HAVE_CSHARP ON CACHE INTERNAL "HAVE_CSHARP")
endif()

# vim: ts=4 sw=4 sts=4 et
