add_gdal_driver(TARGET gdal_JPEG2000 SOURCES jpeg2000_vsil_io.h jpeg2000_vsil_io.cpp jpeg2000dataset.cpp)
gdal_standard_includes(gdal_JPEG2000)
target_include_directories(gdal_JPEG2000 PRIVATE ${JASPER_INCLUDE_DIRS})
gdal_target_link_libraries(TARGET gdal_JPEG2000 LIBRARIES ${JASPER_LIBRARIES})

# Detect GeoJP2 UUID hack
include(CheckCSourceCompiles)
set(CMAKE_REQUIRED_QUIET "yes")
set(CMAKE_REQUIRED_LIBRARIES jasper)
CHECK_C_SOURCE_COMPILES("#ifdef __cplusplus\nextern \"C\"\n#endif\n char jp2_encode_uuid ();int main () {return jp2_encode_uuid ();;return 0;}" HAVE_JASPER_UUID)
if(HAVE_JASPER_UUID)
    message(STATUS "GeoJP2=${HAVE_JASPER_UUID}")
    target_compile_definitions(gdal_JPEG2000 PRIVATE -DHAVE_JASPER_UUID)
endif()
