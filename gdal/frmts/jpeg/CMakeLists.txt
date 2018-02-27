ADD_GDAL_DRIVER(TARGET gdal_JPEG SOURCES
                    vsidataio.h
                    jpgdataset.h
                    vsidataio.cpp
                    jpgdataset.cpp
                BUILTIN)
gdal_standard_includes(gdal_JPEG)
target_include_directories(gdal_JPEG PRIVATE
                   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/mem>)
if(GDAL_JPEG12_SUPPORTED)
    target_sources(gdal_JPEG PRIVATE
            jpgdataset_12.cpp
            vsidataio_12.cpp)
endif()

if(GDAL_USE_LIBJPEG_INTERNAL)
	target_include_directories(gdal_JPEG
	    PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/jpeg/libjpeg>)
else()
	target_include_directories(gdal_JPEG
		PRIVATE ${JPEG_INCLUDE_DIRS})
	GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_JPEG
		LIBRARIES JPEG::JPEG)
endif()

if(GDAL_USE_LIBZ_INTERNAL)
	target_include_directories(gdal_JPEG
		PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/zlib>)
else()
	target_include_directories(gdal_JPEG
		PRIVATE {ZLIB_INCLUDE_DIRS})
	GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_JPEG
		LIBRARIES ZLIB::ZLIB)
endif()

