ADD_GDAL_DRIVER(TARGET gdal_RIK SOURCES rikdataset.cpp)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_RIK)
target_include_directories(gdal_RIK PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/zlib>)