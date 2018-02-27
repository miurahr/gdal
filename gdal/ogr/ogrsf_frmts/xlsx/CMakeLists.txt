ADD_GDAL_DRIVER(TARGET ogr_XLSX SOURCES ogr_xlsx.h ogrxlsxdatasource.cpp ogrxlsxdriver.cpp)
gdal_driver_standard_includes(ogr_XLSX)
target_include_directories(ogr_XLSX PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/mem>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/mem>)
if(HAVE_EXPAT)
        gdal_target_link_libraries(TARGET ogr_XLSX   LIBRARIES ${EXPAT_LIBRARY})
        target_include_directories(ogr_XLSX PRIVATE ${EXPAT_INCLUDE_DIRS})
        target_compile_definitions(ogr_XLSX PRIVATE -DHAVE_EXPAT)
endif()
