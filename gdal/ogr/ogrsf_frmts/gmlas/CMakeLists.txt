ADD_GDAL_DRIVER(TARGET ogr_GMLAS SOURCES ogr_gmlas.h         ogrgmlasdatasource.cpp    ogrgmlaslayer.cpp           ogrgmlasutils.cpp          ogrgmlasxpatchmatcher.cpp
            ogr_gmlas_consts.h  ogrgmlasdriver.cpp        ogrgmlasreader.cpp          ogrgmlaswriter.cpp         ogrgmlasxsdcache.cpp
            ogrgmlasconf.cpp    ogrgmlasfeatureclass.cpp  ogrgmlasschemaanalyzer.cpp  ogrgmlasxlinkresolver.cpp  xercesc_headers.h
            )
gdal_driver_standard_includes(ogr_GMLAS)
TARGET_INCLUDE_DIRECTORIES(ogr_GMLAS PRIVATE
        $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>
        $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/mem>
        $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/pgdump>
)

if(HAVE_XERCESC)
    target_include_directories(ogr_GMLAS PRIVATE
                                    ${XercesC_INCLUDE_DIRS}
                                    ${XercesC_INCLUDE_DIRS}/xercesc)
    target_compile_definitions(ogr_GMLAS PRIVATE -DHAVE_XERCES=1)
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_GMLAS LIBRARIES XercesC::XercesC)
endif()

if(GDAL_USE_LIBJSONC_INTERNAL)
    target_include_directories(ogr_GMLAS PRIVATE
                $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson/libjson>)
else()
    target_include_directories(ogr_GMLAS PRIVATE
                ${JSONC_INCLUDE_DIRS})
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_GMLAS LIBRARIES ${JSONC_LIBRARIES})
endif()

