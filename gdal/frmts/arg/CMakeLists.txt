ADD_GDAL_DRIVER(TARGET gdal_ARG SOURCES argdataset.cpp)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_ARG)
target_include_directories(gdal_ARG PRIVATE
                           $<TARGET_PROPERTY:gdal_raw,SOURCE_DIR>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>)
if(GDAL_USE_LIBJSONC_INTERNAL)
    target_include_directories(gdal_ARG PRIVATE $<TARGET_PROPERTY:libjson,SOURCE_DIR>)
else()
    target_include_directories(gdal_ARG PRIVATE  ${JSONC_INCLUDE_DIR})
    GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_ARG  LIBRARIES ${JSONC_LIBRARY})
endif()