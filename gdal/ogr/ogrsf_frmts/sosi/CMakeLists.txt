GDAL_DRIVER(TARGET ogr_SOSI SOURCES
        ogr_sosi.h
        ogrsosidatatypes.h
        fyba_melding.cpp
        ogrsosidatasource.cpp
        ogrsosidatatypes.cpp
        ogrsosidriver.cpp
        ogrsosilayer.cpp
    INCLUDES $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic>
              ${SOSI_INCLUDE_DIR}
    LIBRARIES ${SOSI_LIBRARIES}
)

if(CMAKE_HOST_UNIX)
    target_compile_definitions(ogr_SOSI PRIVATE -DUNIX)
endif()
if(CMAKE_SYSTEM_NAME EQUAL "Linux")
    target_compile_definitions(ogr_SOSI PRIVATE -DLINUX)
endif()