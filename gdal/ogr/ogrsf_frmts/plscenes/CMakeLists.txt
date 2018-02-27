ADD_GDAL_DRIVER(TARGET ogr_PLSCENES SOURCES ogr_plscenes.h ogrplscenesdatav1dataset.cpp ogrplscenesdatav1layer.cpp ogrplscenesdriver.cpp)
gdal_driver_standard_includes(ogr_PLSCENES)

if(GDAL_USE_LIBJSONC_INTERNAL)
    TARGET_INCLUDE_DIRECTORIES(ogr_PLSCENES
        PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson/libjson>
                 $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>)
else()
    TARGET_INCLUDE_DIRECTORIES(ogr_PLSCENES
        PRIVATE ${JSONC_INCLUDE_DIR}
                $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>)
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_PLSCENES
        LIBRARIES ${JSONC_LIBRARY})
endif()
