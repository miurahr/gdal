# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Hiroshi Miura
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

## for debug
#SET(CMAKE_BUILD_TYPE "Debug" CACHE STRING "")
#SET(CMAKE_RULE_MESSAGES OFF CACHE BOOL "")
#SET(CMAKE_VERBOSE_MAKEFILE ON CACHE BOOL "")

#DRIVERS
SET(GDAL_ENABLE_FRMT_ADRG ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_AIGRID ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_AAIGRID ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_AIRSAR ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_ARG ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_BMP ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_BSB ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_CALS ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_DDS OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_DODS OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_ECW OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_ELAS ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_EPSILON OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_FITS ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GIF ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GTA ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GFF ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GRIB ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GSG ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GTA ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_GTIFF ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_HDF4 OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_HDF5 ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_OPENJPEG ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_PDF ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_JPEG2000 OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_JPEGLS ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_KEA OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_MBTILES OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_NETCDF OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_OPENJPEG OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_OZI OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_PCIDSK ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_POSTGISRASTER OFF CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_RASTERLITE ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_RIK ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_USGSDEM ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_WEBP ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_WMS ON CACHE BOOL "")
SET(GDAL_ENABLE_FRMT_ZLIB ON CACHE BOOL "")


SET(OGR_ENABLE_AMIGOCLOUD OFF CACHE BOOL "")
SET(OGR_ENABLE_CAD ON CACHE BOOL "")
SET(OGR_ENABLE_CARTO OFF CACHE BOOL "")
SET(OGR_ENABLE_CLOUDANT OFF CACHE BOOL "")
SET(OGR_ENABLE_CSW OFF CACHE BOOL "")
SET(OGR_ENABLE_DODS OFF CACHE BOOL "")
SET(OGR_ENABLE_DWG OFF CACHE BOOL "")
SET(OGR_ENABLE_ELASTIC ON CACHE BOOL "")
SET(OGR_ENABLE_GEOJSON ON CACHE BOOL "")
SET(OGR_ENABLE_GEOMEDIA ON CACHE BOOL "")
SET(OGR_ENABLE_GFT OFF CACHE BOOL "")
SET(OGR_ENABLE_GMLAS ON CACHE BOOL "")
SET(OGR_ENABLE_ILI ON CACHE BOOL "")
SET(OGR_ENABLE_LIBKML ON CACHE BOOL "")
SET(OGR_ENABLE_MONGODB OFF CACHE BOOL "")
SET(OGR_ENABLE_MYSQL ON CACHE BOOL "")
SET(OGR_ENABLE_NAS OFF CACHE BOOL "")
SET(OGR_ENABLE_PG OFF CACHE BOOL "")
SET(OGR_ENABLE_PLSCENES OFF CACHE BOOL "")
SET(OGR_ENABLE_SOSI ON CACHE BOOL "")
SET(OGR_ENABLE_SQLITE ON CACHE BOOL "")
SET(OGR_ENABLE_SVG ON CACHE BOOL "")
SET(OGR_ENABLE_VFK ON CACHE BOOL "")
SET(OGR_ENABLE_WFS ON CACHE BOOL "")
SET(OGR_ENABLE_XLSX ON CACHE BOOL "")

SET(GDAL_QHULL ON CACHE BOOL "")

# Proprietary drivers are all off in default
SET(GDAL_ENABLE_FRMT_SDE OFF CACHE BOOL "")
SET(OGR_ENABLE_SDE OFF CACHE BOOL "")
SET(OGR_ENABLE_FME OFF CACHE BOOL "")
SET(OGR_ENABLE_OCI OFF CACHE BOOL "")
SET(OGR_ENABLE_DB2 OFF CACHE BOOL "")
SET(OGR_ENABLE_MSSQLSPATIAL OFF CACHE BOOL "")
SET(OGR_ENABLE_ODS OFF CACHE BOOL "")
SET(OGR_ENABLE_OGDI OFF CACHE BOOL "")

# GRASS drivers
SET(GDAL_ENABLE_FRMT_GRASS OFF CACHE BOOL "")
SET(OGR_ENABLE_GRASS OFF CACHE BOOL "")

# BUNDLED LIBRARIES
SET(GDAL_USE_QHULL_INTERNAL ON CACHE BOOL "")
SET(GDAL_USE_LIBCSF_INTERNAL ON CACHE BOOL "")
SET(GDAL_USE_OPENCAD_INTERNAL ON CACHE BOOL "")
SET(GDAL_USE_LIBLERC_INTERNAL ON CACHE BOOL "")