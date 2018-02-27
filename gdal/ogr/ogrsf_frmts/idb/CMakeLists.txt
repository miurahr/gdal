GDAL_DRIVER(TARGET ogr_IDB SOURCES
            ogr_idb.h ogridbdatasource.cpp ogridbdriver.cpp ogridblayer.cpp ogridbselectlayer.cpp ogridbtablelayer.cpp
    DEFINITIONS -DIT_DLLIB -DIT_DO_NOT_SIMULATE_BOOL
    INCLUDES ${IDB_INCLUDE_DIRS}
    LIBRARIES ${IDB_LIBRARIES})
gdal_driver_standard_includes(ogr_IDB)