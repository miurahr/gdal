# should not be a plugin - dependency from elastic
# and it has multiple drivers in one module
ADD_GDAL_DRIVER(TARGET ogr_geojson SOURCES
                    ogrgeojsonreader.h
                    ogrgeojsonutils.h
                    ogrgeojsonwriter.h
                    ogr_geojson.h
                    ogresrijsonreader.cpp
                    ogrgeojsondatasource.cpp
                    ogrgeojsonlayer.cpp
                    ogrgeojsonreader.cpp
                    ogrgeojsonutils.cpp
                    ogrgeojsonwritelayer.cpp
                    ogrgeojsonwriter.cpp
                    ogrtopojsonreader.cpp
                    ogrgeojsondriver.cpp
                    ogrtopojsondriver.cpp
                    ogresrijsondriver.cpp
                BUILTIN)
gdal_driver_standard_includes(ogr_geojson)
target_include_directories(ogr_geojson PRIVATE $<TARGET_PROPERTY:appslib,SOURCE_DIR>)
if(GDAL_USE_LIBJSONC_INTERNAL)
    target_include_directories(ogr_geojson PRIVATE $<TARGET_PROPERTY:libjson,SOURCE_DIR>)
else()
    target_include_directories(ogr_geojson PRIVATE ${JSONC_INCLUDE_DIR})
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_geojson LIBRARIES ${JSONC_LIBRARY})
endif()
