ADD_GDAL_DRIVER(TARGET gdal_ADRG SOURCES srpdataset.cpp adrgdataset.cpp)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_ADRG)
target_include_directories(gdal_ADRG PRIVATE
                           $<TARGET_PROPERTY:gdal_iso8211,SOURCE_DIR>)
