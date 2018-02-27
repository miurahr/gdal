# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru, Hiroshi Miura
# ******************************************************************************
# * Copyright (C) 2012 Bishop
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

include(GdalStandardIncludes)
add_library(appslib OBJECT
    commonutils.h
	gdal_utils.h
	gdalinfo_lib.cpp
	gdalbuildvrt_lib.cpp
	gdal_grid_lib.cpp
	gdal_translate_lib.cpp
	gdal_rasterize_lib.cpp
	gdalwarp_lib.cpp
	commonutils.cpp
	ogr2ogr_lib.cpp
	gdaldem_lib.cpp
    nearblack_lib.cpp
)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:appslib>)
gdal_standard_includes(appslib)
target_include_directories(appslib PRIVATE
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/vrt>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>
                           $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/mem>
						   )
if(GDAL_USE_LIBJSONC_INTERNAL)
    target_include_directories(appslib PRIVATE
                               $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson/libjson>
							   )
else()
    target_include_directories(appslib PRIVATE ${JSONC_INCLUDE_DIRS})
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${JSONC_LIBRARIES})
endif()

if(BUILD_APPS)
    add_executable(gdalinfo gdal_utils_priv.h gdalinfo_bin.cpp)
    add_executable(gdalbuildvrt gdal_utils_priv.h gdalbuildvrt_bin.cpp)
    add_executable(gdaladdo gdal_utils_priv.h gdaladdo.cpp)
    add_executable(gdal_grid gdal_utils_priv.h commonutils.h gdal_grid_bin.cpp)
    add_executable(gdal_translate gdal_utils_priv.h commonutils.h gdal_translate_bin.cpp)
    add_executable(gdalwarp commonutils.h gdalwarp_bin.cpp)
    add_executable(gdal_contour commonutils.h gdal_contour.cpp)
    add_executable(gdalenhance gdalenhance.cpp)
    add_executable(gdallocationinfo gdallocationinfo.cpp)
    add_executable(gdalmanage gdalmanage.cpp)
    add_executable(gdalserver gdalserver.cpp)
    add_executable(gdalsrsinfo gdalsrsinfo.cpp)
    add_executable(gdaltindex gdaltindex.cpp)
    add_executable(gdal_rasterize gdal_rasterize_bin.cpp)
    add_executable(gdaldem gdaldem_bin.cpp)
    add_executable(gdaltransform gdaltransform.cpp)
    add_executable(ogrinfo commonutils.h ogrinfo.cpp)
    add_executable(ogr2ogr ogr2ogr_bin.cpp)
    add_executable(ogrlineref ogrlineref.cpp)
    add_executable(ogrtindex ogrtindex.cpp)
    add_executable(nearblack nearblack_bin.cpp)
    add_executable(gnmanalyse gnmanalyse.cpp)
    add_executable(gnmmanage gnmmanage.cpp)

    # Default Apps
    set(APPS_TARGETS
            gdalinfo gdalbuildvrt gdaladdo gdal_grid gdal_translate
            gdalserver gdal_rasterize  gdalsrsinfo
            gdalenhance gdalmanage gdaltransform gdaltindex
            gdaldem nearblack ogrlineref ogrtindex gnmanalyse gnmmanage
            gdalwarp gdal_contour gdallocationinfo ogrinfo ogr2ogr)
    foreach(UTILCMD IN ITEMS ${APPS_TARGETS})
        gdal_standard_includes(${UTILCMD})
        target_include_directories(${UTILCMD} PRIVATE
                                    $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/vrt>
                                    $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic>
                                    $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>
                                    $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/mem>
                                   )
        if(GDAL_USE_LIBJSONC_INTERNAL)
            target_include_directories(${UTILCMD} PRIVATE
                                       $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson/libjson>
                                       )
        else()
            target_include_directories(${UTILCMD} PRIVATE ${JSONC_INCLUDE_DIRS})
            target_link_libraries(${UTILCMD} PRIVATE ${JSONC_LIBRARIES})
        endif()
        target_link_libraries(${UTILCMD} PRIVATE $<TARGET_NAME:gdal>)
        ## Windows(Mingw/MSVC) link libraries
        if (CMAKE_SYSTEM_NAME MATCHES "Windows")
            target_link_libraries(${UTILCMD} PRIVATE wsock32 ws2_32 psapi)
        endif()
        install(TARGETS ${UTILCMD}
                RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
                ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
                LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
                FRAMEWORK DESTINATION ${CMAKE_INSTALL_LIBDIR}
        )
    endforeach()
    target_include_directories(gnmanalyse PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gnm>)
    target_include_directories(gnmmanage PRIVATE $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/gnm>)

    add_custom_target(gdalapps DEPENDS ${APPS_TARGETS})

    # NON-Default Apps
    add_executable(dumpoverviews EXCLUDE_FROM_ALL dumpoverviews.cpp)
    add_executable(gdalflattenmask EXCLUDE_FROM_ALL gdalflattenmask.c)
    add_executable(gdaltorture EXCLUDE_FROM_ALL gdaltorture.cpp)
    add_executable(gdal2ogr EXCLUDE_FROM_ALL gdal2ogr.c)
    add_executable(gdalasyncread EXCLUDE_FROM_ALL gdalasyncread.cpp)
    add_executable(gdalwarpsimple  EXCLUDE_FROM_ALL gdalwarpsimple.c)
    add_executable(multireadtest EXCLUDE_FROM_ALL multireadtest.cpp)
    add_executable(test_ogrsf EXCLUDE_FROM_ALL test_ogrsf.cpp)
    add_executable(testepsg testepsg.cpp)
    add_executable(testreprojmulti EXCLUDE_FROM_ALL testreprojmulti.cpp)

    foreach(UTILCMD IN ITEMS dumpoverviews
            gdal2ogr gdalasyncread gdaltorture
            gdalflattenmask gdalwarpsimple
            multireadtest test_ogrsf testepsg testreprojmulti)
        gdal_standard_includes(${UTILCMD})
        ## Windows(Mingw/MSVC) link libraries
        if (CMAKE_SYSTEM_NAME MATCHES "Windows")
            target_link_libraries(${UTILCMD} PRIVATE wsock32 ws2_32 psapi)
        endif()
        target_include_directories(${UTILCMD} PRIVATE
                                    $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/frmts/vrt>
                                    $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic>
                                    $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/geojson>
                                    $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/mem>
                                   )
        target_link_libraries(${UTILCMD} PRIVATE $<TARGET_NAME:gdal>)
    endforeach()
endif()
