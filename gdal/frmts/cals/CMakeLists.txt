ADD_GDAL_DRIVER(TARGET gdal_CALS SOURCES calsdataset.cpp)
GDAL_STANDARD_INCLUDES(gdal_CALS)

if(GDAL_USE_LIBTIFF_INTERNAL)
    target_include_directories(gdal_CALS PRIVATE $<TARGET_PROPERTY:libtiff,SOURCE_DIR>)
else()
    target_include_directories(gdal_CALS PRIVATE ${TIFF_INCLUDE_DIRS})
    gdal_target_link_libraries(TARGET gdal_CALS LIBRARIES ${TIFF_LIBRARIES})
endif()
