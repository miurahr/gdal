# should not be a plugin - dependency from elastic
# and it has multiple drivers in one module
ADD_GDAL_DRIVER(TARGET ogr_TopoJSON SOURCES
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
gdal_driver_standard_includes(ogr_TopoJSON)
target_include_directories(ogr_TopoJSON PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/apps>)

if(GDAL_USE_LIBJSONC_INTERNAL)
    target_include_directories(ogr_TopoJSON
                                PRIVATE  $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson/libjson>)
else()
    target_include_directories(ogr_TopoJSON PRIVATE ${JSONC_INCLUDE_DIR})
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_TopoJSON LIBRARIES ${JSONC_LIBRARY})
endif()
