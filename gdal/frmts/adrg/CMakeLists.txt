add_gdal_driver(TARGET gdal_ADRG SOURCES adrgdataset.cpp)
gdal_standard_includes(gdal_ADRG)
target_include_directories(gdal_ADRG PRIVATE
                           $<TARGET_PROPERTY:gdal_iso8211,SOURCE_DIR>)

add_gdal_driver(TARGET gdal_SRP SOURCES srpdataset.cpp)
gdal_standard_includes(gdal_SRP)
target_include_directories(gdal_SRP PRIVATE
                           $<TARGET_PROPERTY:gdal_iso8211,SOURCE_DIR>)
