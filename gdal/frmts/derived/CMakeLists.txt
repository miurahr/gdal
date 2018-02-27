ADD_GDAL_DRIVER(TARGET gdal_Derived SOURCES
                deriveddataset.cpp derivedlist.c derivedlist.h
                BUILTIN)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_Derived)
target_include_directories(gdal_Derived PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts>)

