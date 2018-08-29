# depends from gpkg
ADD_GDAL_DRIVER(TARGET ogr_SQLite BUILTIN SOURCES
        ogr_sqlite.h
        ogrsqlite3ext.h
        ogrsqliteexecutesql.h
        ogrsqlitesqlfunctions.h
        ogrsqlitevirtualogr.h
        ogrsqliteutility.h
        ogrsqlitedatasource.cpp
        ogrsqlitedriver.cpp
        ogrsqlitelayer.cpp
        ogrsqliteselectlayer.cpp
        ogrsqlitesinglefeaturelayer.cpp
        ogrsqlitetablelayer.cpp
        ogrsqlitevfs.cpp
        ogrsqliteviewlayer.cpp
        ogrsqliteexecutesql.cpp
        ogrsqlitevirtualogr.cpp
        ogrsqliteutility.cpp
        ogrsqliteapiroutines.c
        rasterlite2_header.h
        rasterlite2.cpp)
gdal_standard_includes(ogr_SQLite)

if(HAVE_SQLITE3)
    target_include_directories(ogr_SQLite PRIVATE ${SQLITE3_INCLUDE_DIR})
    target_compile_definitions(ogr_SQLite PRIVATE -DHAVE_SQLITE)
    gdal_target_link_libraries(TARGET ogr_SQLite LIBRARIES SQLITE3::SQLITE3)
    if(HAVE_SQLITE3_PCRE)
        gdal_target_link_libraries(TARGET ogr_SQLite LIBRARIES SQLITE3::PCRE)
        target_compile_definitions(ogr_SQLite PRIVATE -DHAVE_PCRE)
    endif()
    if(SQLITE_HAS_COLUMN_METADATA)
        target_compile_definitions(ogr_SQLite PRIVATE -DSQLITE_HAS_COLUMN_METADATA)
    endif()
endif()
if(HAVE_SPATIALITE)
    target_include_directories(ogr_SQLite PRIVATE ${SPATIALITE_INCLUDE_DIRS})
    get_filename_component(SPATIALITE_SONAME ${SPATIALITE_LIBRARY} NAME CACHE)
    target_compile_definitions(ogr_SQLite PRIVATE -DHAVE_SPATIALITE -DSPATIALITE_DLOPEN -DSPATIALITE_412_OR_LATER -DSPATIALITE_SONAME="${SPATIALITE_SONAME}")
    gdal_target_link_libraries(TARGET ogr_SQLite LIBRARIES ${SPATIALITE_LIBRARY})
    if(SPATIALITE_AMALGAMATION)
        target_compile_definitions(ogr_SQLite PRIVATE -DSPATIALITE_AMALGAMATION)
    endif()
endif()
if(HAVE_RASTERLITE2)
    target_include_directories(ogr_SQLite PRIVATE ${RASTERLITE2_INCLUDE_DIRS})
    target_compile_definitions(ogr_SQLite PRIVATE -DHAVE_RASTERLITE2)
    gdal_target_link_libraries(TARGET ogr_SQLite LIBRARIES RASTERLITE2::RASTERLITE2)
endif()

add_executable(test_load_virtual_ogr EXCLUDE_FROM_ALL test_load_virtual_ogr.c)