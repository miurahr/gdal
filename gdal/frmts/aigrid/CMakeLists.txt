ADD_GDAL_DRIVER(TARGET gdal_AIGrid SOURCES
        aigrid.h
        aigccitt.c
        aigdataset.cpp
        aigopen.c
        gridlib.c)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_AIGrid)
target_include_directories(gdal_AIGrid PRIVATE
                           $<TARGET_PROPERTY:ogr_AVCBin,SOURCE_DIR>
                           $<TARGET_PROPERTY:ogr_Shape,SOURCE_DIR>)
add_executable(aitest EXCLUDE_FROM_ALL aitest.c)
