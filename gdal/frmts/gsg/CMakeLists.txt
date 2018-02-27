# Driver gdal_GSAG and gdal_GSBG are built in
ADD_GDAL_DRIVER(TARGET gdal_GSG SOURCES gs7bgdataset.cpp gsagdataset.cpp gsbgdataset.cpp BUILTIN)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_GSG)
