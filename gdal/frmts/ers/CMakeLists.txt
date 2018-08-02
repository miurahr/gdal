ADD_GDAL_DRIVER(TARGET gdal_ERS SOURCES ershdrnode.h ersdataset.cpp ershdrnode.cpp)
target_include_directories(gdal_ERS PRIVATE $<TARGET_PROPERTY:gdal_raw,SOURCE_DIR>)
GDAL_STANDARD_INCLUDES(gdal_ERS)
