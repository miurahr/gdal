ADD_GDAL_DRIVER(TARGET ogr_XLS
            SOURCES ogr_xls.h ogrxlsdatasource.cpp ogrxlsdriver.cpp ogrxlslayer.cpp)
gdal_driver_standard_includes(ogr_XLS)
