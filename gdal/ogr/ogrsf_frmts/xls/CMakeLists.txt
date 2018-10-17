add_gdal_driver(TARGET ogr_XLS
            SOURCES ogr_xls.h ogrxlsdatasource.cpp ogrxlsdriver.cpp ogrxlslayer.cpp)
gdal_standard_includes(ogr_XLS)
target_include_directories(ogr_XLS PRIVATE ${FREEXL_INCLUDE_DIRS})
gdal_target_link_libraries(TARGET ogr_XLS LIBRARIES FREEXL::freexl)
