ADD_GDAL_DRIVER(TARGET ogr_SDE SOURCES
                ogr_sde.h ogrsdedatasource.cpp ogrsdedriver.cpp ogrsdelayer.cpp)
gdal_driver_standard_includes(ogr_SDE)
