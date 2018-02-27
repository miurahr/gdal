ADD_GDAL_DRIVER(TARGET gdal_RASDAMAN SOURCES
                rasdamandataset.cpp rasdamandataset.h)
gdal_driver_standard_includes(gdal_RASDAMAN)
target_include_directories(gdal_RASDAMAN PRIVATE ${RASDAMAN_INCLUDE_DIR})
gdal_target_link_libraries(TARGET gdal_RASDAMAN LIBRARIES ${RASDAMAN_LIBRARY})
