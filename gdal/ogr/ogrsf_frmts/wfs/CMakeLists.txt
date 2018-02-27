
ADD_GDAL_DRIVER(TARGET ogr_WFS
                SOURCES ogr_wfs.h ogrwfs3driver.cpp ogrwfsdatasource.cpp ogrwfsdriver.cpp
                ogrwfsfilter.cpp ogrwfsjoinlayer.cpp ogrwfslayer.cpp)
gdal_driver_standard_includes(ogr_WFS)
TARGET_INCLUDE_DIRECTORIES(ogr_WFS
        PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/gml>)
