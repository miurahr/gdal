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

add_library(gcore OBJECT
        gdalopeninfo.cpp
        gdaldrivermanager.cpp
        gdaldriver.cpp
        gdaldataset.cpp
        gdalrasterband.cpp
        gdal_misc.cpp
        rasterio.cpp
        gdalrasterblock.cpp
        gdalcolortable.cpp
        gdalmajorobject.cpp
        overview.cpp
        gdaldefaultoverviews.cpp
        gdalpamdataset.cpp
        gdalpamrasterband.cpp
        gdaljp2metadata.cpp
        gdaljp2box.cpp
        gdalmultidomainmetadata.cpp
        gdal_rat.cpp
        gdalpamproxydb.cpp
        gdalallvalidmaskband.cpp
        gdalnodatamaskband.cpp
        gdalnodatavaluesmaskband.cpp
        gdalproxydataset.cpp
        gdalproxypool.cpp
        gdaldefaultasync.cpp
        gdaldllmain.cpp
        gdalexif.cpp
        gdalclientserver.cpp
        gdalgeorefpamdataset.cpp
        gdaljp2abstractdataset.cpp
        gdalvirtualmem.cpp
        gdaloverviewdataset.cpp
        gdalrescaledalphaband.cpp
        gdaljp2structure.cpp
        gdal_mdreader.cpp
        gdaljp2metadatagenerator.cpp
        gdalabstractbandblockcache.cpp
        gdalarraybandblockcache.cpp
        gdalhashsetbandblockcache.cpp
        rasterio_ssse3.cpp
)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:gcore>)

install(FILES $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/gdal/gcore/gdal_version.h>
        DESTINATION include/gdal)
install(FILES
        gdal.h
        gdaljp2metadata.h
        gdal_frmts.h
        gdal_pam.h
        gdal_priv.h
        gdal_proxy.h
        gdal_rat.h
        gdalexif.h
        gdalgeorefpamdataset.h
        gdal_priv_templates.hpp
        gdal_avx2_emulation.hpp
        gdal_mdreader.h
        gdal_pam.h
        gdalsse_priv.h
        DESTINATION include/gdal)

target_include_directories(gcore PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/alg>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/gcore>
                           $<BUILD_INTERFACE:${GDAL_ROOT_BINARY_DIR}/port>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gnm>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gnm/gnm_frmts>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/gtiff>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/mem>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/vrt>
                           )
if(GDAL_USE_LIBJSONC_INTERNAL)
    target_include_directories(gcore PRIVATE
							   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson/libjson>
							   )
else()
    target_include_directories(gcore PRIVATE ${JSONC_INCLUDE_DIRS})
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${JSONC_LIBRARIES})
endif()

if(USE_CPL)
	target_compile_definitions(gcore PRIVATE -DUSE_CPL)
endif(USE_CPL)

if(PAM_ENABLED)
	target_compile_definitions(gcore PRIVATE -DPAM_ENABLED)
endif(PAM_ENABLED)

add_subdirectory(mdreader)

if(HAVE_SQLITE3)
    target_compile_definitions(gcore PRIVATE -DSQLITE_ENABLED)
    target_include_directories(gcore PRIVATE ${SQLITE3_INCLUDE_DIR})
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE SQLITE3::SQLITE3)
endif()
if(HAVE_LIBXML2)
    target_include_directories(gcore PRIVATE ${LIBXML2_INCLUDE_DIR})
    target_compile_definitions(gcore PRIVATE -DHAVE_LIBXML2)
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${LIBXML2_LIBRARIES})
endif()

# temporary off untill designing optimizations in cmake way.
#set(CXXFLAGS_NO_LTO_IF_SSSE3_NONDEFAULT  -DHAVE_SSSE3_AT_COMPILE_TIME  -ftrapv  -Wall  -fno-operator-names)
#if(UNIX)
#    set(CXXFLAGS_NO_LTO_IF_SSSE3_NONDEFAULT ${CXXFLAGS_NO_LTO_IF_SSE3_NONDEFAULT} -Wextra -Winit-self -Wunused-parameter -Wformat -Werror=format-security -Wno-format-nonliteral -Wlogical-op -Wshadow -Werror=vla -Wmissing-declarations -Wnon-virtual-dtor -Woverloaded-virtual)
#endif()
#add_definitions(${CXXFLAGS_NO_LTO_IF_SSSE3_NONDEFAULT})
#add_compile_options(-mssse3)

if (POLICY CMP0069)
  include(CheckIPOSupported)
  check_ipo_supported(RESULT result)
  if(result)
   set_property(TARGET gdal PROPERTY INTERPROCEDURAL_OPTIMIZATION True)
  endif()
else()
   set_property(TARGET gdal PROPERTY INTERPROCEDURAL_OPTIMIZATION True)
endif()
