ADD_GDAL_DRIVER(TARGET gdal_vrt BUILTIN SOURCES
                gdal_vrt.h
                vrtdataset.h
                vrtderivedrasterband.cpp
                vrtdriver.cpp
                vrtfilters.cpp
                vrtrasterband.cpp
                vrtrawrasterband.cpp
                vrtsourcedrasterband.cpp
                vrtsources.cpp
                vrtwarped.cpp
                vrtdataset.cpp
        pixelfunctions.cpp
        vrtpansharpened.cpp
)
gdal_standard_includes(gdal_vrt)
target_include_directories(gdal_vrt PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/alg>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/raw>)
if(HAVE_GEOS)
    target_include_directories(gdal_vrt PRIVATE
                               $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/raw>
                               ${GEOS_INCLUDE_DIRS})
    GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_vrt LIBRARIES ${GEOS_LIBRARIES})
    target_compile_definitions(gdal_vrt PRIVATE	-DHAVE_GEOS=1)
else()
    target_include_directories(gdal_vrt PRIVATE
                               $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/raw>)
endif()
