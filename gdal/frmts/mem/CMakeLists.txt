ADD_GDAL_DRIVER(TARGET gdal_MEM  SOURCES memdataset.cpp memdataset.h BUILTIN)
gdal_driver_standard_includes(gdal_MEM)
