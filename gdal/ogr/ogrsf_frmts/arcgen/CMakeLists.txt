ADD_GDAL_DRIVER(TARGET ogr_ARCGEN SOURCES ogr_arcgen.h ograrcgendatasource.cpp ograrcgendriver.cpp ograrcgenlayer.cpp)
gdal_standard_includes(ogr_ARCGEN)
