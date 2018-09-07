# depends from frmts/aigrid, avc
add_gdal_driver(TARGET ogr_Shape SOURCES
        ogrshape.h
        shapefil.h
        dbfopen.c
        shpopen.c
        shptree.c
        shp_vsi.c
        ogrshapedatasource.cpp
        ogrshapedriver.cpp
        ogrshapelayer.cpp
        shape2ogr.cpp
        sbnsearch.c
                BUILTIN)
gdal_standard_includes(ogr_Shape)
target_include_directories(ogr_Shape PRIVATE $<TARGET_PROPERTY:ogrsf_generic,SOURCE_DIR>)
target_compile_definitions(ogr_Shape PRIVATE -DDSHAPELIB_DLLEXPORT -DSAOffset=vsi_l_offset)
if(USE_CPL)
    target_compile_definitions(ogr_Shape PRIVATE -DUSE_CPL)
endif()

