GDAL_DRIVER(TARGET ogr_DGN SOURCES
        ogr_dgn.h
        dgnlib.h
        dgnlibp.h
        dgnfloat.cpp
        dgnhelp.cpp
        dgnopen.cpp
        dgnread.cpp
        dgnwrite.cpp
        dgnstroke.cpp
        ogrdgndriver.cpp
        ogrdgnlayer.cpp
        ogrdgndatasource.cpp)
add_executable(dgnwritetest EXCLUDE_FROM_ALL dgnwritetest.cpp)
add_executable(dgndump EXCLUDE_FROM_ALL dgndump.cpp)
