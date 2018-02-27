add_library(pcidsk_sdk OBJECT
    pcidsk.h pcidsk_ads40.h pcidsk_airphoto.h pcidsk_array.h
    pcidsk_binary.h pcidsk_buffer.h pcidsk_channel.h pcidsk_config.h
    pcidsk_edb.h pcidsk_ephemeris.h pcidsk_exception.h pcidsk_file.h
    pcidsk_gcp.h pcidsk_gcpsegment.h pcidsk_georef.h pcidsk_interfaces.h
    pcidsk_io.h pcidsk_mutex.h pcidsk_pct.h pcidsk_poly.h pcidsk_rpc.h
    pcidsk_segment.h pcidsk_shape.h pcidsk_tex.h pcidsk_toutin.h pcidsk_types.h
    pcidsk_vectorsegment.h
)
target_include_directories(pcidsk_sdk PRIVATE
						   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/pcidsk/sdk>
						   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
						   $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
						   )

if(WIN32)
	target_sources(pcidsk_sdk PRIVATE port/io_win32.cpp port/win32_mutex.cpp)
else()
	target_sources(pcidsk_sdk PRIVATE port/io_stdio.cpp port/pthread_mutex.cpp)
endif()
target_sources(gdal PRIVATE $<TARGET_OBJECTS:pcidsk_sdk>)
add_subdirectory(channel)
add_subdirectory(core)
add_subdirectory(segment)

