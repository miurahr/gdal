add_gdal_driver(TARGET ogr_DWG SOURCES
                dgnv8_headers.h
                dwg_headers.h
                ogr_dgnv8.h
                ogr_dwg.h
                createdgnv8testfile_headers.h
                ogrdgnv8datasource.cpp
                ogrdgnv8driver.cpp
                ogrdwg_blockmap.cpp
                ogrdwg_hatch.cpp
                ogrdwgblockslayer.cpp
                ogrdwgdatasource.cpp
                ogrdwgdriver.cpp)
gdal_standard_includes(ogr_DWG)
target_include_directories(ogr_DWG PRIVATE $<TARGET_PROPERTY:ogr_DXF,SOURCE_DIR>
                           ${TEIGHA_INCLUDE_DIR})
gdal_target_link_libraries(ogr_DWG LIBRARIES ${TEIGHA_LIBRARIES})
