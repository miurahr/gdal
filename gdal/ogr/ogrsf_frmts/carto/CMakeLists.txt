ADD_GDAL_DRIVER(TARGET ogr_Carto SOURCES ogr_carto.h ogrcartodatasource.cpp
                ogrcartodriver.cpp ogrcartolayer.cpp ogrcartoresultlayer.cpp ogrcartotablelayer.cpp)
gdal_driver_standard_includes(ogr_Carto)
target_include_directories(ogr_Carto PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/pgdump>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>)
if(GDAL_USE_LIBJSONC_INTERNAL)
        target_include_directories(ogr_Carto PRIVATE
                                   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson/libjson>)
else()
        target_include_directories(ogr_Carto PRIVATE ${JSONC_INCLUDE_DIR})
        gdal_target_link_libraries(TARGET ogr_Carto LIBRARIES ${JSONC_LIBRARY})
endif()