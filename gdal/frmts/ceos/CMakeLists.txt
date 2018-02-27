ADD_GDAL_DRIVER(TARGET gdal_CEOS SOURCES ceosopen.h ceosdataset.cpp ceosopen.c)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_CEOS)
add_executable(ceostest EXCLUDE_FROM_ALL ceostest.c ${LIB_HHEADERS})