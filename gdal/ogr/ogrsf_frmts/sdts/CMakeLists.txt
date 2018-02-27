ADD_GDAL_DRIVER(TARGET ogr_SDTS SOURCES ogr_sdts.h ogrsdtsdatasource.cpp ogrsdtsdriver.cpp ogrsdtslayer.cpp)
gdal_driver_standard_includes(ogr_SDTS)
target_include_directories(ogr_SDTS PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/sdts>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/iso8211>)

