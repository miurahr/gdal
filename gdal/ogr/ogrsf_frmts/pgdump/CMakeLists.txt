# depend from pg
ADD_GDAL_DRIVER(TARGET ogr_PGDump SOURCES ogr_pgdump.h ogrpgdumpdriver.cpp ogrpgdumpdatasource.cpp ogrpgdumplayer.cpp BUILTIN)
gdal_standard_includes(ogr_PGDump)