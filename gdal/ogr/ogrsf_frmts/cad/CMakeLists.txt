ADD_GDAL_DRIVER(TARGET ogr_CAD SOURCES
               ogr_cad.h gdalcaddataset.cpp ogrcaddriver.cpp ogrcadlayer.cpp vsilfileio.cpp vsilfileio.h)
gdal_standard_includes(ogr_CAD)

if(GDAL_USE_OPENCAD_INTERNAL)
    TARGET_INCLUDE_DIRECTORIES(ogr_CAD PRIVATE $<TARGET_PROPERTY:libopencad,SOURCE_DIR>)
else()
    TARGET_INCLUDE_DIRECTORIES(ogr_CAD
            PRIVATE ${OPENCAD_INCLUDE_DIRS})
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_CAD
            LIBRARIES ${OPENCAD_LIBRARIES})
endif()
