ADD_GDAL_DRIVER(TARGET gdal_DODS
                SOURCES libdap_headers.h dodsdataset2.cpp)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_DODS)
target_include_directories(gdal_DODS PRIVATE
                           ${DAP_INCLUDE_DIR} ${LIBXML2_INCLUDE_DIR})
GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_DODS
                           LIBRARIES ${DAP_LIBRARY} ${DAP_CLIENT_LIBRARY} ${LIBXML2_LIBRARY})
if(DAP_VERSION VERSION_GREATER 3.10 OR DAP_VESRION VERSION_EQUAL 3.10)
    target_compile_definitions(gdal_DODS PRIVATE
         DEFINITIONS -DLIBDAP_310)
endif()
if(DAP_VERSION VERSION_GREATER 3.9 OR DAP_VESRION VERSION_EQUAL 3.9)
    target_compile_definitions(gdal_DODS PRIVATE
         DEFINITIONS -DLIBDAP_39)
endif()
