
#depend from gcore
ADD_GDAL_DRIVER(TARGET gdal_HFA SOURCES
                hfa.h
                hfa_p.h
                hfadataset.h
                hfaband.cpp
                hfacompress.cpp
                hfadataset.cpp
                hfadictionary.cpp
                hfaentry.cpp
                hfafield.cpp
                hfaopen.cpp
                hfatype.cpp
                hfa_overviews.cpp
				BUILTIN
)
gdal_standard_includes(gdal_HFA)
target_include_directories(gdal_HFA PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts>)
add_executable(hfatest EXCLUDE_FROM_ALL hfatest.cpp)