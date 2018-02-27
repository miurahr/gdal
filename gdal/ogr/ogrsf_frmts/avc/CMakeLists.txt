#depend from frmts/aigrid
GDAL_DRIVER(TARGET  ogr_AVCBin FORCE_BUILTIN
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
        avc_misc.cpp
        ogravcbindatasource.cpp
        ogravcbindriver.cpp
        ogravcbinlayer.cpp
        ogravce00datasource.cpp
        ogravcdatasource.cpp
        ogravce00driver.cpp
        ogravce00layer.cpp
        ogravclayer.cpp
    INCLUDES $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/shape>)

