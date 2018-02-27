
add_library(gnm_frmts_file OBJECT
        gnmfile.h
        gnmfiledriver.cpp
        gnmfilenetwork.cpp
)
target_include_directories(gnm_frmts_file PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gnm>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gnm/gnm_frmts>)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:gnm_frmts_file>)
