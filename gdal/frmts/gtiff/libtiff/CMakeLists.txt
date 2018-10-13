add_library(libtiff OBJECT
			tif_dir.c        tif_fax3.c      tif_lzma.c      tif_predict.h  tif_vsi.c      tiffiop.h
			t4.h                          tif_dir.h        tif_fax3.h      tif_lzw.c       tif_print.c    tif_warning.c  tiffvers.h
			tif_aux.c                     tif_dirinfo.c    tif_fax3sm.c    tif_next.c      tif_read.c     tif_write.c    uvcode.h
			tif_close.c                   tif_dirread.c    tif_flush.c     tif_ojpeg.c     tif_strip.c    tif_zip.c
			tif_codec.c                   tif_dirwrite.c   tif_getimage.c  tif_open.c      tif_swab.c     tif_zstd.c
			tif_color.c                   tif_dumpmode.c   tif_jpeg.c      tif_packbits.c  tif_thunder.c  tiff.h
			tif_compress.c                tif_error.c      tif_jpeg_12.c   tif_pixarlog.c  tif_tile.c     tiffconf.h
			tif_config.h                  tif_extension.c  tif_luv.c       tif_predict.c   tif_version.c  tiffio.h
			)
target_include_directories(libtiff PRIVATE
						   $<TARGET_PROPERTY:cpl,SOURCE_DIR>
						   $<TARGET_PROPERTY:cpl,BINARY_DIR>)
if(GDAL_USE_LIBZ_INTERNAL)
	target_include_directories(libtiff PRIVATE $<TARGET_PROPERTY:libz,SOURCE_DIR>)
else()
	target_include_directories(libtiff PRIVATE ZLIB::ZLIB)
	target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ZLIB::ZLIB)
endif()
target_compile_definitions(libtiff PRIVATE -DPIXARLOG_SUPPORT -DZIP_SUPPORT  -DJPEG_SUPPORT -DOJPEG_SUPPORT)
if(GDAL_USE_LIBJPEG_INTERNAL)
	target_include_directories(libtiff PRIVATE $<TARGET_PROPERTY:libjpeg,SOURCE_DIR>)
else()
	target_include_directories(libtiff PRIVATE JPEG::JPEG)
	target_link_libraries(GDAL_LINK_LIBRARY INTERFACE JPEG::JPEG)
endif()
if(TIFF_JPEG12_ENABLED)
    target_compile_definitions(libtiff PRIVATE -DJPEG_DUAL_MODE_8_12)
endif()
if(HAVE_LIBLZMA)
    target_compile_definitions(libtiff PRIVATE -DLZMA_SUPPORT)
    target_include_directories(libtiff PRIVATE ${LIBLZMA_INCLUDE_DIRS})
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${LIBLZMA_LIBRARIES})
endif()
if(RENAME_INTERNAL_LIBTIFF_SYMBOLS)
    target_compile_definitions(libtiff PRIVATE -DRENAME_INTERNAL_LIBTIFF_SYMBOLS)
    target_sources(libtiff PRIVATE gdal_libtiff_symbol_rename.h)
endif()
if(MSVC)
    if(CMAKE_CL_64)
		target_compile_definitions(libtiff PRIVATE -D_WIN64)
    endif()
endif()

set_target_properties(libtiff PROPERTIES CXX_STANDARD 11)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:libtiff>)
