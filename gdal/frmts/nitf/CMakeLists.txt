ADD_GDAL_DRIVER(TARGET gdal_NITF SOURCES
        mgrs.h
        nitflib.h
        nitfdataset.h
        mgrs.c
        nitfdataset.cpp
        rpftocdataset.cpp
        nitfrasterband.cpp
        ecrgtocdataset.cpp
        nitffile.c
        nitfimage.c
        nitfaridpcm.cpp
        nitfbilevel.cpp
        rpftocfile.cpp
        nitfdes.c
        nitf_gcprpc.cpp
                BUILTIN
)
gdal_standard_includes(gdal_NITF)
if(GDAL_USE_LIBTIFF_INTERNAL)
    target_include_directories(gdal_NITF PRIVATE $<TARGET_PROPERTY:libtiff,SOURCE_DIR>)
    if(RENAME_LIBTIFF_SYMBOLS)
        target_compile_definitions(gdal_NITF PRIVATE -DRENAME_INTERNAL_LIBTIFF_SYMBOLS)
    endif()
else()
    target_include_directories(gdal_NITF PRIVATE ${TIFF_INCLUDE_DIR})
    GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_NITF LIBRARIES ${TIFF_LIBRARY})
endif()

    target_compile_definitions(gdal_NITF PRIVATE -DJPEG_SUPPORTED)
    if(GDAL_USE_LIBJPEG_INTERNAL)
        target_include_directories(gdal_NITF PRIVATE $<TARGET_PROPERTY:libjpeg,SOURCE_DIR>)
    else()
        find_package(JPEG REQUIRED)
        target_include_directories(gdal_NITF PRIVATE JPEG::JPEG)
        GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_NITF LIBRARIES JPEG::JPEG)
    endif()
    if(GDAL_JPEG12_SUPPORTED)
         target_compile_definitions(gdal_NITF PRIVATE -DJPEG_DUAL_MODE_8_12)
         target_sources(gdal_NITF PRIVATE
            nitfwritejpeg_12.cpp
         )
    else()
        target_sources(gdal_NITF PRIVATE
             nitfwritejpeg.cpp
         )
    endif()

target_include_directories(gdal_NITF PRIVATE $<TARGET_PROPERTY:gdal_GTIFF,SOURCE_DIR>
                           $<TARGET_PROPERTY:gdal_vrt,SOURCE_DIR>)
