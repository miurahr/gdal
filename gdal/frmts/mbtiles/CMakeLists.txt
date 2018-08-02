
ADD_GDAL_DRIVER(TARGET gdal_MBTILES SOURCES mbtilesdataset.cpp)

if(HAVE_SQLITE3)
    target_include_directories(gdal_MBTILES PRIVATE ${SQLITE3_INCLUDE_DIRS})
    GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_MBTILES LIBRARIES ${SQLITE3_LIBRARY})
endif()
if(GDAL_USE_LIBJSONC_INTERNAL)
    target_include_directories(gdal_MBTILES PRIVATE $<TARGET_PROPERTY:libjson,SOURCE_DIR>)
else()
    target_include_directories(gdal_MBTILES ${JSONC_INCLUDE_DIRS})
    GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_MBTILES LIBRARIES ${JSONC_LIBRARIES})
endif()

target_include_directories(gdal_MBTILES PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/gpkg>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/sqlite>)
