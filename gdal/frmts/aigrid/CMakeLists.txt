ADD_GDAL_DRIVER(TARGET gdal_AIGrid SOURCES
        aigrid.h
        aigccitt.c
        aigdataset.cpp
        aigopen.c
        gridlib.c)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_AIGrid)
target_include_directories(gdal_AIGrid PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/avc>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/shape>)
add_executable(aitest EXCLUDE_FROM_ALL aitest.c)
