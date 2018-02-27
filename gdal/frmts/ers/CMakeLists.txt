ADD_GDAL_DRIVER(TARGET gdal_ERS SOURCES ershdrnode.h ersdataset.cpp ershdrnode.cpp)
target_include_directories(gdal_ERS PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/raw>)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_ERS)
