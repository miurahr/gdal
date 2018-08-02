
ADD_GDAL_DRIVER(TARGET gdal_GIF
    SOURCES gifabstractdataset.h gifabstractdataset.cpp biggifdataset.cpp gifdataset.cpp
            BUILTIN)
GDAL_STANDARD_INCLUDES(gdal_GIF)
target_compile_definitions(gdal_GIF PRIVATE -DHAVE_GIF)

if(GDAL_USE_GIFLIB_INTERNAL)
    target_include_directories(gdal_GIF PRIVATE $<TARGET_PROPERTY:giflib,SOURCE_DIR>)
else()
    target_include_directories(gdal_GIF PRIVATE ${GIF_INCLUDE_DIR})
    GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_GIF LIBRARIES ${GIF_LIBRARIES})
endif()
