ADD_GDAL_DRIVER(TARGET gdal_PNG
			SOURCES pngdataset.cpp pngdataset.h BUILTIN)
target_include_directories(gdal_PNG PRIVATE
						   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts>
						   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr>
						   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts>
						   )
if(GDAL_USE_LIBPNG_INTERNAL)
	target_include_directories(gdal_PNG PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/png/libpng>)
else()
	target_include_directories(gdal_PNG PRIVATE PNG::PNG)
	GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_PNG LIBRARIES PNG::PNG)
endif()

#check zip and internal zip
if(GDAL_USE_LIBZ_INTERNAL)
	target_include_directories(gdal_PNG PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/zlib>)
else()
	target_include_directories(gdal_PNG PRIVATE ${ZLIB_INCLUDE_DIRS})
	GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_PNG LIBRARIES ${ZLIB_LIBRARIES})
endif()
