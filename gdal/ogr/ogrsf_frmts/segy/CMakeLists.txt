ADD_GDAL_DRIVER(TARGET ogr_SEGY SOURCES ogr_segy.h ogrsegydatasource.cpp ogrsegydriver.cpp ogrsegylayer.cpp)
gdal_driver_standard_includes(ogr_SEGY)