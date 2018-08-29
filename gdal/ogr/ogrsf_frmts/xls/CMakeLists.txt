add_gdal_driver(TARGET ogr_XLS
            SOURCES ogr_xls.h ogrxlsdatasource.cpp ogrxlsdriver.cpp ogrxlslayer.cpp)
gdal_standard_includes(ogr_XLS)
