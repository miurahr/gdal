ADD_GDAL_DRIVER(TARGET ogr_Cloudant
        SOURCES ogr_cloudant.h
                ogrcloudantdatasource.cpp
                ogrcloudantdriver.cpp
                ogrcloudanttablelayer.cpp)
gdal_standard_includes(ogr_Cloudant)
target_include_directories(ogr_Cloudant PRIVATE
                           ${CURL_INCLUDE_DIR}
                           ${JSONC_INCLUDE_DIRS}
                           $<TARGET_PROPERTY:ogr_geojson,SOURCE_DIR>
                           $<TARGET_PROPERTY:ogr_CouchDB,SOURCE_DIR>)
gdal_target_link_libraries(TARGET ogr_Cloudant LIBRARIES
                           ${JSONC_LIBRARIES}
                           CURL::libcurl)
