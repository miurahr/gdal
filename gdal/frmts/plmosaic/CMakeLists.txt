ADD_GDAL_DRIVER(TARGET gdal_PLMOSAIC SOURCES plmosaicdataset.cpp)
gdal_driver_standard_includes(gdal_PLMOSAIC)
target_include_directories(gdal_PLMOSAIC PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts>)
IF(GDAL_USE_LIBJSONC_INTERNAL)
    target_include_directories(gdal_PLMOSAIC PRIVATE
                               $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson/libjson>)
else()
    target_include_directories(gdal_PLMOSAIC PRIVATE ${JSONC_INCLUDE_DIR})
    gdal_target_link_libraries(TARGET gdal_PLMOSAIC LIBRARIES ${JSONC_LIBRARY})
endif()
