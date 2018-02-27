ADD_GDAL_DRIVER(TARGET gdal_PCRaster SOURCES
        pcrasterdataset.h
        pcrasterrasterband.h
        pcrasterutil.h
        pcrasterdataset.cpp
        pcrastermisc.cpp
        pcrasterrasterband.cpp
        pcrasterutil.cpp
)
gdal_driver_standard_includes(gdal_PCRaster)
if(GDAL_USE_LIBCSF_INTERNAL)
    target_include_directories(gdal_PCRaster PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/pcraster/libcsf>)
else()
    target_include_directories(gdal_PCRaster PRIVATE ${LIBCSF_INCLUDE_DIRS})
    gdal_target_link_libraries(TARGET gdal_PCRaster LIBRARIES ${LIBCSF_LIBRARIES})
endif()

