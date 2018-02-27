# depends from ogr/sdts
ADD_GDAL_DRIVER(TARGET gdal_SDTS SOURCES
                sdts_al.h
        sdtsiref.cpp
        sdtscatd.cpp
        sdtslinereader.cpp
        sdtslib.cpp
        sdtspointreader.cpp
        sdtsattrreader.cpp
        sdtstransfer.cpp
        sdtspolygonreader.cpp
        sdtsxref.cpp
        sdtsrasterreader.cpp
        sdtsindexedreader.cpp
        sdtsdataset.cpp
                BUILTIN
)
target_include_directories(gdal_SDTS PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/iso8211>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/shapelib>)

add_executable(sdts2shp EXCLUDE_FROM_ALL sdts2shp.cpp)
target_include_directories(sdts2shp PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/shapelib>)
