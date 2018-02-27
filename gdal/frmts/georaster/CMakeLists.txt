ADD_GDAL_DRIVER(TARGET gdal_GEORASTER SOURCES georaster_dataset.cpp georaster_priv.h georaster_rasterband.cpp georaster_wrapper.cpp)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_GEORASTER)
target_include_directories(gdal_GEORASTER PRIVATE ${OCI_INCLUDE_DIR}
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/zlib>)
GDAL_TARGET_LINK_LIBRARIES(gdal_GEORASTER PRIVATE ${OCI_LIBRARY})
if(HAVE_JPEG)
    target_compile_definitions(gdal_GEORASTER PRIVATE  -DJPEG_SUPPORTED)
endif()
