ADD_GDAL_DRIVER(TARGET ogr_JML SOURCES
            ogr_jml.h ogrjmldataset.cpp ogrjmllayer.cpp ogrjmlwriterlayer.cpp)
gdal_driver_standard_includes(ogr_JML)
target_include_directories(ogr_JML PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/mem>)
if(HAVE_EXPAT)
    target_include_directories(ogr_JML PRIVATE ${EXPAT_INCLUDE_DIRS})
    target_compile_definitions(ogr_JML PRIVATE -DHAVE_EXPAT=1)
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_JML LIBRARIES ${EXPAT_LIBRARY})
endif()
