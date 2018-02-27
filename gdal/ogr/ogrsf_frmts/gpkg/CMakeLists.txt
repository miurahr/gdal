ADD_GDAL_DRIVER(TARGET ogr_GeoPackage SOURCES
        ogr_geopackage.h
        gpkgmbtilescommon.h
        ogrgeopackageutility.h
        ogrgeopackagedatasource.cpp
        ogrgeopackagedriver.cpp
        ogrgeopackagelayer.cpp
        ogrgeopackageselectlayer.cpp
        ogrgeopackagetablelayer.cpp
        ogrgeopackageutility.cpp
        gdalgeopackagerasterband.cpp
)
gdal_driver_standard_includes(ogr_GeoPackage)

target_include_directories(ogr_GeoPackage PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/alg>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/mem>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/sqlite>)
if(HAVE_SQLITE3)
    target_include_directories(ogr_GeoPackage PRIVATE ${SQLITE3_INCLUDE_DIRS})
    gdal_target_link_libraries(TARGET ogr_GeoPackage PRIVATE LIBRARIES ${SQLITE3_LIBRARY})
    if(SQLITE_HAS_COLUMN_METADATA)
        target_compile_definitions(ogr_GeoPackage PRIVATE -DSQLITE_HAS_COLUMN_METADATA)
    endif()
endif()
if(HAVE_SPATIALITE)
    target_include_directories(ogr_GeoPackage PRIVATE ${SPATIALITE_INCLUDE_DIRS})
    gdal_target_link_libraries(TARGET ogr_GeoPackage PRIVATE LIBRARIES ${SPATIALITE_LIBRARIES})
    target_compile_definitions(ogr_GeoPackage PRIVATE -DHAVE_SPATIALITE -DSPATIALITE_412_OR_LATER)
    if(SPATIALITE_AMALGAMATION)
        target_compile_definitions(ogr_GeoPackage PRIVATE -DSPATIALITE_AMALGAMATION)
    endif()
endif()
if(HAVE_RASTERLITE)
    target_include_directories(ogr_GeoPackage PRIVATE
                               ${RASTERLITE_INCLUDE_DIRS})
    target_compile_definitions(ogr_GeoPackage PRIVATE -DHAVE_RASTERLITE2)
    gdal_target_link_libraries(TARGET ogr_Geopackage LIBRARIES ${RASTERLITE_LIBRARIES})
endif()
