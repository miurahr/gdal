#FIXME currently only version 7 is suppoted
set(GRASS_VERSION 7)
GDAL_DRIVER(TARGET ogr_GRASS
    DEFINITIONS -DGRASS_GISBASE="${GRASS_PREFIX${GRASS_VERSION}}"
                -DGRASS_VERSION_MAJOR=${GRASS_VERSION}
                -DUSE_CPL
    INCLUDES ${GRASS_INCLUDE_DIR${GRASS_VERSION}}
             ${PostgreSQL_INCLUDE_DIRS}
    LIBRARIES -L${GRASS_PREFIX${GRASS_VERSION}}/lib
              -lgrass_vector -lgrass_dig2 -lgrass_dgl -lgrass_rtree
              -lgrass_linkm -lgrass_dbmiclient -lgrass_dbmibase
              -lgrass_gproj -lgrass_gmath -lgrass_gis -lgrass_datetime
              ${PostgreSQL_LIBRARIES})
