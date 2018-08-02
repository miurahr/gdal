ADD_GDAL_DRIVER(TARGET ogr_Idrisi
            SOURCES ogr_idrisi.h ogridrisidatasource.cpp ogridrisidriver.cpp ogridrisilayer.cpp)
target_include_directories(ogr_Idrisi PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/idrisi>)
gdal_driver_standard_includes(ogr_Idrisi)