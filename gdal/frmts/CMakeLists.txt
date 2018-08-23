# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru, Hiroshi Miura
# ******************************************************************************
# * Copyright (C) 2012 Bishop
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

add_library(gdal_frmts OBJECT gdalallregister.cpp)
###############################################
include(MacroGdalDrivers)
include(CMakeDependentOption)

# base driver provide frmt core functions
gdal_format(raw)
gdal_format(iso8211)
gdal_format(png)
gdal_format(jpeg)
gdal_format(gtiff)
gdal_format(mem)
gdal_format(vrt)
# Note: derived is derived of vrt
add_subdirectory(derived)

# default formats
gdal_format(hfa)
gdal_format(sdts)
gdal_format(nitf)
gdal_format(ingr)
gdal_format(gxf)
gdal_format(aaigrid)
gdal_format(ceos)
gdal_format(ceos2)
gdal_format(xpm)
gdal_format(dted)
gdal_format(jdem)
gdal_format(envisat)
gdal_format(elas)
gdal_format(fit)
gdal_format(l1b)
gdal_format(rs2)
gdal_format(ilwis)
gdal_format(rmf)
gdal_format(leveller)
gdal_format(sgi)
gdal_format(srtmhgt)
gdal_format(idrisi)
gdal_format(gsg)
gdal_format(ers)
gdal_format(jaxapalsar)
gdal_format(dimap)
gdal_format(gff)
gdal_format(cosar)
gdal_format(pds)
gdal_format(adrg)
gdal_format(coasp)
gdal_format(tsx)
gdal_format(terragen)
gdal_format(blx)
gdal_format(msgn)
gdal_format(til)
gdal_format(r)
gdal_format(northwood)
gdal_format(saga)
gdal_format(xyz)
gdal_format(hf2)
gdal_format(kmlsuperoverlay)
gdal_format(ctg)
gdal_format(e00grid)
gdal_format(zmap)
gdal_format(ngsgeoid)
gdal_format(iris)
gdal_format(map)
gdal_format(cals)
gdal_format(safe)
gdal_format(sentinel2)
gdal_format(prf)
gdal_format(mrf)
gdal_format(wcs)
gdal_format(wmts)
gdal_format(grib)
gdal_format(pcraster)
gdal_format(gif)

# optioal Formats
gdal_optional_format(fits "FITS")
gdal_optional_format(bsb "Maptech/NOAA BSB Nautical Chart Format")
gdal_optional_format(aigrid "AIGRID")
gdal_optional_format(arg "ARG: Azavea Raster Grid")
gdal_optional_format(usgsdem "USGSDEM")
gdal_optional_format(bmp "BMP")
gdal_optional_format(airsar "AirSAR")
gdal_optional_format(netcdf "NetCDF")
gdal_optional_format(ozi "OZI")
gdal_optional_format(eeda "Earth Engine Data API")
gdal_optional_format(rda "RDA")
gdal_optional_format(rasdaman "RASDAMAN" "HAVE_RASDAMAN")

# formats with external library dependency
gdal_dependent_format(hdf5 "HDF5" "HAVE_HDF5")
gdal_dependent_format(plmosaic "PLMOSAIC" "GDAL_USE_CURL")
gdal_dependent_format(wms "WMS" "GDAL_USE_CURL")
gdal_dependent_format(gta "GTA" "HAVE_GTA")
gdal_dependent_format(webp "WebP" "HAVE_WEBP")
gdal_dependent_format(epsilon "epsilon" "HAVE_EPSILON")
gdal_dependent_format(hdf4 "HDF4" "HAVE_HDF4")
gdal_dependent_format(pdf "PDF" "WITH_PDFLIB")
gdal_dependent_format(rasterlite "RasterLite" "HAVE_SQLITE3;OGR_SQLITE")
gdal_dependent_format(mbtiles "MBTile" "OGR_ENABLE_GPKG;HAVE_SQLITE3")
gdal_dependent_format(postgisraster "PostGIS raster" "HAVE_POSTGRESQL")
gdal_dependent_format(bpg "BPG" "HAVE_BPG")
gdal_dependent_format(dods "DODS" "HAVE_DAP")
gdal_dependent_format(dds "DirectDraw Surface" "HAVE_CRNLIB")
gdal_dependent_format(kea "Kea" "HAVE_KEALIB")
gdal_dependent_format(openjpeg "OpenJPEG" "HAVE_OPENJPEG")
gdal_dependent_format(rik "RIK" "GDAL_ENABLE_FRMT_ZLIB")
gdal_dependent_format(jpegls "JPEG LS" "HAVE_CHARLS")
gdal_dependent_format(jpeg2000 "Jpeg2000" "HAVE_JASPER")
gdal_dependent_format(pcidsk "PCIDSK" "HAVE_PCIDSK")

# for circulate dependency, grass is NOT always compiled in.
gdal_optional_format(grass "GRASS")
if(GDAL_ENABLE_FRMT_GRASS)
    if(HAVE_GRASS AND HAVE_POSTGRESQL)
    else()
        message(FATAL_ERROR "Dependency error on GRASS driver")
    endif()
endif()

####################################################
# driver with proprietary libraries
# Kakadu software SDK
gdal_dependent_format(jp2kak JP2KAK "HAVE_KDU")
gdal_dependent_format(jpipkak JPIPKAK "HAVE_KDU")
# Luratech SDK
gdal_dependent_format(jp2lura JP2LURA "HAVE_LURA")
# ESRI ArcSDE C API SDK
gdal_dependent_format(sde "SDE" "HAVE_SDE")
# LizardTech's decoding software development kit (DSDK)
gdal_dependent_format(mrsid "Multi-resolution Seamless Image Database" "HAVE_MRSID")
gdal_dependent_format(mrsid_lidar "Multi-resolution Seamless Image Database - LiDAR support" "HAVE_MRSID")

# ECW proprietary driver is not compatible with Gcc 5.1+.
option(GDAL_ENABLE_FRMT_ECW "Set ON to build ECW driver" OFF)
if(GDAL_ENABLE_FRMT_ECW)
    if(GNUCXX_NEW_ABI)
        message(STATUS "Gcc 5.1 or later detected, which introduced new C++ ABI. ECW support disabled, because ECW library use old style ABI.")
        set(GDAL_ENABLE_FRMT_ECW OFF CACHE BOOL "" FORCE)
    else()
        gdal_format(ecw)
    endif()
endif()

###############################################################
# Register all frmt drivers according to FRMT_<driver> flags
gdal_standard_includes(gdal_frmts)
target_include_directories(gdal_frmts PRIVATE
                           $<TARGET_PROPERTY:gdal_vrt,SOURCE_DIR>
                           $<TARGET_PROPERTY:ogrsf_generic,SOURCE_DIR>
                           $<TARGET_PROPERTY:ogr_MEM,SOURCE_DIR>)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:gdal_frmts>)
#---------------------------------------------
