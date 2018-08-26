add_gdal_driver(TARGET ogr_SDE SOURCES
                ogr_sde.h ogrsdedatasource.cpp ogrsdedriver.cpp ogrsdelayer.cpp)
gdal_standard_includes(ogr_SDE)
