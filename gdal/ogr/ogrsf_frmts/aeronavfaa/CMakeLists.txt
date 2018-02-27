GDAL_DRIVER(TARGET ogr_AeronavFAA
    SOURCES ogr_aeronavfaa.h ograeronavfaadatasource.cpp ograeronavfaadriver.cpp ograeronavfaalayer.cpp
    INCLUDES $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/xplane>)
