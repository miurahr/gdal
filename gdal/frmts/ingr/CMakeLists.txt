ADD_GDAL_DRIVER(TARGET gdal_INGR SOURCES
                IngrTypes.cpp IngrTypes.h IntergraphBand.cpp IntergraphBand.h IntergraphDataset.cpp IntergraphDataset.h
                JpegHelper.cpp JpegHelper.h
                )

target_include_directories(gdal_INGR PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/alg>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts>)

if(GDAL_USE_LIBTIFF_INTERNAL)
    if(RENAME_INTERNAL_LIBTIFF_SYMBOLS)
        target_compile_definitions(gdal_INGR PRIVATE -DRENAME_INTERNAL_LIBTIFF_SYMBOLS)
    endif()
        target_include_directories(gdal_INGR PRIVATE
                $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/gtiff>
                $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/gtiff/libtiff>)
else()
    target_include_directories(gdal_INGR PRIVATE
                               $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/gtiff>
                               ${TIFF_INCLUDE_DIRS})
    GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_INGR LIBRARIES ${TIFF_LIBRARIES})
endif()
