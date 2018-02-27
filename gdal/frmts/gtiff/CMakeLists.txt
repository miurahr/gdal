ADD_GDAL_DRIVER(TARGET gdal_GTIFF SOURCES
	gtiff.h
	gt_jpeg_copy.h
	gt_citation.h
	gt_overview.h
	gt_wkt_srs.h
	gt_wkt_srs_for_gdal.h
	tifvsi.h
	tif_float.h
	tif_lerc.h
	geotiff.cpp
	gt_jpeg_copy.cpp
	gt_citation.cpp
	gt_overview.cpp
	gt_wkt_srs.cpp
	tifvsi.cpp
	tif_float.c
    BUILTIN
)
GDAL_STANDARD_INCLUDES(gdal_GTIFF)
target_include_directories(gdal_GTIFF PRIVATE
 						   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/jpeg>)

option(HAVE_LERC "Enable LERC" ON)
if(GDAL_USE_LIBTIFF_INTERNAL)
	target_compile_definitions(gdal_GTIFF PRIVATE -DINTERNAL_LIBTIFF)
	target_include_directories(gdal_GTIFF PRIVATE
							   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/gtiff/libtiff>)
    if(RENAME_INTERNAL_LIBTIFF_SYMBOLS)
		target_compile_definitions(gdal_GTIFF PRIVATE
                      -DRENAME_INTERNAL_LIBTIFF_SYMBOLS)
	endif()
	if(HAVE_LERC)
		target_sources(gdal_GTIFF PRIVATE tif_lerc.c)
		target_compile_definitions(gdal_GTIFF PRIVATE -DHAVE_LERC)
		target_include_directories(gdal_GTIFF PRIVATE
				$<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/third_party/LercLib/>)
	endif()
else()
	find_package(TIFF 4.0 REQUIRED)
    target_include_directories(gdal_GTIFF PRIVATE ${TIFF_INCLUDE_DIR})
	target_compile_definitions(gdal_GTIFF PRIVATE -DHAVE_TIFF
	                        -DBIGTIFF_SUPPORT -DPIXARLOG_SUPPORT)
	GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_GTIFF LIBRARIES ${TIFF_LIBRARIES})
endif()

if(GDAL_USE_LIBJPEG_INTERNAL)
	target_include_directories(gdal_GTIFF PRIVATE
	 					$<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/jpeg/libjpeg>)
	target_compile_definitions(gdal_GTIFF PRIVATE -DHAVE_LIBJPEG)
else()
	target_include_directories(gdal_GTIFF PRIVATE ${JPEG_INCLUDE_DIRS})
	target_compile_definitions(gdal_GTIFF PRIVATE -DHAVE_LIBJPEG)
	GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_GTIFF LIBRARIES ${JPEG_LIBRARIES})
endif()

if(GDAL_USE_LIBGEOTIFF_INTERNAL)
    target_include_directories(gdal_GTIFF PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/gtiff/libgeotiff>)
	target_compile_definitions(gdal_GTIFF PRIVATE -DINTERNAL_LIBGEOTIFF)
    if(RENAME_INTERNAL_LIBGEOTIFF_SYMBOLS)
        target_compile_definitions(gdal_GITFF PRIVATE -DRENAME_INTERNAL_LIBGEOTIFF_SYMBOLS)
    endif()
	if(GDAL_USE_LIBZ_INTERNAL)
		target_include_directories(gdal_GTIFF PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/zlib>)
    endif()
else()
	target_include_directories(gdal_GTIFF PRIVATE ${GEOTIFF_INCLUDE_DIR})
    GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_GTIFF LIBRARIES ${GEOTIFF_LIBRARY})
endif()

if(GDAL_USE_LIBZ_INTERNAL)
    target_include_directories(gdal_GTIFF PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/zlib>)
else()
    target_include_directories(gdal_GTIFF PRIVATE $<BUILD_INTERFACE:${ZLIB_INCLUDE_DIRS})
	gdal_target_link_libraries(TARGET gdal_GTIFF LIBRARIES ZLIB::ZLIB)
endif()