add_gdal_driver(TARGET gdal_MBTiles SOURCES mbtilesdataset.cpp)

if(HAVE_SQLITE3)
    target_include_directories(gdal_MBTiles PRIVATE ${SQLITE3_INCLUDE_DIRS})
    GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_MBTiles LIBRARIES ${SQLITE3_LIBRARY})
endif()
if(GDAL_USE_LIBJSONC_INTERNAL)
    target_include_directories(gdal_MBTiles PRIVATE $<TARGET_PROPERTY:libjson,SOURCE_DIR>)
else()
    target_include_directories(gdal_MBTiles ${JSONC_INCLUDE_DIRS})
    GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_MBTiles LIBRARIES ${JSONC_LIBRARIES})
endif()
target_include_directories(gdal_MBTiles PRIVATE
                           $<TARGET_PROPERTY:ogr_geojson,SOURCE_DIR>
                           $<TARGET_PROPERTY:ogr_GeoPackage,SOURCE_DIR>
                           $<TARGET_PROPERTY:ogr_SQLite,SOURCE_DIR>)
