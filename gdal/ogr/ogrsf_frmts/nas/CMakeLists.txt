ADD_GDAL_DRIVER(TARGET ogr_NAS
            SOURCES nashandler.cpp  nasreader.cpp  nasreaderp.h  ogr_nas.h  ogrnasdatasource.cpp  ogrnasdriver.cpp  ogrnaslayer.cpp  ogrnasrelationlayer.cpp
            )
gdal_driver_standard_includes(ogr_NAS)
TARGET_INCLUDE_DIRECTORIES(ogr_NAS
                                PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/gml>)

if(HAVE_EXPAT)
    TARGET_INCLUDE_DIRECTORIES(ogr_NAS
        PRIVATE ${EXPAT_INCLUDE_DIRS})
    TARGET_COMPILE_DEFINITIONS(ogr_NAS
        PRIVATE -DHAVE_EXPAT)
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_NAS
        LIBRARIES ${EXPAT_LIBRARIES})
endif()

if(HAVE_XERCESC)
    foreach(d ${XercesC_INCLUDE_DIRS})
        TARGET_INCLUDE_DIRECTORIES(ogr_NAS
                                        PRIVATE ${d}
                                                 ${d}/xercesc)
    endforeach()
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_NAS
            LIBRARIES ${XercesC_LIBRARIES})
    TARGET_COMPILE_DEFINITIONS(ogr_NAS
            PRIVATE -DHAVE_XERCES)
endif()
