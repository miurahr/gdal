ADD_GDAL_DRIVER(TARGET gdal_INGR SOURCES
                IngrTypes.cpp IngrTypes.h IntergraphBand.cpp IntergraphBand.h IntergraphDataset.cpp IntergraphDataset.h
                JpegHelper.cpp JpegHelper.h
                )
gdal_standard_includes(gdal_INGR)
target_include_directories(gdal_INGR PRIVATE $<TARGET_PROPERTY:gdal_GTIFF,SOURCE_DIR>)

if(GDAL_USE_LIBTIFF_INTERNAL)
    target_include_directories(gdal_INGR PRIVATE $<TARGET_PROPERTY:libtiff,SOURCE_DIR>)
    if(RENAME_INTERNAL_LIBTIFF_SYMBOLS)
        target_compile_definitions(gdal_INGR PRIVATE -DRENAME_INTERNAL_LIBTIFF_SYMBOLS)
    endif()
else()
    target_include_directories(gdal_INGR PRIVATE  ${TIFF_INCLUDE_DIRS})
    GDAL_TARGET_LINK_LIBRARIES(TARGET gdal_INGR LIBRARIES ${TIFF_LIBRARIES})
endif()
