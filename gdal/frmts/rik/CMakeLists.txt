ADD_GDAL_DRIVER(TARGET gdal_RIK SOURCES rikdataset.cpp)
GDAL_STANDARD_INCLUDES(gdal_RIK)

if(GDAL_USE_LIBZ_INTERNAL)
    target_include_directories(gdal_RIK PRIVATE $<TARGET_PROPERTY:libz,SOURCE_DIR>)
else()
    target_include_directories(gdal_RIK PRIVATE ZLIB::ZLIB)
    gdal_target_link_libraries(TARGET gdal_RIK LIBRARIES ZLIB::ZLIB)
endif()
