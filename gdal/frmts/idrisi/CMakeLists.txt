# RST -- idrist RASTER driver refered from ogr_idrisi
add_gdal_driver(TARGET gdal_IDRISI SOURCES IdrisiDataset.cpp idrisi.h BUILTIN)
gdal_standard_includes(gdal_IDRISI)

if(GDAL_ENABLE_PLUGIN)
    target_compile_definitions(gdal_IDRISI PRIVATE -DGDAL_RST_PLUGIN)
endif()
