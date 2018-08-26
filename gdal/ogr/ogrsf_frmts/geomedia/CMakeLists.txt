add_gdal_driver(TARGET ogr_Geomedia
                SOURCE ogr_geomedia.h ogrgeomediadatasource.cpp ogrgeomediadriver.cpp
                       ogrgeomedialayer.cpp ogrgeomediaselectlayer.cpp
                       ogrgeomediatablelayer.cpp)
target_include_directories(ogr_Geomedia $<TARGET_PROPERTY:ogr_PGeo,SOURCE_DIR>)
