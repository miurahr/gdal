add_gdal_driver(TARGET gdal_KEA SOURCES
                keaband.cpp keaband.h keacopy.cpp keacopy.h
                keadataset.cpp keadataset.h keadriver.cpp
                keamaskband.cpp keamaskband.h keaoverview.cpp keaoverview.h
                kearat.cpp kearat.h libkea_headers.h)
gdal_standard_includes(gdal_KEA)
target_include_directories(gdal_KEA PRIVATE ${KEA_INCLUDE_DIRS})
gdal_target_link_libraries(TARGET gdal_KEA LIBRARIES KEA::KEA)
