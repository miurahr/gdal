
if(GDAL_USE_CURL)
    GDAL_DRIVER(TARGET ogr_Cloudant
        SOURCES ogr_cloudant.h
                ogrcloudantdatasource.cpp
                ogrcloudantdriver.cpp
                ogrcloudanttablelayer.cpp
        INCLUDES ${COUCHDB_INCLUDE_DIR} ${CURL_INCLUDE_DIR}
                $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>
                $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/couchdb>
        LIBRARIES ${CURL_LIBRARY} ${COUCHDB_LIBRARY})
endif()