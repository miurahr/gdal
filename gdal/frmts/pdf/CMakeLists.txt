add_gdal_driver(TARGET gdal_PDF SOURCES
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
gdal_standard_includes(gdal_PDF)
target_include_directories(gdal_PDF PRIVATE
                           $<TARGET_PROPERTY:gdal_vrt,SOURCE_DIR>
                           $<TARGET_PROPERTY:gdal_MEM,SOURCE_DIR>
                           $<TARGET_PROPERTY:ogr_MEM,SOURCE_DIR>)

if(HAVE_POPPLER OR HAVE_PODOFO OR HAVE_PDFIUM)
    if(HAVE_POPPLER)
        target_compile_definitions(gdal_PDF PRIVATE -DHAVE_POPPLER)
        gdal_target_link_libraries(TARGET gdal_PDF LIBRARIES POPPLER::Poppler)
    endif()
    if(HAVE_PODOFO)
        target_compile_definitions(gdal_PDF PRIVATE -DHAVE_PODOFO)
        gdal_target_link_libraries(TARGET gdal_PDF LIBRARIES PODOFO::Podofo)
    endif()
    if(HAVE_PDFIUM)
        target_compile_definitions(-DHAVE_PDFIUM)
        gdal_target_link_libraries(TARGET gdal_PDF LIBRARIES PDFIUM::PDFium})
    endif()
else()
    #fails
    message(FATAL_ERROR "Could not find PDF libraries which is one of Poppler, Podofo and PDFIUM")
endif()

# Poppler additional options
if(HAVE_POPPLER)
  string(REGEX REPLACE "([0-9]+)\\.([0-9]+).*" "\\1" POPPLER_VERSION_MAJOR ${POPPLER_VERSION})
  string(REGEX REPLACE "([0-9]+)\\.([0-9]+).*" "\\2" POPPLER_VERSION_MINOR ${POPPLER_VERSION})
  target_compile_definitions(gdal_PDF PRIVATE -DPOPPLER_MAJOR_VERSION=${POPPLER_VERSION_MAJOR}
                             -DPOPPLER_MINOR_VERSION=${POPPLER_VERSION_MINOR})
endif()

