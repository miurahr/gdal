add_gdal_driver(TARGET ogr_ILI1 SOURCES
                ili1reader.cpp ogr_ili1.h ogrili1driver.cpp
                ili1reader.h ogrili1layer.cpp ili1readerp.h ogrili1datasource.cpp
                imdreader.cpp
                imdreader.h
                )
gdal_standard_includes(ogr_ILI1)

add_gdal_driver(TARGET ogr_ILI2 SOURCES
                ili2handler.cpp ili2readerp.h ogrili2driver.cpp
                ili2reader.h ili2reader.cpp
                ogr_ili2.h ogrili2layer.cpp ogrili2datasource.cpp
                imdreader.h imdreader.cpp
                )
gdal_standard_includes(ogr_ILI2)

if(HAVE_XERCESC)
    target_include_directories(ogr_ILI1
            PRIVATE ${XercesC_INCLUDE_DIRS}
                    ${XercesC_INCLUDE_DIRS}/xercesc)
    target_compile_definitions(ogr_ILI1 PRIVATE -DHAVE_XERCES)
    gdal_target_link_libraries(TARGET ogr_ILI1 LIBRARIES XercesC::XercesC)

    target_include_directories(ogr_ILI2
            PRIVATE ${XercesC_INCLUDE_DIRS}
                    ${XercesC_INCLUDE_DIRS}/xercesc)
    target_compile_definitions(ogr_ILI2 PRIVATE -DHAVE_XERCES)
    gdal_target_link_libraries(TARGET ogr_ILI2 LIBRARIES XercesC::XercesC)
endif()

if(HAVE_GEOS)
    target_include_directories(ogr_ILI1 PRIVATE ${GEOS_INCLUDE_DIRS})
    target_compile_definitions(ogr_ILI1 PRIVATE -DHAVE_GEOS=1)
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_ILI1 LIBRARIES GEOS::GEOS)

    target_include_directories(ogr_ILI2 PRIVATE ${GEOS_INCLUDE_DIRS})
    target_compile_definitions(ogr_ILI2 PRIVATE -DHAVE_GEOS=1)
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_ILI2 LIBRARIES GEOS::GEOS)
endif()
