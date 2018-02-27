ADD_GDAL_DRIVER(TARGET gdal_PDF SOURCES
        gdal_pdf.h
        pdfcreatecopy.h
        pdfio.h
        pdfobject.h
        pdfcreatecopy.h
        pdfsdk_headers.h
        ogrpdflayer.cpp
        pdfcreatecopy.cpp
        pdfdataset.cpp
        pdfio.cpp
        pdfobject.cpp
        pdfreadvectors.cpp
        ogrpdflayer.cpp
        pdfwritabledataset.cpp
)
gdal_driver_standard_includes(gdal_PDF)
target_include_directories(gdal_PDF PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/vrt>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/mem>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/mem>)

if(HAVE_POPPLER OR HAVE_PODOFO OR HAVE_PDFIUM)
    if(HAVE_POPPLER)
        target_include_directories(gdal_PDF PRIVATE ${POPPLER_INCLUDE_DIRS})
        target_compile_definitions(gdal_PDF PRIVATE -DHAVE_POPPLER)
        gdal_target_link_libraries(TARGET gdal_PDF LIBRARIES ${POPPLER_LIBRARY})
    endif()
    if(HAVE_PODOFO)
        target_include_directories(gdal_PDF PRIVATE ${PODOFO_INCLUDE_DIR})
        target_compile_definitions(gdal_PDF PRIVATE -DHAVE_PODOFO)
        gdal_target_link_libraries(TARGET gdal_PDF LIBRARIES ${PODOFO_LIBRARY})
    endif()
    if(HAVE_PDFIUM)
        target_include_directories(${PDFIUM_INCLUDE_DIR})
        target_compile_definitions(-DHAVE_PDFIUM)
        gdal_target_link_libraries(TARGET gdal_PDF LIBRARIES ${PDFIUM_LIBRARY})
    endif()
else()
    #fails
    message(FATAL_ERROR "Could not find PDF libraries which is one of Poppler, Podofo and PDFIUM")
endif()

# Poppler additional options
if(HAVE_POPPLER)
    target_compile_definitions(gdal_PDF PRIVATE -DPOPPLER_HAS_OPTCONTENT)
    target_compile_definitions(gdal_PDF PRIVATE -DPOPPLER_BASE_STREAM_HAS_TWO_ARGS)
    target_compile_definitions(gdal_PDF PRIVATE -DPOPPLER_0_20_OR_LATER)
    target_compile_definitions(gdal_PDF PRIVATE -DPOPPLER_0_23_OR_LATER)
    if(POPPLER_VERSION VERSION_GREATER 0.58.0 OR POPPLER_VERSION VERSION_EQUAL 0.58.0)
        target_compile_definitions(gdal_PDF PRIVATE -DPOPPLER_0_58_OR_LATER)
    endif()
endif()

