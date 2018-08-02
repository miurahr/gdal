ADD_GDAL_DRIVER(TARGET gdal_USGSDEM SOURCES usgsdem_create.cpp usgsdemdataset.cpp)
GDAL_STANDARD_INCLUDES(gdal_USGSDEM)
target_include_directories(gdal_USGSDEM PRIVATE $<TARGET_PROPERTY:alg,SOURCE_DIR>)
