ADD_GDAL_DRIVER(TARGET gdal_BSB
    SOURCES
        bsb_read.h
        bsb_read.c
        bsbdataset.cpp)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_BSB)
add_executable(bsb2raw EXCLUDE_FROM_ALL bsb2raw.c)