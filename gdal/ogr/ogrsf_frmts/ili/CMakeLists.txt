#There is no support for  single module multiple drivers
# so now it should be builtin driver
# ILI1 and ILI2

ADD_GDAL_DRIVER(TARGET ogr_ILI BUILTIN
    SOURCES ili1reader.cpp  ili2handler.cpp  ili2readerp.h  ogr_ili1.h             ogrili1driver.cpp      ogrili2driver.cpp
    ili1reader.h    ili2reader.cpp   imdreader.cpp  ogr_ili2.h             ogrili1layer.cpp       ogrili2layer.cpp
    ili1readerp.h   ili2reader.h     imdreader.h    ogrili1datasource.cpp  ogrili2datasource.cpp  xercesc_headers.h)
gdal_driver_standard_includes(ogr_ILI)

if(HAVE_XERCESC)
    TARGET_INCLUDE_DIRECTORIES(ogr_ILI
            PRIVATE ${XercesC_INCLUDE_DIRS}
                    ${XercesC_INCLUDE_DIRS}/xercesc)
    TARGET_COMPILE_DEFINITIONS(ogr_ILI
            PRIVATE -DHAVE_XERCES)
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_ILI
            LIBRARIES XercesC::XercesC)
endif()

if(HAVE_GEOS)
    TARGET_INCLUDE_DIRECTORIES(ogr_ILI
            PRIVATE ${GEOS_INCLUDE_DIRS})
    TARGET_COMPILE_DEFINITIONS(ogr_ILI
            PRIVATE -DHAVE_GEOS=1)
    GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_ILI
            LIBRARIES ${GEOS_LIBRARIES})
endif()
