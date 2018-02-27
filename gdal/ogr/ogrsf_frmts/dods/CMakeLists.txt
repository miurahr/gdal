
GDAL_DRIVER(TARGET ogr_DODS SOURCES
        libdap_headers.h
        ogr_dods.h
        ogrdodsdatasource.cpp
        ogrdodsdriver.cpp
        ogrdodsfielddefn.cpp
        ogrdodsgrid.cpp
        ogrdodslayer.cpp
        ogrdodssequencelayer.cpp
    INCLUDES ${DAP_INCLUDE_DIR} ${LIBXML2_INCLUDE_DIR}
    LIBRARIES ${DAP_CLIENT_LIBRARY} ${LIBXML2_LIBRARIES} )

if(DAP_VERSION VERSION_GREATER "3.9" OR
    DAP_VERSION VERSION_EQUAL   "3.9")
    target_compile_definitions(ogr_DODS PRIVATE -DLIBDAP_39)
    if(DAP_VERSION VERSION_GREATER "3.10" OR
        DAP_VERSION VERSION_EQUAL "3.10")
        target_compile_definitions(ogr_DODS PRIVATE -DLIBDAP_310)
    endif()
endif()
