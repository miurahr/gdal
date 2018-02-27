GDAL_DRIVER(TARGET ogr_AmigoCloud
    SOURCES
        ogr_amigocloud.h
        ogramigoclouddatasource.cpp
        ogramigoclouddriver.cpp
        ogramigocloudlayer.cpp
        ogramigocloudresultlayer.cpp
        ogramigocloudtablelayer.cpp
    INCLUDES $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/pgdump>
            $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>
            ${JSONC_INCLUDE_DIRS}
    LIBRARIES ${JSONC_LIBRARIES})
