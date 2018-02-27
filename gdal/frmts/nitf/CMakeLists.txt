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

if(GDAL_USE_LIBTIFF_INTERNAL)
    target_include_directories(gdal_NITF PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/gtiff/libtiff>)
    if(RENAME_LIBTIFF_SYMBOLS)
        target_compile_definitions(gdal_NITF PRIVATE -DRENAME_INTERNAL_LIBTIFF_SYMBOLS)
    endif()
else()
    target_include_directories(gdal_NITF PRIVATE ${TIFF_INCLUDE_DIR})
    GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_NITF LIBRARIES ${TIFF_LIBRARY})
endif()

if(GDAL_JPEG_SUPPORT)
    target_compile_definitions(gdal_NITF PRIVATE -DJPEG_SUPPORTED)
    if(GDAL_USE_LIBJPEG_INTERNAL)
        target_include_directories(gdal_NITF PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/jpeg/libjpeg>)
    else()
        find_package(JPEG REQUIRED)
        target_include_directories(gdal_NITF PRIVATE ${JPEG_INCLUDE_DIR})
        GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_NITF LIBRARIES ${JPEG_LIBRARIES})
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
endif()

target_include_directories(gdal_NITF PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/gtiff>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/vrt>
                           )
