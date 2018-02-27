ADD_GDAL_DRIVER(TARGET ogr_GML SOURCES
    gfstemplate.cpp      gmlpropertydefn.cpp  gmlreadstate.cpp  gmlutils.h            ogrgmldriver.cpp  resolvexlinks.cpp
    gmlfeature.cpp       gmlreader.cpp        gmlregistry.cpp   hugefileresolver.cpp  ogrgmllayer.cpp   xercesc_headers.h
    gmlfeatureclass.cpp  gmlreader.h          gmlregistry.h     ogr_gml.h             parsexsd.cpp
    gmlhandler.cpp       gmlreaderp.h         gmlutils.cpp      ogrgmldatasource.cpp  parsexsd.h
BUILTIN  )
gdal_driver_standard_includes(ogr_GML)

if(HAVE_EXPAT)
    target_include_directories(ogr_GML PRIVATE ${EXPAT_INCLUDE_DIRS})
    target_compile_definitions(ogr_GML PRIVATE -DHAVE_EXPAT)
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_GML LIBRARIES ${EXPAT_LIBRARIES})
endif()

if(HAVE_XERCESC)
    target_include_directories(ogr_GML PRIVATE ${XercesC_INCLUDE_DIRS}
                                               ${XercesC_INCLUDE_DIRS}/xercesc)
    target_compile_definitions(ogr_GML PRIVATE -DHAVE_XERCES)
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_GML LIBRARIES  XercesC::XercesC)
endif()

if(HAVE_SQLITE3)
    TARGET_INCLUDE_DIRECTORIES(ogr_GML PRIVATE  ${SQLITE3_INCLUDE_DIRS})
    TARGET_COMPILE_DEFINITIONS(ogr_GML PRIVATE  -DHAVE_SQLITE)
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_GML LIBRARIES SQLITE3::SQLITE3)
endif()

