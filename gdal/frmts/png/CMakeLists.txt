ADD_GDAL_DRIVER(TARGET gdal_PNG
			SOURCES pngdataset.cpp pngdataset.h BUILTIN)
gdal_standard_includes(gdal_PNG)

if(GDAL_USE_LIBPNG_INTERNAL)
	target_include_directories(gdal_PNG PRIVATE $<TARGET_PROPERTY:libpng,SOURCE_DIR>)
else()
	target_include_directories(gdal_PNG PRIVATE PNG::PNG)
	GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_PNG LIBRARIES PNG::PNG)
endif()

if(GDAL_USE_LIBZ_INTERNAL)
	target_include_directories(gdal_PNG PRIVATE $<TARGET_PROPERTY:libz,SOURCE_DIR>)
else()
	target_include_directories(gdal_PNG PRIVATE ${ZLIB_INCLUDE_DIRS})
	GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_PNG LIBRARIES ${ZLIB_LIBRARIES})
endif()
