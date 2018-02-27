ADD_GDAL_DRIVER(TARGET ogr_PDS SOURCES
        ogrpdsdatasource.cpp
        ogr_pds.h
        ogrpdsdriver.cpp
        ogrpdslayer.cpp
)
gdal_standard_includes(ogr_PDS)
target_include_directories(ogr_PDS PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/pds>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/gml>)
if(GDAL_USE_LIBJSONC_INTERNAL)
    target_include_directories(ogr_PDS PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson/libjson>)
else()
    target_include_directories(ogr_PDS PRIVATE
                           ${JSONC_INCLUDE_DIR})
    gdal_target_link_libraries(TARGET ogr_PDS LIBRARIES ${JSONC_LIBRARY})
endif()
