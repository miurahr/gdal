GDAL_DRIVER(TARGET ogr_FileGDB SOURCES
        FGdbUtils.h
        FGdbDatasource.cpp
        FGdbDriver.cpp
        FGdbLayer.cpp
        FGdbResultLayer.cpp
        FGdbUtils.cpp
    INCLUDES ${FILEGDB_INCLUDE_DIR}
             $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic>
    LIBRARIES ${FILEGDB_LIBRARY})
gdal_driver_standard_includes(ogr_FileGDB)