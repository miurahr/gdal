ADD_GDAL_DRIVER(TARGET ogr_SUA SOURCES ogr_sua.h ogrsuadatasource.cpp ogrsuadriver.cpp ogrsualayer.cpp)
gdal_driver_standard_includes(ogr_SUA)
