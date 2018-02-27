ADD_GDAL_DRIVER(TARGET gdal_PCIDSK SOURCES
                pcidskdataset2.h pcidskdataset2.cpp
                gdal_edb.cpp vsi_pcidsk_io.cpp ogrpcidsklayer.cpp)
gdal_standard_includes(gdal_PCIDSK)
if(HAVE_JPEG)
    target_include_directories(gdal_PCIDSK PRIVATE ${JPEG_INCLUDE_DIRS})
    gdal_target_link_libraries(TARGET gdal_PCIDSK LIBRARIES ${JPEG_LIBRARIES})
endif()

if(LIBPCIDSK_INTERNAL)
    target_include_directories(gdal_PCIDSK PRIVATE
                               $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/pcidsk/sdk>)
endif()
