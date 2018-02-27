add_library(gnm_frmts OBJECT
            gnm_frmts.h gnmregisterall.cpp)
target_include_directories(gnm_frmts PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gnm>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gnm/gnm_frmts>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
           )
target_compile_definitions(gnm_frmts PRIVATE -DGNMFILE_ENABLED -DGNMDB_ENABLED)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:gnm_frmts>)

add_subdirectory(db)
add_subdirectory(file)
