GDAL_DRIVER(TARGET gdal_Envisat
        SOURCES EnvisatFile.h records.h  adsrange.hpp timedelta.hpp
                EnvisatFile.c  records.c adsrange.cpp unwrapgcps.cpp envisatdataset.cpp
        INCLUDES $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/raw>
)
GDAL_DRIVER_STANDARD_INCLUDES(gdal_Envisat)

add_executable(dumpgeo EXCLUDE_FROM_ALL dumpgeo.c EnvisatFile.c EnvisatFile.h)
target_include_directories(dumpgeo PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>)
target_link_libraries(dumpgeo $<TARGET_NAME:gdal>)
add_executable(envisat_dump EXCLUDE_FROM_ALL envisat_dump.c EnvisatFile.c EnvisatFile.h)
target_link_libraries(envisat_dump $<TARGET_NAME:gdal>)
