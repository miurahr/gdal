GDAL_DRIVER(TARGET ogr_PG SOURCES ogr_pg.h ogrpgutility.h
	ogrpgdatasource.cpp ogrpgdriver.cpp ogrpglayer.cpp
	ogrpgresultlayer.cpp ogrpgtablelayer.cpp ogrpgutility.cpp
    INCLUDES ${POSTGRES_INCLUDE_DIR} $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/pgdump>
    LIBRARIES  ${POSTGRES_LIBRARY} 
    DEFINITIONS -DHAVE_PG
)