GDAL_DRIVER(TARGET ogr_FME SOURCES
        fme2ogr.h
        ogrfmecacheindex.cpp
        ogrfmedatasource.cpp
        ogrfmedriver.cpp
        ogrfmelayer.cpp
        ogrfmelayercached.cpp
        ogrfmelayerdb.cpp
        fme2ogr_utils.cpp
    INCLUDES ${FME_INCLUDE_DIR}
             $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic>
    DEFINITIONS -DSUPPORT_INDIRECT_FMEDLL -DSUPPORT_PERSISTENT_CACHE
    LIBRARIES ${FME_LIBRARY})
gdal_driver_standard_includes(ogr_FME)