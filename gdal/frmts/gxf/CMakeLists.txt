ADD_GDAL_DRIVER(TARGET gdal_GXF SOURCES
            gxf_ogcwkt.c gxf_proj4.c gxfdataset.cpp
            gxfopen.c gxfopen.h)
GDAL_STANDARD_INCLUDES(gdal_GXF)
