add_gdal_driver(TARGET ogr_Geomedia
                SOURCES ogr_geomedia.h ogrgeomediadatasource.cpp ogrgeomediadriver.cpp
                       ogrgeomedialayer.cpp ogrgeomediaselectlayer.cpp
                       ogrgeomediatablelayer.cpp)
target_include_directories(ogr_Geomedia PRIVATE $<TARGET_PROPERTY:ogr_PGeo,SOURCE_DIR>)
