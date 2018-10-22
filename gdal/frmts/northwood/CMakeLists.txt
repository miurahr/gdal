# There are NWT_GRC and NWT_GRD drivers
add_gdal_driver(TARGET gdal_NWT BUILTIN
                SOURCES grcdataset.cpp grddataset.cpp northwood.cpp northwood.h)
gdal_standard_includes(gdal_NWT)
target_include_directories(gdal_NWT PRIVATE $<TARGET_PROPERTY:ogr_TAB,SOURCE_DIR>)
