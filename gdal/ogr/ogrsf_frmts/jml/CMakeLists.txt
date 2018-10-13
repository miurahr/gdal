add_gdal_driver(TARGET ogr_JML SOURCES
                ogr_jml.h ogrjmldataset.cpp ogrjmllayer.cpp ogrjmlwriterlayer.cpp)
gdal_driver_standard_includes(ogr_JML)
target_include_directories(ogr_JML PRIVATE $<TARGET_PROPERTY:ogr_MEM,SOURCE_DIR>)
if(HAVE_EXPAT)
    target_include_directories(ogr_JML PRIVATE ${EXPAT_INCLUDE_DIRS})
    target_compile_definitions(ogr_JML PRIVATE -DHAVE_EXPAT=1)
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_JML LIBRARIES ${EXPAT_LIBRARY})
endif()
