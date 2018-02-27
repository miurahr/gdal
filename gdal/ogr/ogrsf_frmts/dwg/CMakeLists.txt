GDAL_DRIVER(TARGET ogr_DWG SOURCES
        dgnv8_headers.h
        dwg_headers.h
        ogr_dgnv8.h
        ogr_dwg.h
        createdgnv8testfile_headers.h
        ogrdgnv8datasource.cpp
        ogrdgnv8driver.cpp
        ogrdwg_blockmap.cpp
        ogrdwg_hatch.cpp
        ogrdwgblockslayer.cpp
        ogrdwgdatasource.cpp
        ogrdwgdriver.cpp
    INCLUDES $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/dxf> ${TEIGHA_INCLUDE_DIR}
    LIBRARIES ${TEIGHA_LIBRARIES}
)