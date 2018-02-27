ADD_GDAL_DRIVER(TARGET ogr_S57 SOURCES
        ogr_s57.h
        s57.h
        s57tables.h
        ogrs57driver.cpp
        ogrs57datasource.cpp
        ogrs57layer.cpp
        s57classregistrar.cpp
        s57reader.cpp
        ddfrecordindex.cpp
        s57featuredefns.cpp
        s57filecollector.cpp
        s57writer.cpp)
target_include_directories(ogr_S57 PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/iso8211>)
gdal_driver_standard_includes(ogr_S57)
add_executable(s57dump EXCLUDE_FROM_ALL s57dump.cpp)