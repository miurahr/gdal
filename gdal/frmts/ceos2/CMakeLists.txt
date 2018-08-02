ADD_GDAL_DRIVER(TARGET gdal_SAR_CEOS
   SOURCES ceos.c ceos.h ceosrecipe.c ceossar.c link.c sar_ceosdataset.cpp)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_SAR_CEOS)
target_include_directories(gdal_SAR_CEOS PRIVATE $<TARGET_PROPERTY:gdal_raw,SOURCE_DIR>)

