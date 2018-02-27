ADD_GDAL_DRIVER(TARGET ogr_MVT SOURCES
                mvt_tile.cpp mvt_tile.h mvtutils.cpp mvtutils.h
                ogrmvtdataset.cpp)

target_include_directories(ogr_MVT PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_Frmts/osm>)
#gdal_target_link_libraries(TARGET ogr_MVT
#                           LIBRAREIS $<TARGET_OBJECTS:ogr_osm>)
if(HAVE_GEOS)
    target_include_directories(ogr_MVT PRIVATE ${GEOS_INCLUDE_DIRS})
    target_compile_definitions(ogr_MVT PRIVATE -DHAVE_GEOS=1)
    gdal_target_link_libraries(TARGET ogr_MVT LIBRARIES ${GEOS_LIBRARIES})
endif()

if(HAVE_SQLITE)
    target_include_directories(ogr_MVT PRIVATE ${SQLITE_INCLUDE_DIRS})
    target_compile_definitions(ogr_MVT PRIVATE -DHAVE_SQLITE)
    gdal_target_link_libraries(TARGET ogr_MVT
                               LIBRARIES ${SSQLITE_LIBRARIES})
endif()
