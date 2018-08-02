ADD_GDAL_DRIVER(TARGET gdal_GEORASTER SOURCES georaster_dataset.cpp georaster_priv.h georaster_rasterband.cpp georaster_wrapper.cpp)
GDAL_STANDARD_INCLUDES(gdal_GEORASTER)
target_include_directories(gdal_GEORASTER PRIVATE $<TARGET_PROPERTY:libz,SOURCE_DIR>)

if(HAVE_OCI)
target_include_directories(gdal_GEORASTER PRIVATE ${OCI_INCLUDE_DIR})
GDAL_TARGET_LINK_LIBRARIES(gdal_GEORASTER PRIVATE ${OCI_LIBRARY})
endif()

if(HAVE_JPEG)
    target_compile_definitions(gdal_GEORASTER PRIVATE -DJPEG_SUPPORTED)
    target_include_directories(gdal_GEORASTER PRIVATE JPEG::JPEG)
    gdal_target_link_libraries(TARGET gdal_GEORASTER LIBRARIES JPEG::JPEG)
endif()
