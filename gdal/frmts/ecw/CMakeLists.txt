ADD_GDAL_DRIVER(TARGET gdal_ECW_JP2ECW
    SOURCES
        ecwsdk_headers.h gdal_ecw.h
        ecwdataset.cpp ecwcreatecopy.cpp ecwasyncreader.cpp jp2userbox.cpp)
GDAL_STANDARD_INCLUDES(gdal_ECW_JP2ECW)
TARGET_INCLUDE_DIRECTORIES(gdal_ECW_JP2ECW PRIVATE ${ECW_INCLUDE_DIR})
TARGET_COMPILE_DEFINITIONS(gdal_ECW_JP2ECW PRIVATE
                           -DFRMT_ecw
                           -DDO_NOT_USE_DEBUG_BOOL
                           #-DHAVE_ECW_BUILDNUMBER_H
                           #-DECWSDK_VERSION=${ECW_VERSION_STRING}
)
GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_ECW_JP2ECW LIBRARIES
                           ECW::ECW ECW::ECWC ECW::ECWnet ECW::NCSUtil)