ADD_GDAL_DRIVER(TARGET gdal_WCS
    SOURCES gmlcoverage.cpp gmlcoverage.h httpdriver.cpp wcsdataset.cpp wcsdataset.h 
            wcsdataset100.cpp wcsdataset110.cpp wcsdataset201.cpp wcsrasterband.cpp
            wcsrasterband.h wcsutils.cpp)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_WCS)
target_include_directories(gdal_WCS PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/gml>)
