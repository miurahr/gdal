# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru, Hiroshi Miura
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

add_library(ogr OBJECT
        gml2ogrgeometry.cpp
        ogr2gmlgeometry.cpp
        ograssemblepolygon.cpp
        ogrct.cpp
        ogrcurve.cpp
        ogrfeature.cpp
        ogrfeaturedefn.cpp
        ogrgeomfielddefn.cpp
        ogrfeaturestyle.cpp
        ogrfielddefn.cpp
        ogrgeometry.cpp
        ogrgeometrycollection.cpp
        ogrgeometryfactory.cpp
        ogrlinearring.cpp
        ogrlinestring.cpp
        ogrmultilinestring.cpp
        ogrmultipoint.cpp
        ogrmultipolygon.cpp
        ogrpoint.cpp
        ogrpolygon.cpp
        ogrspatialreference.cpp
        ogrsurface.cpp
        ogrutils.cpp
        ogr_api.cpp
        ograpispy.cpp
        ogr_expat.cpp
        ogr_geo_utils.cpp
        ogr_fromepsg.cpp
        ogr_opt.cpp
        ogr_srsnode.cpp
        ogr_srs_dict.cpp
        ogr_srs_erm.cpp
        ogr_srs_esri.cpp
        ogr_srs_ozi.cpp
        ogr_srs_panorama.cpp
        ogr_srs_pci.cpp
        ogr_srs_proj4.cpp
        ogr_srs_usgs.cpp
        ogr_srs_validate.cpp
        ogr_srs_xml.cpp
        osr_cs_wkt.c
        osr_cs_wkt_parser.c
        swq.cpp
        swq_expr_node.cpp
        swq_op_general.cpp
        swq_op_registrar.cpp
        swq_parser.cpp
        swq_select.cpp
        ogrgeomediageometry.cpp
        ogrpgeogeometry.cpp
        ogrfeaturequery.cpp
        ogr_geocoding.cpp
        ogrcircularstring.cpp
        ogrcompoundcurve.cpp
        ogrcurvecollection.cpp
        ogrcurvepolygon.cpp
        ogrmulticurve.cpp
        ogrmultisurface.cpp
        ogrpolyhedralsurface.cpp
        ogrtriangle.cpp
        ogrtriangulatedsurface.cpp
        ogrsf_frmts/ogrsf_frmts.h
        ogrsf_frmts/ogr_attrind.h
        ogrgeomediageometry.h
        ogrpgeogeometry.h
        ogr_geo_utils.h
        ogr_srs_esri_names.h
        swq.h
        osr_cs_wkt.h
        osr_cs_wkt_parser.h
        ogr_expat.h
        ogr_geocoding.h
        ogr_libs.h
        ogr_geos.h
            ogr_xerces.cpp
            ogr_xerces.h
)
include(GdalStandardIncludes)
gdal_standard_includes(ogr)
target_include_directories(ogr PRIVATE $<TARGET_PROPERTY:geojson,SOURCE_DIR>
                           $<TARGET_PROPERTY:ogr_MEM,SOURCE_DIR>
                           )
target_sources(gdal PRIVATE $<TARGET_OBJECTS:ogr>)
target_compile_definitions(ogr PRIVATE -DHAVE_MITAB)

if(HAVE_GEOS)
    get_filename_component(GEOS_ROOT ${GEOS_INCLUDE_DIR} PATH)
    target_include_directories(ogr PRIVATE
                               ${GEOS_INCLUDE_DIR}
                               ${GEOS_ROOT}/capi)
    target_compile_definitions(ogr PRIVATE -DHAVE_GEOS=1)
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${GEOS_LIBRARY})
endif()

if(HAVE_PROJ4)
    target_include_directories(ogr PRIVATE ${PROJ4_INCLUDE_DIR})
    target_compile_definitions(ogr PRIVATE -DHAVE_PROJ)
    #TODO: detect whether -DPROJ_STATIC or not.
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${PROJ4_LIBRARY})
endif()

#check zip and internal zip
if(GDAL_USE_LIBZ)
    target_compile_definitions(ogr PRIVATE -DHAVE_LIBZ -DZIP_SUPPORT)
    if(GDAL_USE_LIBZ_INTERNAL)
        target_include_directories(ogr PRIVATE
                                   $<TARGET_PROPERTY:libz,SOURCE_DIR>)
    else()
        target_include_directories(ogr PRIVATE ${ZLIB_INCLUDE_DIRS})
        target_compile_definitions(ogr PRIVATE -DHAVE_ZLIB_H -DHAVE_ZLIB)
        if(MSVC)
            target_compile_definitions(ogr PRIVATE -DZLIB_DLL)
        endif()
        target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${GDAL_TARGET_LINK_LIB} ${ZLIB_LIBRARIES})
    endif()
endif()

if(HAVE_EXPAT)
    target_include_directories(ogr PRIVATE ${EXPAT_INCLUDE_DIRS})
    target_compile_definitions(ogr PRIVATE -DHAVE_EXPAT)
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE EXPAT::EXPAT)
endif()

if(HAVE_XERCESC)
    target_sources(ogr PRIVATE ogr_xerces_headers.h)
    target_include_directories(ogr PRIVATE ${XercesC_INCLUDE_DIRS}
                                           ${XercesC_INCLUDE_DIRS}/xercesc)
    target_compile_definitions(ogr PRIVATE -DHAVE_XERCES)
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE XercesC::XercesC)
endif()

if(HAVE_JSONC)
    target_include_directories(ogr PRIVATE ${JSONC_INCLUDE_DIR})
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${JSONC_LIBRARY})
else()
    if(GDAL_USE_LIBJSONC_INTERNAL)
        target_include_directories(ogr PRIVATE $<TARGET_PROPERTY:libjson,SOURCE_DIR>)
    endif()
endif()

install(FILES
        ogr_api.h
        ogr_core.h
        ogr_feature.h
        ogr_featurestyle.h
        ogr_geometry.h
        ogr_p.h
        ogr_spatialref.h
        ogr_srs_api.h
        ogr_sfcgal.h
        DESTINATION include/gdal)
