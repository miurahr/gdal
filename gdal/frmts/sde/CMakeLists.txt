ADD_GDAL_DRIVER(TARGET gdal_SDE
    SOURCES gdal_sde.h sdedataset.h sderasterband.h
            sdedataset.cpp sdeerror.cpp sderasterband.cpp)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_SDE)
target_include_directories(gdal_SDE PRIVATE ${SDE_INCLUDE_DIRS}
        $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/iso8211>
        $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/shapelib>)
GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_SDE LIBRARIES ${SDE_LIBRARIES})
