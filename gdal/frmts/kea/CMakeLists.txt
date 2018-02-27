ADD_GDAL_DRIVER(TARGET gdal_KEA SOURCES
                keaband.cpp keaband.h keacopy.cpp keacopy.h
                keadataset.cpp keadataset.h keadriver.cpp
                keamaskband.cpp keamaskband.h keaoverview.cpp keaoverview.h
                kearat.cpp kearat.h libkea_headers.h)
gdal_driver_standard_includes(gdal_KEA)
target_link_libraries(gdal_KEA ${KEA_INCLUDE_DIRS})
GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_KEA LIBRARIES ${KEA_LIBRARIES})
