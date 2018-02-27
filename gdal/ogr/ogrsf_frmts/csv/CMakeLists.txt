GDAL_DRIVER(TARGET ogr_CSV
    SOURCES ogr_csv.h ogrcsvdatasource.cpp ogrcsvdriver.cpp ogrcsvlayer.cpp
    INCLUDES $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic>
    DEFINITIONS -DTAB_ENABLED)
