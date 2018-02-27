ADD_GDAL_DRIVER(TARGET gdal_CALS
            SOURCES calsdataset.cpp)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_CALS)
target_include_directories(gdal_CALS PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/gtiff/libtiff>)

