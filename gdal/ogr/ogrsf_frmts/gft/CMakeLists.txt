ADD_GDAL_DRIVER(TARGET ogr_GFT SOURCES ogr_gft.h ogrgftdatasource.cpp ogrgftdriver.cpp ogrgftlayer.cpp
                ogrgftresultlayer.cpp ogrgfttablelayer.cpp)
gdal_driver_standard_includes(ogr_GFT)
