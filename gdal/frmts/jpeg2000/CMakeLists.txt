# Detect GeoJP2 UUID hack
include(CheckCSourceCompiles)
set(CMAKE_REQUIRED_QUIET "yes")
set(CMAKE_REQUIRED_LIBRARIES jasper)
CHECK_C_SOURCE_COMPILES("#ifdef __cplusplus\nextern \"C\"\n#endif\n char jp2_encode_uuid ();int main () {return jp2_encode_uuid ();;return 0;}" HAVE_JASPER_UUID)
set(JPEG2000_DEF)
if(HAVE_JASPER_UUID)
    message(STATUS "GeoJP2=${HAVE_JASPER_UUID}")
    set(JPEG2000_DEF -DHAVE_JASPER_UUID)
endif()

GDAL_DRIVER(TARGET gdal_JPEG2000 SOURCES jpeg2000_vsil_io.h jpeg2000_vsil_io.cpp jpeg2000dataset.cpp
    INCLUDES ${JASPER_INCLUDE_DIRS}
    LIBRARIES ${JASPER_LIBRARIES}
    DEFINITIONS ${JPEG2000_DEF}
)