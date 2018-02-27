
add_library(libopencad OBJECT
        opencad.h
        opencad_api.h
        cadclasses.h
        cadcolors.h
        caddictionary.h
        cadfile.h
        cadfileio.h
        cadlayer.h
        cadobjects.h
        cadtables.h
        dwg/io.h
        dwg/r2000.h
        cadclasses.cpp
        cadcolors.cpp
        caddictionary.cpp
        cadfile.cpp
        cadfileio.cpp
        cadgeometry.cpp
        cadfilestreamio.cpp
        cadheader.cpp
        cadlayer.cpp
        cadobjects.cpp
        cadtables.cpp
        opencad.cpp
        dwg/io.cpp
        dwg/r2000.cpp
)

target_include_directories(libopencad PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/cad>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/cad/libopencad>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/cad/libopencad/dwg>)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:libopencad>)