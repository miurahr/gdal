ADD_GDAL_DRIVER(TARGET ogr_Selafin SOURCES io_selafin.cpp io_selafin.h
                ogr_selafin.h ogrselafindatasource.cpp ogrselafindriver.cpp ogrselafinlayer.cpp)
gdal_driver_standard_includes(ogr_Selafin)
target_include_directories(ogr_Selafin PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/mem>)