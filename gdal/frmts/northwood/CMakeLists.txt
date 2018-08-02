GDAL_DRIVER(TARGET gdal_NWT_GRD
            SOURCES grcdataset.cpp grddataset.cpp northwood.cpp northwood.h
            INCLUDES $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/mitab>)
