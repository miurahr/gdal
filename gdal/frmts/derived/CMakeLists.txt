ADD_GDAL_DRIVER(TARGET gdal_Derived SOURCES
                deriveddataset.cpp derivedlist.c derivedlist.h
                BUILTIN)
GDAL_STANDARD_INCLUDES(gdal_Derived)
