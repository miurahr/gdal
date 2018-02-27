
ADD_GDAL_DRIVER(TARGET ogr_Elastic SOURCES
                ogr_elastic.h ogrelasticdatasource.cpp ogrelasticdriver.cpp ogrelasticlayer.cpp)
gdal_driver_standard_includes(ogr_Elastic)
target_include_directories(ogr_Elastic PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>)

if(GDAL_USE_LIBJSONC_INTERNAL)
        target_include_directories(ogr_Elastic PRIVATE
                                   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson/libjson>)
else()
        target_include_directories(ogr_Elastic PRIVATE ${JSONC_INCLUDE_DIR})
        gdal_target_link_libraries(TARGET ogr_Elastic LIBRARIES ${JSONC_LIBRARY})
endif()
