ADD_GDAL_DRIVER(TARGET gdal_RMF SOURCES rmfdataset.h  rmfdataset.cpp rmfdem.cpp rmflzw.cpp rmfjpeg.cpp)
GDAL_STANDARD_INCLUDES(gdal_RMF)

if(HAVE_JPEG OR GDAL_USE_LIBJPEG_INTERNAL)
    target_compile_definitions(gdal_RMF PRIVATE -DHAVE_LIBJPEG)
endif()
