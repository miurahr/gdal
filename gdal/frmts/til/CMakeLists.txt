ADD_GDAL_DRIVER(TARGET gdal_TIL SOURCES tildataset.cpp)
GDAL_STANDARD_INCLUDES(gdal_TIL)
target_include_directories(gdal_TIL PRIVATE $<TARGET_PROPERTY:gdal_vrt,SOURCE_DIR>)
