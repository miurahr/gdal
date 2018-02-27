#dependency from geomedia
GDAL_DRIVER(TARGET ogr_PGeo
            SOURCES ogr_pgeo.h ogrpgeodatasource.cpp ogrpgeodriver.cpp ogrpgeolayer.cpp
            ogrpgeotablelayer.cpp ogrpgeoselectlayer.cpp
            FORCE_BUILTIN)