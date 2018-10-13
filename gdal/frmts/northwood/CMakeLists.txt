add_gdal_driver(TARGET gdal_NWT_GRD
                SOURCES grcdataset.cpp grddataset.cpp northwood.cpp northwood.h)
gdal_standard_includes(gdal_NWT_GRD)
target_include_directories(gdal_NWT_GRD PRIVATE $<TARGET_PROPERTY:ogr_TAB,SOURCE_DIR>)
