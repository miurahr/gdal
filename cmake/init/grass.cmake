# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Hiroshi Miura
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

## for debug
#SET(CMAKE_BUILD_TYPE "Debug" CACHE STRING "")
#SET(CMAKE_RULE_MESSAGES OFF CACHE BOOL "")
#SET(CMAKE_VERBOSE_MAKEFILE ON CACHE BOOL "")

#SET(CMAKE_CXX_COMPILER_LAUNCHER "/usr/bin/ccache" CACHE PATH "")
#SET(CMAKE_C_COMPILER_LAUNCHER "/usr/bin/ccache" CACHE PATH "")

#ENABLE PLUGINS
SET(GDAL_ENABLE_PLUGIN ON CACHE BOOL "")

# GRASS drivers
SET(GDAL_ENABLE_FRMT_GRASS ON CACHE BOOL "")
SET(OGR_ENABLE_GRASS ON CACHE BOOL "")

# BINDINGS
SET(SWIG_PYTHOFF OFF CACHE BOOL "")
SET(SWIG_PERL OFF CACHE BOOL "")
SET(SWIG_PHP OFF CACHE BOOL "")
SET(SWIG_JAVA OFF CACHE BOOL "")

# GRASS DEPENDENCIES
SET(GDAL_ENABLE_FRMT_WMS ON CACHE BOOL "")

#OFF not used functions
SET(ENABLE_GNM OFF CACHE BOOL "")
SET(BUILD_APPS OFF CACHE BOOL "")
SET(BUILD_DOCS OFF CACHE BOOL "")

#DRIVERS -> ALL OFF
SET(GDAL_ENABLE_FRMT_ADRG OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_AIGRID OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_AAIGRID OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_AIRSAR OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_ARG OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_BMP OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_BSB OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_CALS OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_DDS OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_DODS OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_ECW OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_ELAS OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_EPSILOFF OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_FITS OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GIF OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GTA OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GFF OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GRIB OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GSG OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GTA OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GTIFF OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_HDF4 OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_HDF5 OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_OPENJPEG OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_PDF OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_JPEG2000 OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_JPEGLS OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_KEA OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_MBTILES OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_NETCDF OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_OPENJPEG OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_OZI OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_PCIDSK OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_POSTGISRASTER OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_RASTERLITE OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_RIK OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_SDE OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_USGSDEM OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_WEBP OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_ZLIB OFF CACHE BOOL "")

SET(OGR_ENABLE_AMIGOCLOUD OFF CACHE BOOL "")
SET(OGR_ENABLE_CAD OFF CACHE BOOL "")
SET(OGR_ENABLE_CARTO OFF CACHE BOOL "")
SET(OGR_ENABLE_CLOUDANT OFF CACHE BOOL "")
SET(OGR_ENABLE_CSW OFF CACHE BOOL "")
SET(OGR_ENABLE_DODS OFF CACHE BOOL "")
SET(OGR_ENABLE_DWG OFF CACHE BOOL "")
SET(OGR_ENABLE_ELASTIC OFF CACHE BOOL "")
SET(OGR_ENABLE_GEOJSOFF OFF CACHE BOOL "")
SET(OGR_ENABLE_GEOMEDIA OFF CACHE BOOL "")
SET(OGR_ENABLE_GFT OFF CACHE BOOL "")
SET(OGR_ENABLE_GMLAS OFF CACHE BOOL "")
SET(OGR_ENABLE_ILI OFF CACHE BOOL "")
SET(OGR_ENABLE_LIBKML OFF CACHE BOOL "")
SET(OGR_ENABLE_MOFFGODB OFF CACHE BOOL "")
SET(OGR_ENABLE_MYSQL OFF CACHE BOOL "")
SET(OGR_ENABLE_NAS OFF CACHE BOOL "")
SET(OGR_ENABLE_PG OFF CACHE BOOL "")
SET(OGR_ENABLE_PLSCENES OFF CACHE BOOL "")
SET(OGR_ENABLE_SOSI OFF CACHE BOOL "")
SET(OGR_ENABLE_SQLITE OFF CACHE BOOL "")
SET(OGR_ENABLE_SVG OFF CACHE BOOL "")
SET(OGR_ENABLE_VFK OFF CACHE BOOL "")
SET(OGR_ENABLE_WFS OFF CACHE BOOL "")
SET(OGR_ENABLE_XLSX OFF CACHE BOOL "")

# Proprietary drivers
SET(OGR_ENABLE_FME OFF CACHE BOOL "")
SET(OGR_ENABLE_OCI OFF CACHE BOOL "")
SET(OGR_ENABLE_DB2 OFF CACHE BOOL "")
