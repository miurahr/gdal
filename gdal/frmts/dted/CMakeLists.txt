ADD_GDAL_DRIVER(TARGET gdal_DTED SOURCES dted_api.h dted_api.c dted_create.c dted_ptstream.c dteddataset.cpp)
GDAL_STANDARD_INCLUDES(gdal_DTED)
add_executable(dted_test EXCLUDE_FROM_ALL dted_test.c)