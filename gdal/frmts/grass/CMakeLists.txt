# FIXME: grass_version
set(GRASS_VERSION 7)
ADD_GDAL_DRIVER(TARGET gdal_GRASS SOURCES   grass57dataset.cpp)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_GRASS)
target_include_directories(gdal_GRASS PRIVATE  ${GRASS_INCLUDE_DIR${GRASS_VERSION}})
GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_GRASS LIBRARIES -L${GRASS_PREFIX${GRASS_VERSION}}/lib/ -lgrass_raster -lgrass_imagery -lgrass_gproj -lgrass_gmath -lgrass_gis -lgrass_datetime)
target_compile_definitions(gdal_GRASS PRIVATE -DGRASS_VERSION_MAJOR=${GRASS_VERSION}
                           -DGRASS_GISBASE="${GRASS_PREFIX${GRASS_VERSION}}")
