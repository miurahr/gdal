# refered from ogr_idrisi
add_gdal_driver(TARGET gdal_IDRISI SOURCES IdrisiDataset.cpp idrisi.h BUILTIN)
gdal_standard_includes(gdal_IDRISI)
