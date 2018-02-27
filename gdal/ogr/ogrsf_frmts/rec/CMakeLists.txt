ADD_GDAL_DRIVER(TARGET ogr_REC
                SOURCES ogr_rec.h ogrrecdatasource.cpp ogrrecdriver.cpp ogrreclayer.cpp
                ll_recio.cpp)
gdal_driver_standard_includes(ogr_REC)
