ADD_GDAL_DRIVER(TARGET gdal_PostGISRaster
		SOURCES
			postgisraster.h
			postgisrasterdataset.cpp
			postgisrasterdriver.cpp
			postgisrasterrasterband.cpp
			postgisrastertiledataset.cpp
			postgisrastertilerasterband.cpp
			postgisrastertools.cpp)
gdal_driver_standard_includes(gdal_PostGISRaster)
target_include_directories(gdal_PostGISRaster PRIVATE
		                   ${POSTGRES_INCLUDE_DIR}
					       $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/vrt>
)
GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_PostGISRaster LIBRARIES ${POSTGRES_LIBRARY})
target_compile_definitions(gdal_PostGISRaster PRIVATE -DHAVE_PG)
