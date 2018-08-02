ADD_GDAL_DRIVER(TARGET gdal_PostGISRaster SOURCES
			postgisraster.h
			postgisrasterdataset.cpp
			postgisrasterdriver.cpp
			postgisrasterrasterband.cpp
			postgisrastertiledataset.cpp
			postgisrastertilerasterband.cpp
			postgisrastertools.cpp)
gdal_standard_includes(gdal_PostGISRaster)
target_include_directories(gdal_PostGISRaster PRIVATE $<TARGET_PROPERTY:gdal_vrt,SOURCE_DIR>
		                   ${POSTGRES_INCLUDE_DIR}
)
GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_PostGISRaster LIBRARIES ${POSTGRES_LIBRARY})
target_compile_definitions(gdal_PostGISRaster PRIVATE -DHAVE_PG)
