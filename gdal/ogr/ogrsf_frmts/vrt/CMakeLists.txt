ADD_GDAL_DRIVER(TARGET ogr_VRT SOURCES
                ogr_vrt.h ogrvrtdatasource.cpp ogrvrtdriver.cpp ogrvrtlayer.cpp)
gdal_driver_standard_includes(ogr_VRT)
target_include_directories(ogr_VRT PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic>)
