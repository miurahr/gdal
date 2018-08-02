ADD_GDAL_DRIVER(TARGET gdal_EPSILON
    SOURCES   epsilondataset.cpp
)
GDAL_STANDARD_INCLUDES(gdal_EPSILON)

target_include_directories(gdal_EPSILON PRIVATE ${EPSILON_INCLUDE_DIRS})
gdal_target_link_libraries(TARGET gdal_EPSILON LIBRARIES ${EPSILON_LIBRARIES})
