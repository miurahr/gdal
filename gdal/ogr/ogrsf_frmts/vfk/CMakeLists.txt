ADD_GDAL_DRIVER(TARGET ogr_VFK SOURCES
        ogr_vfk.h
        vfkreader.h
        vfkreaderp.h
        ogrvfkdatasource.cpp
        ogrvfkdriver.cpp
        ogrvfklayer.cpp
        vfkdatablock.cpp
        vfkdatablocksqlite.cpp
        vfkproperty.cpp
        vfkpropertydefn.cpp
        vfkreader.cpp
        vfkreadersqlite.cpp
        vfkfeature.cpp
        vfkfeaturesqlite.cpp
)
gdal_driver_standard_includes(ogr_VFK)
if(HAVE_SQLITE3)
    TARGET_INCLUDE_DIRECTORIES(ogr_VFK  PRIVATE ${SQLITE3_INCLUDE_DIR})
    GDAL_TARGET_LINK_LIBRARIES(TARGET  ogr_VFK LIBRARIES ${SQLITE3_LIBRARY})
    TARGET_COMPILE_DEFINITIONS(ogr_VFK PRIVATE -DHAVE_SQLITE)
endif()
