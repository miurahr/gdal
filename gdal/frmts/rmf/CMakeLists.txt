ADD_GDAL_DRIVER(TARGET gdal_RMF SOURCES rmfdataset.h  rmfdataset.cpp rmfdem.cpp rmflzw.cpp rmfjpeg.cpp)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_RMF)