#depend from frmts/aigrid
add_gdal_driver(TARGET  ogr_AVC DEF AVC_ENABLED
    SOURCES
        avc.h
        ogr_avc.h
        avc_bin.cpp
        avc_rawbin.cpp
        #avc_binwr.cpp
        avc_e00gen.cpp
        avc_e00parse.cpp
        #avc_e00write.cpp
        avc_e00read.cpp
        avc_mbyte.cpp
        avc_mbyte.h
        avc_misc.cpp
        ogravcbindatasource.cpp
        ogravcbindriver.cpp
        ogravcbinlayer.cpp
        ogravce00datasource.cpp
        ogravcdatasource.cpp
        ogravce00driver.cpp
        ogravce00layer.cpp
        ogravclayer.cpp
                BUILTIN)
gdal_standard_includes(ogr_AVC)
target_include_directories(ogr_AVC PRIVATE $<TARGET_PROPERTY:ogr_Shape,SOURCE_DIR>)


if(RENAME_INTERNAL_SHAPELIB_SYMBOLS)
    target_compile_definitions(ogr_AVC PRIVATE -DRENAME_INTERNAL_SHAPELIB_SYMBOLS -DSHPAPI_CALL= )
endif()
