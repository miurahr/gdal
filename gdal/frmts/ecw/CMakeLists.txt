option(GDAL_ENABLE_ECW_PLUGIN "On to build ECW driver as plugin" ON)
set(_SOURCES ecwsdk_headers.h gdal_ecw.h
             ecwdataset.cpp ecwcreatecopy.cpp ecwasyncreader.cpp jp2userbox.cpp)
if(GDAL_ENABLE_ECW_PLUGIN)
    add_gdal_driver(TARGET gdal_ECW_JP2ECW SOURCES ${_SOURCES} PLUGIN)
else()
    add_gdal_driver(TARGET gdal_ECW_JP2ECW SOURCES ${_SOURCES})
endif()
unset(_SOURCES)
gdal_standard_includes(gdal_ECW_JP2ECW)
target_include_directories(gdal_ECW_JP2ECW PRIVATE ${ECW_INCLUDE_DIRS})
target_compile_definitions(gdal_ECW_JP2ECW PRIVATE
                           -DFRMT_ecw
                           -DDO_NOT_USE_DEBUG_BOOL)
gdal_target_link_libraries(TARGET gdal_ECW_JP2ECW LIBRARIES
                           ECW::ECW ECW::ECWC ECW::ECWnet ECW::NCSUtil)

if(HAVE_ECW_BUILDNUMBER_H)
    target_compile_definitions(gdal_ECW_JP2ECW PRIVATE -DHAVE_ECW_BUILDNUMBER_H)
endif()

