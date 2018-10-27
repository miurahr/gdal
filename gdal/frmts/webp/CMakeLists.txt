add_gdal_driver(TARGET gdal_WEBP SOURCES webp_headers.h webpdataset.cpp)
gdal_standard_includes(gdal_WEBP)
gdal_target_link_libraries(TARGET gdal_WEBP LIBRARIES ${WEBP_LIBRARIES})
target_include_directories(gdal_WEBP PRIVATE ${WEBP_INCLUDE_DIRS})
