
add_library(gnm_frmts_db OBJECT
        gnmdb.h
        gnmdbdriver.cpp
        gnmdbnetwork.cpp
)

target_include_directories(gnm_frmts_db PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gnm>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gnm/gnm_frmts>)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:gnm_frmts_db>)
