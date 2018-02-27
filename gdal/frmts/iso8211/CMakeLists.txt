ADD_GDAL_DRIVER(TARGET gdal_iso8211
    SOURCES
        iso8211.h
        ddfmodule.cpp 
        ddfutils.cpp
        ddffielddefn.cpp
        ddfrecord.cpp
        ddffield.cpp
        ddfsubfielddefn.cpp
    BUILTIN
)

target_include_directories(gdal_iso8211 PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts>
                           )
