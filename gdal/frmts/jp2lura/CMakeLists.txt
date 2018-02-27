
ADD_GDAL_DRIVER(TARGET gdal_JP2LURA SOURCES
        jp2luracallbacks.h
        jp2luradataset.h
        jp2lurarasterband.h
        jp2luracallbacks.cpp
        jp2luradataset.cpp
        jp2lurarasterband.cpp)
gdal_standard_includes(gdal_JP2LURA)
target_include_directories(gdal_JP2LURA PRIVATE ${LURATECH_JP2SDK_DIRECTORY}/include)
gdal_target_link_libraries(TARGET gdal_JP2LURA LIBRARIES ${LURATECH_JP2SDK_LIBRARIES})
