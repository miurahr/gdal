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
include(FeatureSummary)

macro(gdal_find_package pkgname include_file library_file)
  string(TOUPPER ${pkgname} key)
  find_path(${pkgname}_INCLUDE_DIR ${include_file})
  find_library(${pkgname}_LIBRARY ${library_file})
  find_package_handle_standard_args(${pkgname}
      REQUIRED_VARS ${pkgname}_INCLUDE_DIR ${pkgname}_LIBRARY)
  if(${pkgname}_FOUND)
      # set result variables
      set(HAVE_${key} ON CACHE INTERNAL "HAVE_${key}")
      set(${key}_INCLUDE_DIRS ${${pkgnam}_INCLUDE_DIR})
      set(${key}_LIBRARIES ${${pkgname}_LIBRARY})
  else()
      set(HAVE_${key} OFF CACHE INTERNAL "HAVE_${key}")
  endif()
endmacro()

# macro
macro(gdal_check_package name)
    string(TOUPPER ${name} key)
    find_package(${name})
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
        set(GDAL_USE_LIBZ_INTERNAL ON CACHE BOOL "")
    endif()
endif()

find_package(TIFF 4.0)
if(TIFF_FOUND)
    set(HAVE_TIFF ON CACHE INTERNAL "HAVE_TIFF")
    set(CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES} ${TIFF_INCLUDE_DIR})
    set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES} ${TIFF_LIBRARIES})
    check_function_exists(TIFFScanlineSize64 HAVE_BIGTIFF)
    set(GDAL_USE_LIBTIFF_INTERNAL OFF CACHE BOOL "")
endif()
if(NOT HAVE_TIFF)
    set(GDAL_USE_LIBTIFF_INTERNAL ON CACHE BOOL "")
    set(HAVE_BIGTIFF ON)
endif()
set_package_properties(TIFF PROPERTIES
                       URL "http://libtiff.org/"
                       DESCRIPTION "support for the Tag Image File Format (TIFF)."
                       TYPE RECOMMENDED
                      )
if(HAVE_BIGTIFF)
    add_definitions(-DBIGTIFF_SUPPORT)
endif()
gdal_find_package(ZSTD zstd.h zstd)
if(HAVE_ZSTD AND GDAL_USE_LIBTIFF_INTERNAL)
    set(HAVE_ZSTD ON)
endif()

gdal_check_package(SFCGAL)

gdal_check_package(GeoTIFF)
if(NOT HAVE_GEOTIFF)
    set(GDAL_USE_LIBGEOTIFF_INTERNAL ON CACHE BOOL "")
else()
    set(GDAL_USE_LIBGEOTIFF_INTERNAL OFF CACHE BOOL "")
endif()
gdal_check_package(PNG)
if(NOT HAVE_PNG)
    set(GDAL_USE_LIBPNG_INTERNAL ON CACHE BOOL "")
else()
    set(GDAL_USE_LIBPNG_INTERNAL OFF CACHE BOOL "")
endif()
gdal_check_package(JPEG)
if(NOT HAVE_JPEG)
    set(GDAL_USE_LIBJPEG_INTERNAL ON CACHE BOOL "")
else()
    set(GDAL_USE_LIBJPEG_INTERNAL OFF CACHE BOOL "")
endif()
gdal_check_package(GIF)
if(NOT HAVE_GIF)
    set(GDAL_USE_GIFLIB_INTERNAL ON CACHE BOOL "")
else()
    set(GDAL_USE_GIFLIB_INTERNAL OFF CACHE BOOL "")
endif()
gdal_check_package(JSONC)
if(NOT HAVE_JSONC)
    set(GDAL_USE_LIBJSONC_INTERNAL ON CACHE BOOL "")
else()
    set(GDAL_USE_LIBJSONC_INTERNAL OFF CACHE BOOL "")
endif()
gdal_check_package(OpenCAD)
if(NOT HAVE_OPENCAD)
    set(GDAL_USE_OPENCAD_INTERNAL ON CACHE BOOL "")
else()
    set(GDAL_USE_OPENCAD_INTERNAL OFF CACHE BOOL "")
endif()
gdal_check_package(QHULL)
if(NOT HAVE_QHULL)
    set(GDAL_USE_QHULL_INTERNAL ON CACHE BOOL "")
else()
    set(GDAL_USE_QHULL_INTERNAL OFF CACHE BOOL "")
endif()

option(GDAL_USE_LIBPCIDSK_INTERNAL "Set ON to build PCIDSK sdk" ON)
gdal_find_package(LIBCSF csf.h csf)
if(NOT HAVE_LIBCSF)
    set(GDAL_USE_LIBCSF_INTERNAL ON CACHE BOOL "Set ON to build pcraster driver with internal libcdf")
else()
    set(GDAL_USE_LIBCSF_INTERNAL OFF CACHE BOOL "Set ON to build pcraster driver with internal libcdf")
endif()
option(GDAL_USE_LIBLERC_INTERNAL "Set ON to build mrf driver with internal libLERC" ON)

