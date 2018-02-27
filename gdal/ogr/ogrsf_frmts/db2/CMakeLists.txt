GDAL_DRIVER(TARGET ogr_DB2  SOURCES  ogr_db2.h
        gdaldb2rasterband.cpp
        ogrdb2cli.cpp
        ogrdb2datasource.cpp
        ogrdb2datasourcemd.cpp
        ogrdb2driver.cpp
        ogrdb2geometryvalidator.cpp
        ogrdb2layer.cpp
        ogrdb2selectlayer.cpp
        ogrdb2tablelayer.cpp
    INCLUDES $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/mem>
             $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/mem>
             ${DB2_INCLUDE_DIR}
    LIBRARIES ${DB2_LIBRARIES})
