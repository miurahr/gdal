ADD_GDAL_DRIVER(TARGET ogr_OpenFileGDB SOURCES filegdbindex.cpp filegdbtable.cpp filegdbtable.h filegdbtable_priv.h
                ogr_openfilegdb.h ogropenfilegdbdatasource.cpp ogropenfilegdbdriver.cpp ogropenfilegdblayer.cpp)
gdal_driver_standard_includes(ogr_OpenFileGDB)
target_include_directories(ogr_OpenFileGDB PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/mem>)
