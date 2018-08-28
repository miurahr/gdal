################################################################################
# Project:  CMake4GDAL
# Purpose:  CMake build scripts
# Author:   Dmitry Baryshnikov, polimax@mail.ru, Hiroshi Miura
################################################################################
# Copyright (C) 2017,2018 Hiroshi Miura
# Copyright (C) 2015-2016, NextGIS <info@nextgis.com>
# Copyright (C) 2012,2013,2014 Dmitry Baryshnikov
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
################################################################################

if(CMAKE_COLOR_MAKEFILE)
    string(ASCII 27 Esc)
    set(BoldYellow  "${Esc}[1;33m")
    set(Magenta     "${Esc}[35m")
    set(Cyan        "${Esc}[36m")
    set(BoldCyan    "${Esc}[1;36m")
    set(White       "${Esc}[37m")
    set(ColourReset "${Esc}[m")
else()
    set(BoldYellow  "")
    set(Magenta     "")
    set(Cyan        "")
    set(BoldCyan    "")
    set(White       "")
    set(ColourReset "")
endif()

macro(summary_message text expression)
    set(summary_value 1)
    foreach(e ${expression})
        string(REGEX REPLACE " +" ";" SUMMARY_EXPRESSION_DEF "${e}")
        if(${SUMMARY_EXPRESSION_DEF})
        else()
            set(summary_value 0)
        endif()
    endforeach()
    if(summary_value)
        message(STATUS "${BoldCyan}  ${text} yes${ColourReset}")
    else()
        message(STATUS "${Cyan}  ${text} no${ColourReset}")
    endif()
    unset(summary_value)
endmacro()

# Gathers all lists of flags
macro(gather_flags with_linker result)
    set(${result} "")
    # add the main flags without a config
    list(APPEND ${result} CMAKE_C_FLAGS)
    list(APPEND ${result} CMAKE_CXX_FLAGS)
    list(APPEND ${result} CMAKE_CXX11_STANDARD_COMPILE_OPTION)
    list(APPEND ${result} CMAKE_CXX11_EXTENSION_COMPILE_OPTION)

    if(${with_linker})
        list(APPEND ${result} CMAKE_EXE_LINKER_FLAGS)
        list(APPEND ${result} CMAKE_MODULE_LINKER_FLAGS)
        list(APPEND ${result} CMAKE_SHARED_LINKER_FLAGS)
        list(APPEND ${result} CMAKE_STATIC_LINKER_FLAGS)
    endif()

    if("${CMAKE_CONFIGURATION_TYPES}" STREQUAL "" AND NOT "${CMAKE_BUILD_TYPE}" STREQUAL "")
        # handle single config generators - like makefiles/ninja - when CMAKE_BUILD_TYPE is set
        string(TOUPPER ${CMAKE_BUILD_TYPE} config)
        list(APPEND ${result} CMAKE_C_FLAGS_${config})
        list(APPEND ${result} CMAKE_CXX_FLAGS_${config})
        if(${with_linker})
            list(APPEND ${result} CMAKE_EXE_LINKER_FLAGS_${config})
            list(APPEND ${result} CMAKE_MODULE_LINKER_FLAGS_${config})
            list(APPEND ${result} CMAKE_SHARED_LINKER_FLAGS_${config})
            list(APPEND ${result} CMAKE_STATIC_LINKER_FLAGS_${config})
        endif()
    else()
        # handle multi config generators (like msvc, xcode)
        foreach(config ${CMAKE_CONFIGURATION_TYPES})
            string(TOUPPER ${config} config)
            list(APPEND ${result} CMAKE_C_FLAGS_${config})
            list(APPEND ${result} CMAKE_CXX_FLAGS_${config})
            if(${with_linker})
                list(APPEND ${result} CMAKE_EXE_LINKER_FLAGS_${config})
                list(APPEND ${result} CMAKE_MODULE_LINKER_FLAGS_${config})
                list(APPEND ${result} CMAKE_SHARED_LINKER_FLAGS_${config})
                list(APPEND ${result} CMAKE_STATIC_LINKER_FLAGS_${config})
            endif()
        endforeach()
    endif()
endmacro()

# gdal_print_flags
# Prints all compiler flags for all configurations
macro(print_compiler_flags)
    set(WITH_LINKER ON)
    gather_flags(${WITH_LINKER} allflags)
    message(STATUS "")
    foreach(flags ${allflags})
        message(STATUS "  ${flags}:              ${${flags}}")
    endforeach()
    message(STATUS "")
