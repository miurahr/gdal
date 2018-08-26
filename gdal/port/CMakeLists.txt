# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru, Hiroshi Miura
# ******************************************************************************
# * Copyright (C) 2012,2013 Bishop
# * Copyright (C) 2017,2018 Hiroshi Miura
# *
# * Permission is hereby granted, free of charge, to any person obtaining a
# * copy of this software and associated documentation files (the "Software"),
# * to deal in the Software without restriction, including without limitation
# * the rights to use, copy, modify, merge, publish, distribute, sublicense,
# * and/or sell copies of the Software, and to permit persons to whom the
# * Software is furnished to do so, subject to the following conditions:
# *
# * The above copyright notice and this permission notice shall be included
# * in all copies or substantial portions of the Software.
# *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# * DEALINGS IN THE SOFTWARE.
# ******************************************************************************


add_library(cpl_headers INTERFACE)
target_sources(cpl_headers	INTERFACE
			   cpl_alibaba_oss.h
               cpl_azure.h
               cplkeywordparser.h
               cpl_atomic_ops.h
               cpl_config_extras.h
               cpl_conv.h
               cpl_cpu_features.h
               cpl_csv.h
               cpl_error.h
               cpl_hash_set.h
               cpl_http.h
		cpl_json.h
		cpl_json_header.h
        cpl_list.h
        cpl_minixml.h
        cpl_multiproc.h
        cpl_port.h
        cpl_quad_tree.h
        cpl_safemaths.hpp
        cpl_sha1.h
        cpl_sha256.h
        cpl_string.h
        cpl_time.h
        cpl_vsi.h
        cpl_vsi_error.h
        cpl_vsi_virtual.h
        cpl_virtualmem.h
        gdal_csv.h
        cpl_spawn.h
        cpl_progress.h
        cpl_json_streaming_parser.h
		cpl_md5.h
		cpl_mem_cache.h
)

add_library(cpl OBJECT
		cpl_alibaba_oss.cpp
		cpl_azure.cpp
        cpl_conv.cpp
        cpl_error.cpp
        cpl_string.cpp
        cplgetsymbol.cpp
        cplstringlist.cpp
        cpl_strtod.cpp
        cpl_path.cpp
        cpl_csv.cpp
        cpl_findfile.cpp
        cpl_minixml.cpp
        cpl_multiproc.cpp
        cpl_list.cpp
        cpl_getexecpath.cpp
        cplstring.cpp
        cpl_vsisimple.cpp
        cpl_vsil.cpp
        cpl_vsi_mem.cpp
        cpl_http.cpp
        cpl_hash_set.cpp
        cplkeywordparser.cpp
        cpl_recode.cpp
        cpl_recode_stub.cpp
        cpl_quad_tree.cpp
        cpl_atomic_ops.cpp
        cpl_vsil_subfile.cpp
        cpl_time.cpp
        cpl_vsil_stdout.cpp
        cpl_vsil_sparsefile.cpp
        cpl_vsil_abstract_archive.cpp
        cpl_vsil_tar.cpp
        cpl_vsil_stdin.cpp
        cpl_vsil_buffered_reader.cpp
        cpl_base64.cpp
        cpl_vsil_curl.cpp
        cpl_vsil_curl_streaming.cpp
        cpl_vsil_cache.cpp
        cpl_xml_validate.cpp
        cpl_spawn.cpp
        cpl_google_oauth2.cpp
        cpl_progress.cpp
        cpl_virtualmem.cpp
        cpl_worker_thread_pool.cpp
        cpl_vsil_crypt.cpp
        cpl_sha1.cpp
        cpl_sha256.cpp
        cpl_aws.cpp
        cpl_vsi_error.cpp
        cpl_cpu_features.cpp
        cpl_google_cloud.cpp
		cpl_json.cpp
        cpl_json_streaming_parser.cpp
		cpl_md5.cpp
		cpl_vsil_hdfs.cpp
		cpl_swift.cpp
			cpl_vsil_az.cpp
			cpl_vsil_gs.cpp
			cpl_vsil_webhdfs.cpp
			cpl_vsil_s3.cpp
			cpl_vsil_oss.cpp
			cpl_vsil_swift.cpp
)
set_target_properties(cpl PROPERTIES CXX_STANDARD 11 CXX_STANDARD_REQUIRED ON)
if(UNIX)
    target_compile_options(cpl PRIVATE -DCPL_LSB)
endif()

