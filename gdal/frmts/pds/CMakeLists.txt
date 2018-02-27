#depend from hdf4 and ogr_PDS
ADD_GDAL_DRIVER(TARGET gdal_PDS SOURCES
        nasakeywordhandler.h
        vicarkeywordhandler.h
        isis2dataset.cpp
        isis3dataset.cpp
        nasakeywordhandler.cpp
        pdsdataset.cpp
        pds4dataset.cpp
        vicardataset.cpp
        vicarkeywordhandler.cpp
                BUILTIN
)
gdal_driver_standard_includes(gdal_PDS)
target_include_directories(gdal_PDS PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/raw>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/vrt>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>)
IF(GDAL_USE_LIBJSONC_INTERNAL)
    target_include_directories(gdal_PDS PRIVATE
                               $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson/libjson>)
else()
    target_include_directories(gdal_PDS PRIVATE ${JSONC_INCLUDE_DIR})
    gdal_target_link_libraries(TARGET gdal_PDS LIBRARIES ${JSONC_LIBRARY})
endif()