endmacro()

set(YES ON)
message(STATUS "GDAL is now configured for ${CMAKE_SYSTEM_NAME}")
message(STATUS "  Installation directory:    ${CMAKE_INSTALL_PREFIX}")
message(STATUS "  C++ Compiler type:         ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "  C compile command line:    ${CMAKE_C_COMPILER_LAUNCHER} ${CMAKE_C_COMPILER}")
message(STATUS "  C++ compile command line:  ${CMAKE_CXX_COMPILER_LAUNCHER} ${CMAKE_CXX_COMPILER}")
print_compiler_flags()
message(STATUS "")
message(STATUS "Dependency libraries existence and driver supports:")
message(STATUS "")
summary_message("LIBZ support:              " "GDAL_ENABLE_FRMT_ZLIB;HAVE_ZLIB")
summary_message("LIBLZMA support:           " HAVE_LIBLZMA)
summary_message("cryptopp support:          " HAVE_CRYPTOPP)
summary_message("GRASS support:             " "GDAL_ENABLE_FRMT_GLASS;HAVE_GRASS")
summary_message("CFITSIO support:           " "GDAL_ENABLE_FRMT_CFITSIO;HAVE_CFITSIO")
summary_message("PCRaster support:          " "GDAL_ENABLE_FRMT_PCRASTER;HAVE_PCRASTER")
summary_message("LIBPNG support:            " HAVE_PNG)
summary_message("DDS support:               " HAVE_DDS)
summary_message("GTA support:               " HAVE_GTA)
if(HAVE_BIGTIFF)
  summary_message("LIBTIFF support (BigTIFF=yes)" HAVE_TIFF)
else()
  summary_message("LIBTIFF support            " HAVE_TIFF)
endif()
summary_message("External LIBGEOTIFF:       " HAVE_GEOTIFF)
summary_message("LIBJPEG support:           " HAVE_JPEG)
summary_message("12 bit JPEG:               " HAVE_JPEG12)
summary_message("12 bit JPEG-in-TIFF:       " TIFF_JPEG12_ENABLED)
summary_message("JPEG-Lossless/CharLS:      " HAVE_CHARLS)
summary_message("LIBGIF support:            " HAVE_GIF)
summary_message("OGDI support:              " HAVE_OGDI)
summary_message("HDF4 support:              " HAVE_HDF4)
summary_message("HDF5 support:              " "HAVE_HDF5;GDAL_ENABLE_FRMT_HDF5")
summary_message("OpenJPEG support:          " HAVE_OPENJPEG)
summary_message("Kea support:               " HAVE_KEA)
summary_message("NetCDF support:            " HAVE_NETCDF)
summary_message("Kakadu support:            " HAVE_KAKADU)

if(HAVE_JASPER_UUID)
summary_message("JasPer support (GeoJP2=${HAVE_JASPER_UUID}): " HAVE_JASPER)
else()
summary_message("JasPer support:            " HAVE_JASPER)
endif()

summary_message("ECW support:               " HAVE_ECW)
summary_message("MrSID support:             " HAVE_MRSID)
summary_message("MrSID/MG4 Lidar support:   " HAVE_MRSID_LIDAR)
summary_message("MSG support:               " HAVE_MSG)
summary_message("GRIB support:              " HAVE_GRIB)
summary_message("EPSILON support:           " HAVE_EPSILON)
summary_message("WebP support:              " HAVE_WEBP)
summary_message("cURL support (wms/wcs/...):" HAVE_CURL)
summary_message("PostgreSQL support:        " "HAVE_POSTGRES;OGR_ENABLE_PG")
summary_message("MRF support:               " HAVE_MRF)
summary_message("MySQL support:             " HAVE_MYSQL)
summary_message("Ingres support:            " HAVE_INGRES)
summary_message("Xerces-C support:          " HAVE_XERCESC)
summary_message("NAS support:               " OGR_ENABLE_NAS)
summary_message("Expat support:             " HAVE_EXPAT)
summary_message("libxml2 support:           " HAVE_LIBXML2)
summary_message("Google libkml support:     " HAVE_LIBKML)
summary_message("ODBC support:              " HAVE_ODBC)
summary_message("PGeo support:              " OGR_ENABLE_PGEO)
summary_message("FGDB support:              " HAVE_FGDB)
summary_message("MDB support:               " HAVE_MDB)
summary_message("PCIDSK support:            " HAVE_PCIDSK)
summary_message("OCI support:               " HAVE_OCI)
summary_message("GEORASTER support:         " OGR_ENABLE_GEORASTER)
summary_message("SDE support:               " OGR_ENABLE_SDE)
summary_message("Rasdaman support:          " HAVE_RASDAMAN)
summary_message("DODS support:              " OGR_ENABLE_DODS)
summary_message("SQLite support:            " HAVE_SQLITE3)
summary_message("PCRE support:              " "HAVE_SQLITE3_PCRE;HAVE_PCRE")
summary_message("SpatiaLite support:        " HAVE_SPATIALITE)
summary_message("RasterLite2 support:       " HAVE_RASTERLITE2)
summary_message("DWGdirect support          " HAVE_DWGDIRECT)
summary_message("INFORMIX DataBlade support:" HAVE_IDB)
summary_message("GEOS support:              " GDAL_ENABLE_FRMT_GEOS)
summary_message("QHull support:             " GDAL_QHULL)
# PDF support
summary_message("PDF driver support:        " "WITH_PDFLIB;GDAL_ENABLE_FRMT_PDF")
summary_message("  Poppler support:         " HAVE_POPPLER)
summary_message("  Podofo support:          " HAVE_PODOFO)
summary_message("  PDFium support:          " HAVE_PDFIUM)
summary_message("OpenCL support:            " HAVE_OPENCL)
summary_message("Armadillo support:         " HAVE_ARMADILLO)
summary_message("FreeXL support:            " HAVE_FREEXL)
summary_message("SOSI support:              " OGR_ENABLE_SOSI)
summary_message("MongoDB support:           " HAVE_MONGODB)
summary_message("OpenCAD support:           " "OGR_ENABLE_CAD;WITH_OPENCAD")
message(STATUS "")
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
summary_message("Mac OS X Framework :       " MACOSX_FRAMEWORK)
message(STATUS "")
endif()
if(SWIG_PYTHON OR SWIG_PERL OR SWIG_PHP OR SWIG_CSHARP OR SWIG_JAVA)
    summary_message("SWIG Bindings:             " YES)
    summary_message("    Python Bindings:       " SWIG_PYTHON)
    summary_message("    Perl Bindings:         " SWIG_PERL)
    summary_message("    PHP Bindings:          " SWIG_PHP)
    summary_message("    Java Bindings:         " SWIG_JAVA)
    summary_message("    CSharp Bindings:       " SWIG_CSHARP)
else()
    summary_message("SWIG Bindings:             " NO)
endif()
message(STATUS "")
summary_message("PROJ.4 support:            " HAVE_PROJ4)
summary_message("Json-c support:            " HAVE_JSONC)
summary_message("enable OGR building:       " YES)
summary_message("enable GNM building:       " ENABLE_GNM)
message(STATUS "")
summary_message("enable pthread support:    " GDAL_USE_CPL_MULTIPROC_PTHREAD)
summary_message("enable POSIX iconv support:" HAVE_ICONV)
if(HAVE_ICONV)
    if(NOT Iconv_IS_BUILT_IN)
        summary_message(" individual libiconv:      " YES)
    endif()
    if(ICONV_SECOND_ARGUMENT_IS_CONST OR ICONV_CPP_SECOND_ARGUMENT_IS_CONST)
        summary_message(" iconv 2nd arg is const:   " YES)
    else()
        summary_message(" iconv 2nd arg is const:   " NO)
    endif()
endif()
summary_message("hide internal symbols:     " GDAL_HIDE_INTERNAL_SYMBOLS)

if(HAVE_PODOFO AND HAVE_POPPLER AND HAVE_PDFIUM)
    message(WARNING "podofo, poppler and pdfium available.
                     This is unusual setup, but will work. Pdfium will be used
                     by default...")
elseif(HAVE_PODOFO AND HAVE_POPPLER)
    message(WARNING "podofo and poppler are both available.
                     This is unusual setup, but will work. Poppler will be used
                     by default...")
elseif(HAVE_POPPLER AND HAVE_PDFIUM)
    message(WARNING "poppler and pdfium are both available. This
                     is unusual setup, but will work. Pdfium will be used by
                     default...")
elseif(HAVE_PODOFO AND HAVE_PDFIUM)
    message(WARNING "-podofo and pdfium are both available. This is
                     unusual setup, but will work. Pdfium will be used by
                     default...")
endif()

if(HAVE_LIBXML2 AND HAVE_FGDB)
    message(WARNING "LIBXML2 and FGDB are both available.
                     There might be some incompatibility between system libxml2
                     and the embedded copy within libFileGDBAPI")
endif()