gdal_check_package(PCRE)
find_package(SQLite3)
if(SQLITE3_FOUND)
    set(HAVE_SQLITE3 ON CACHE INTERNAL "HAVE_SQLITE3")
    if(EXISTS ${SQLITE3_PCRE_LIBRARY})
        set(HAVE_SQLITE3_PCRE ON)
    endif()
endif()

gdal_check_package(SPATIALITE)
if(WIN32)
    set(SPATIALITE_AMALGAMATION_DEFAULT ON)
else()
    set(SPATIALITE_AMALGAMATION_DEFAULT OFF)
endif()
option(SPATIALITE_AMALGAMATION "Use amalgamation for spatialite(for windows)" ${SPATIALITE_AMALGAMATION_DEFAULT})
mark_as_advanced(SPATIALITE_AMALGAMATION)

# 3rd party libraries
gdal_check_package(Rasterlite2)
gdal_check_package(LIBKML)
gdal_check_package(Jasper)
gdal_check_package(PROJ4)
gdal_check_package(WebP)
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
gdal_check_package(ECW)
gdal_check_package(NetCDF)
set_package_properties(NetCDF PROPERTIES PURPOSE "enable gdal_netCDF driver")
gdal_check_package(OGDI)
set_package_properties(OGDI PROPERTIES PURPOSE "enable ogr_OGDI driver")
gdal_check_package(OpenCL)
gdal_check_package(PostgreSQL)
gdal_check_package(SOSI)
set_package_properties(SOSI PROPERTIES PURPOSE "enable ogr_SOSI driver")
gdal_check_package(LibLZMA)
set_package_properties(LibLZMA PROPERTIES PURPOSE "enable TIFF LZMA compression")
gdal_check_package(DB2)
set_package_properties(DB2 PROPERTIES PURPOSE "enable ogr_DB2 IBM DB2 driver")
gdal_check_package(CharLS)
set_package_properties(CharLS PROPERTIES PURPOSE "enable gdal_JPEGLS jpeg loss-less driver")
gdal_find_package(BPG libbpg.h bpg)
set_package_properties(BPG PROPERTIES PURPOSE "enable gdal_BPG driver")
gdal_find_package(Crnlib crnlib.h crunch)
set_package_properties(Crnlib PROPERTIES PURPOSE "enable gdal_DDS driver")
gdal_find_package(IDB it.h idb)
set_package_properties(IDB PROPERTIES PURPOSE "enable ogr_IDB driver")
# TODO: implement FindRASDAMAN
# libs: -lrasodmg -lclientcomm -lcompression -lnetwork -lraslib
gdal_find_package(RASDAMAN rasdaman.hh raslib)

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
set_package_properties(SWIG PROPERTIES
                       DESCRIPTION "software development tool that connects programs written in C and C++ with a variety of high-level programming languages."
                       URL "http://swig.org/"
                       TYPE RECOMMENDED)

option(PYTHON_VERSION "Python version to use")
if(PYTHON_VERSION)
    find_package(Python ${PYTHON_VERSION} COMPONENTS Interpreter Development)
else()
    find_package(Python COMPONENTS Interpreter Development)
endif()
if(Python_FOUND)
    set(HAVE_PYTHON ON CACHE INTERNAL "HAVE_PYTHON")
endif()
find_package(NumPy)
set_package_properties(SWIG PROPERTIES PURPOSE "SWIG_PYTHON: Python binding")
set_package_properties(Python PROPERTIES PURPOSE "SWIG_PYTHON: Python binding")
set_package_properties(NumPy PROPERTIES PURPOSE "SWIG_PYTHON: Python binding")

find_package(PHP)
if(PHP_FOUND)
    set(HAVE_PHP ON CACHE INTERNAL "HAVE_PHP")
endif()
set_package_properties(SWIG PROPERTIES PURPOSE "SWIG_PHP: PHP binding")
set_package_properties(PHP PROPERTIES PURPOSE "SWIG_PHP: PHP binding")
find_package(Perl)
if(PERL_FOUND)
    set(HAVE_PERL ON CACHE INTERNAL "HAVE_PERL")
endif()
set_package_properties(SWIG PROPERTIES PURPOSE "SWIG_PERL: Perl binding")
set_package_properties(Perl PROPERTIES PURPOSE "SWIG_PERL: Perl binding")
find_Package(JNI)
if(JNI_FOUND)
    set(HAVE_JAVA ON CACHE INTERNAL "HAVE_JAVA")
endif()
set_package_properties(SWIG PROPERTIES PURPOSE "SWIG_JAVA: Java binding")
set_package_properties(JNI PROPERTIES PURPOSE "SWIG_JAVA: Java binding")
find_package(CSharp)
if(CSHARP_FOUND)
    set(HAVE_CSHARP ON CACHE INTERNAL "HAVE_CSHARP")
endif()
set_package_properties(SWIG PROPERTIES PURPOSE "SWIG_CSharp: CSharp binding")
set_package_properties(CSharp PROPERTIES PURPOSE "SWIG_CSharp: CSharp binding")

# vim: ts=4 sw=4 sts=4 et
