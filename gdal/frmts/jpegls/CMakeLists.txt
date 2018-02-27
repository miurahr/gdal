
ADD_GDAL_DRIVER(TARGET gdal_JPEGLS SOURCES jpegls_header.h jpeglsdataset.cpp)
gdal_driver_standard_includes(gdal_JPEGLS)
target_include_directories(gdal_JPEGLS PRIVATE ${CHARLS_INCLUDE_DIRS})
GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_JPEGLS LIBRARIES ${CHARLS_LIBRARIES})

if(CHARLS_VERSION STREQUAL 1)
    target_compile_definitions(gdal_JPEGLS PRIVATE -DCHARLS_INTERFACE_H)
endif()
