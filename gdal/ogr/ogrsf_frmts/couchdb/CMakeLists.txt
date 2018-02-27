GDAL_DRIVER(TARGET ogr_CouchDB SOURCES
        ogr_couchdb.h
        ogrcouchdbdatasource.cpp
        ogrcouchdbdriver.cpp
        ogrcouchdblayer.cpp
        ogrcouchdbrowslayer.cpp
        ogrcouchdbtablelayer.cpp
    INCLUDES ${CouchDB_INCLUDE_DIR}
             $<BULD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>
    LIBRARIES ${CouchDB_LIBRARIES}
)
