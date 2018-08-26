add_gdal_driver(TARGET gdal_BPG  SOURCES bpgdataset.cpp)
gdal_standard_includes(gdal_BPG)
target_include_directories(gdal_BPG PRIVATE ${BPG_INCLUDE_DIR})
GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_BPG LIBRARIES ${BPG_LIBRARY})
