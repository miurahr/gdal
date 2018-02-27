find_package(PkgConfig REQUIRED)
pkg_check_modules(MONGO libmongo-client)

GDAL_DRIVER(TARGET ogr_MongoDB SOURCES
        mongocxx_headers.h
        ogrmongodbdriver.cpp
    INCLUDES $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic>
         ${MONGO_INCLUDE_DIRS}
    LIBRARIES ${MONGO_LIBRARIES})