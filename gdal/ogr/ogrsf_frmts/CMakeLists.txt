# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru
# ******************************************************************************
# * Copyright (C) 2012,2013 Bishop
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

include(GdalDriverHelper)

#############################################
# register all drivers
add_library(ogrsf_frmts OBJECT generic/ogrregisterall.cpp)
gdal_standard_includes(ogrsf_frmts)
target_include_directories(ogrsf_frmts PRIVATE
                           $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
                           $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/generic>)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:ogrsf_frmts>)
set_property(TARGET ogrsf_frmts PROPERTY POSITION_INDEPENDENT_CODE ON)

# Obligatory for building GDAL; always compile in.
ogr_default_driver(mem "Read/write driver for MEMORY virtual files")
ogr_default_driver(geojson "GeoJSON/ESRIJSON/TopoJSON driver")
ogr_default_driver2(mitab TAB "MapInfo TAB and MIF/MID")

###########################################
#
ogr_default_driver(segukooa SEGUKOOA)
ogr_default_driver(segy SEG)
ogr_default_driver(aeronavfaa AERONAVFAA)
ogr_default_driver(avc AVC)
ogr_default_driver(bna BNA)
ogr_default_driver(csv CSV)
ogr_default_driver(dgn DGN)
ogr_default_driver(gmt GMT)
ogr_default_driver(ntf NTF)
ogr_default_driver(rec REC)
option(ENABLE_S57_BUILTIN_CLASSES "Set ON to build s57 driver with builin classes" OFF)
ogr_default_driver(s57 S57)
ogr_default_driver(sdts SDTS ) #depends ISO8211
ogr_default_driver(shape "ESRI shape-file")
ogr_default_driver(tiger "U.S. Census TIGER/Line")
ogr_default_driver(vrt "VRT - Virtual Format")
ogr_default_driver(geoconcept GEOCONCEPT)
ogr_default_driver(xplane XPLANE)
ogr_default_driver(georss GEORSS)
ogr_default_driver(gtm "GPS TrackMaker")
ogr_default_driver(dxf DXF)
ogr_default_driver(pgdump PGDump)
ogr_default_driver(gpsbabel GPSBABEL)
ogr_default_driver(sua "Tim Newport-Peace's Special Use Airspace Format")
ogr_default_driver(openair OPENAIR)
ogr_default_driver(htf HTF)
ogr_default_driver(edigeo EDIGEO)
ogr_default_driver(arcgen ARCGEN)
ogr_default_driver(sxf SXF)
ogr_default_driver(openfilegdb OPENFILEGDB)
ogr_default_driver(wasp "WAsP .map format")
ogr_default_driver(selafin OSELAFIN)
ogr_default_driver(jml JML)
ogr_default_driver(vdv "VDV-451/VDV-452/INTREST Data Format")
ogr_default_driver(kml KML) # when not found EXPAT, it use CPL_MINIXML (ex. android)
ogr_default_driver(gml GML) # when not found both EXPAT/XercesC, return error in driver, referenced by WCS

######################################
#
# XML drivers
ogr_dependent_driver(gpx "GPX - GPS Exchange Format" "HAVE_EXPAT")
ogr_dependent_driver(gmlas GMLAS "HAVE_XERCESC;HAVE_JSONC")
ogr_dependent_driver(svg "Scalable Vector Graphics" "HAVE_EXPAT")
ogr_dependent_driver(csw CSW "HAVE_CURL")
ogr_dependent_driver(dods DODS "HAVE_DAP;HAVE_LIBXML2")
ogr_dependent_driver(dwg DWG "HAVE_TEIGHA")
ogr_dependent_driver(filegdb FileGDB "HAVE_FGDB")
ogr_dependent_driver(gft GFT "HAVE_CURL")
ogr_dependent_driver(libkml LibKML "HAVE_LIBKML;HAVE_BOOST")
ogr_dependent_driver(nas "NAS/ALKIS" "HAVE_XERCESC")
ogr_dependent_driver(plscenes PLSCENES "HAVE_CURL")
ogr_dependent_driver(sosi "SOSI:Systematic Organization of Spatial Information" "HAVE_SOCI")
ogr_dependent_driver(wfs "OGC WFS service" "HAVE_CURL")

ogr_optional_driver(elastic ELASTIC)
ogr_optional_driver(idrisi IDRISI)
ogr_optional_driver(pds "Planetary Data Systems TABLE")

ogr_dependent_driver(sqlite "SQLite3 / Spatialite RDBMS" "HAVE_SQLITE3")
# GeoPacage is a part of sqlite driver.
# when enable sqlite, automatically add a gpkg
if(OGR_ENABLE_SQLITE)
    add_subdirectory(gpkg)
endif()
add_feature_info(ogr_GPKG OGR_ENABLE_SQLITE "GeoPackage")
ogr_dependent_driver(osm "OpenStreetMap XML and PBF" "OGR_ENABLE_SQLITE")
ogr_dependent_driver(vfk "Czech Cadastral Exchange Data Format" "HAVE_SQLITE3")
ogr_dependent_driver(mvt "MVT" "HAVE_SQLITE3")

# ODBC/POSTGRES/MYSQL/INGRESS/COUCHDB
ogr_dependent_driver(amigocloud AMIGOCLOUD "HAVE_CURL")
ogr_dependent_driver(cloudant Cloudant "HAVE_CURL")
ogr_dependent_driver(couchdb CouchDB "HAVE_CURL")
ogr_optional_driver(carto CARTO)
ogr_dependent_driver(ingress INGRESS "HAVE_INGRESS")
ogr_dependent_driver(ili ILI "HAVE_XERCESC")
ogr_dependent_driver(mysql MySQL "HAVE_MYSQL")
ogr_dependent_driver(pg PostGIS "HAVE_POSTGRESQL")
ogr_dependent_driver(geomedia GEOMEDIA "GDAL_USE_ODBC")
ogr_dependent_driver(mssqlspatial MSSQLSPATIAL "GDAL_USE_ODBC")
ogr_dependent_driver(odbc ODBC "GDAL_USE_ODBC")
ogr_dependent_driver(walk "WALK Spatial data" "GDAL_USE_ODBC")
ogr_dependent_driver(pgeo "PGEO" "GDAL_USE_ODBC")

# for dependency problem, grass is not always compiled in.
ogr_optional_driver(grass "GRASS Vector format")
if(OGR_ENABLE_GRASS)
    if(HAVE_GRASS AND HAVE_POSTGRESQL)
    else()
        message(FATAL_ERROR "Dependency error on GRASS driver")
    endif()
endif()

ogr_dependent_driver(xlsx "Microsoft Office Excel(xlsx)" "HAVE_EXPAT")
ogr_dependent_driver(xls "Microsoft Office Excel(xls)" "HAVE_FREEXL")
ogr_optional_driver(mongodb "MongoDB")
ogr_optional_driver(cad "OpenCAD")

#############################################
# proprietary libraries
ogr_dependent_driver(fme "FME" "HAVE_FME")
ogr_dependent_driver(oci "Oracle OCI" "HAVE_OCI")
ogr_dependent_driver(db2 "IBM DB2" "HAVE_DB2")
ogr_dependent_driver(sde "ArcSDE" "HAVE_SDE")
ogr_dependent_driver(idb "IDB" "HAVE_IDB")
if(WIN32)
    ogr_optional_driver(arcobjects ARCOBJECTS)
endif()
ogr_optional_driver(mssqlspatial "MSSQLSpatial")
ogr_optional_driver(ods ODS)
ogr_dependent_driver(ogdi "OGDI" "HAVE_OGDI;HAVE_PROJ4")

add_subdirectory(generic)
