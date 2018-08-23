ADD_GDAL_DRIVER(TARGET ogr_GeoRSS SOURCES
            ogr_georss.h ogrgeorssdatasource.cpp ogrgeorssdriver.cpp ogrgeorsslayer.cpp)
gdal_driver_standard_includes(ogr_GeoRSS)
if(HAVE_EXPAT)
    target_include_directories(ogr_GeoRSS PRIVATE ${EXPAT_INCLUDE_DIRS})
    target_compile_definitions(ogr_GeoRSS PRIVATE -DHAVE_EXPAT)
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_GeoRSS LIBRARIES EXPAT::EXPAT)
endif()
