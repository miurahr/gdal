#depend from frmts/aigrid
ADD_GDAL_DRIVER(TARGET  ogr_AVCBin
    SOURCES
        avc.h
        ogr_avc.h
        avc_bin.cpp
        avc_rawbin.cpp
        avc_binwr.cpp
        avc_e00gen.cpp
        avc_e00parse.cpp
        avc_e00write.cpp
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
gdal_standard_includes(ogr_AVCBin)
target_include_directories(ogr_AVCBin PRIVATE $<TARGET_PROPERTY:ogr_Shape,SOURCE_DIR>)

