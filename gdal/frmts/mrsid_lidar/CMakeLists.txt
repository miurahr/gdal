ADD_GDAL_DRIVER(TARGET gdal_MRSID_Lidar
    SOURCES mg4lidar_headers.h gdal_MG4Lidar.cpp)
gdal_standard_includes(gdal_MRSID_Lidar)
target_include_directories(gdal_MRSID_Lidar PRIVATE ${MRSID_INCLUDE_DIR})
gdal_target_link_libraries(TARGET gdal_MRSID LIBRARIES ${MRSID_LIBRARY_LTI_LIDAR})
