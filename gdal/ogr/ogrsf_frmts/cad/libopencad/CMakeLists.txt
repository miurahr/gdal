
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
                           $<TARGET_PROPERTY:cpl,SOURCE_DIR>
                           $<TARGET_PROPERTY:cpl,BINARY_DIR>
                           $<TARGET_PROPERTY:ogr_CAD,SOURCE_DIR>
                           ${CMAKE_CURRENT_SOURCE_DIR}
                           ${CMAKE_CURRENT_SOURCE_DIR}/dwg)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:libopencad>)
