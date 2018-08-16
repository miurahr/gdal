# it provides AAIGrid and GRASSASCIIGrid
ADD_GDAL_DRIVER(TARGET gdal_AAIGrid SOURCES aaigriddataset.cpp aaigriddataset.h BUILTIN)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_AAIGrid)

