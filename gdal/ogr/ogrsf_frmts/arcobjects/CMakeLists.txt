ADD_GDAL_DRIVER(TARGET ogr_ao SOURCES aodatasource.cpp aodriver.cpp aolayer.cpp aoutils.cpp aoutils.h ogr_ao.h)
gdal_standard_includes(ogr_ao)