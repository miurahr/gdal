
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
add_executable(hfatest EXCLUDE_FROM_ALL hfatest.cpp)