#include path to generated cpl_config.h
target_include_directories(cpl PRIVATE
						   ${CMAKE_CURRENT_SOURCE_DIR}
						   ${CMAKE_CURRENT_BINARY_DIR}
						   )
if(WIN32)
    target_sources(cpl PRIVATE cpl_vsil_win32.cpp)
else()
    target_sources(cpl PRIVATE cpl_vsil_unix_stdio_64.cpp)
endif()

if(GDAL_USE_LIBJSONC_INTERNAL)
    target_include_directories(cpl PRIVATE $<TARGET_PROPERTY:libjson,SOURCE_DIR>)
else()
    target_include_directories(cpl PRIVATE ${JSONC_INCLUDE_DIR})
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${JSONC_LIBRARY})
endif()

if(GDAL_USE_LIBZ)
	target_compile_definitions(cpl PRIVATE -DHAVE_LIBZ -DZIP_SUPPORT)
	target_sources(cpl_headers INTERFACE
		cpl_minizip_ioapi.h
		cpl_minizip_unzip.h
		cpl_minizip_zip.h
	)
	target_sources(cpl PRIVATE
		cpl_vsil_gzip.cpp
		cpl_minizip_ioapi.cpp
		cpl_minizip_unzip.cpp
		cpl_minizip_zip.cpp
	)
	if(GDAL_USE_LIBZ_INTERNAL)
		target_include_directories(cpl PRIVATE $<TARGET_PROPERTY:libz,SOURCE_DIR>)
	else()
        target_include_directories(cpl PRIVATE ${ZLIB_INCLUDE_DIRS})
        target_compile_definitions(cpl PRIVATE -DHAVE_ZLIB_H -DHAVE_ZLIB)
        if(MSVC)
            target_compile_definitions(cpl PRIVATE -DZLIB_DLL)
        endif(MSVC)
	    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ZLIB::ZLIB)
	endif()
endif()

if(HAVE_CURL)
    target_include_directories(cpl PRIVATE ${CURL_INCLUDE_DIRS})
    target_compile_definitions(cpl PRIVATE -DHAVE_CURL)
	target_sources(cpl_headers INTERFACE
        cpl_vsil_curl_priv.h
    )
	target_sources(cpl PRIVATE
        cpl_vsil_curl.cpp
        cpl_vsil_curl_streaming.cpp
    )
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE CURL::libcurl)
endif()

if(HAVE_ICONV)
	if(Iconv_IS_BUILT_IN)
        target_compile_definitions(cpl PRIVATE -DHAVE_ICONV)
        target_sources(cpl PRIVATE cpl_recode_iconv.cpp)
	else()
        target_compile_definitions(cpl PRIVATE -DHAVE_ICONV)
        if(APPLE)
            target_compile_definitions(cpl PRIVATE -DLIBICONV_PLUG)
        endif()
        target_include_directories(cpl PRIVATE ${Iconv_INCLUDE_DIR})
        target_sources(cpl PRIVATE cpl_recode_iconv.cpp)
        target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${Iconv_LIBRARY})
	endif()
endif()

if(GDAL_USE_ODBC)
	target_sources(cpl_headers INTERFACE
		cpl_odbc.h
	)

	target_sources(cpl PRIVATE
		cpl_odbc.cpp
	)
endif()

if(GDAL_USE_XMLREFORMAT)
    target_sources(cpl PRIVATE xmlreformat.cpp)
endif()

target_sources(gdal PRIVATE $<TARGET_OBJECTS:cpl>)

if(NOT WIN32)
	set(CMAKE_THREAD_PREFER_PTHREAD ON CACHE BOOL "Prefer pthread")
    set(THREADS_PREFER_PTHREAD_FLAG ON)
    find_package(Threads)
    if(Threads_FOUND)
        target_link_libraries(GDAL_LINK_LIBRARY INTERFACE Threads::Threads)
    endif()
endif()

if(MSVC)
    if(CMAKE_CL_64)
		target_compile_definitions(cpl PRIVATE -D_WIN64)
    endif()
endif()

## for plugin DLFCN:
##  for win32 https://github.com/dlfcn-win32/dlfcn-win32/archive/v1.1.1.tar.gz
#if(WIN32)
#    find_package(dlfcn-win32 REQUIRED)
#    set(CMAKE_DL_LIBS dlfcn-win32::dl)
#endif()

install(TARGETS cpl_headers DESTINATION include/gdal)

add_executable(xmlreformat EXCLUDE_FROM_ALL xmlreformat.cpp)
