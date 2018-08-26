add_gdal_driver(TARGET gdal_ECW_JP2ECW
                SOURCES  ecwsdk_headers.h gdal_ecw.h
                ecwdataset.cpp ecwcreatecopy.cpp ecwasyncreader.cpp jp2userbox.cpp)
gdal_standard_includes(gdal_ECW_JP2ECW)
if(HAVE_ECW)
    target_include_directories(gdal_ECW_JP2ECW PRIVATE ${ECW_INCLUDE_DIRS})
    # FIXME: here should check ecw version and add proper definitions
    target_compile_definitions(gdal_ECW_JP2ECW PRIVATE
                               -DFRMT_ecw
                               -DDO_NOT_USE_DEBUG_BOOL
                               #-DHAVE_ECW_BUILDNUMBER_H
                               #-DECWSDK_VERSION=${ECW_VERSION_STRING}
    )
    gdal_target_link_libraries(TARGET gdal_ECW_JP2ECW LIBRARIES
                               ECW::ECW ECW::ECWC ECW::ECWnet ECW::NCSUtil)
endif()
