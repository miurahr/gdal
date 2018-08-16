# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru
# ******************************************************************************
# * Copyright (C) 2018 Hiroshi Miura
# * Copyright (C) 2012,2013 Bishop
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

add_library(alg OBJECT
        contour.cpp
        delaunay.c
        gdal_crs.c
        gdal_octave.cpp
        gdal_rpc.cpp
        gdal_tps.cpp
        gdalapplyverticalshiftgrid.cpp
        gdalchecksum.cpp
        gdalcutline.cpp
        gdaldither.cpp
        gdalgeoloc.cpp
        gdalgrid.cpp
		gdalgridavx.cpp
		gdalgridsse.cpp
		gdallinearsystem.cpp
		gdalmatching.cpp
        gdalmediancut.cpp
		gdalpansharpen.cpp
        gdalproximity.cpp
        gdalrasterize.cpp
        gdalrasterpolygonenumerator.cpp
        gdalsievefilter.cpp
        gdalsimplewarp.cpp
        gdaltransformer.cpp
		gdaltransformgeolocs.cpp
        gdalwarper.cpp
        gdalwarpkernel.cpp
        gdalwarpoperation.cpp
        llrasterize.cpp
        polygonize.cpp
        rasterfill.cpp
        thinplatespline.cpp
        gdal_simplesurf.cpp
)
include(GdalStandardIncludes)
gdal_standard_includes(alg)
target_include_directories(alg PRIVATE $<TARGET_PROPERTY:gdal_GTIFF,SOURCE_DIR> $<TARGET_PROPERTY:gdal_vrt,SOURCE_DIR>)

if(HAVE_GEOS)
	get_filename_component(GEOS_ROOT ${GEOS_INCLUDE_DIR} PATH)
    target_include_directories(alg PRIVATE
							   ${GEOS_INCLUDE_DIR}
							   ${GEOS_ROOT}/capi
							   ${GEOS_ROOT})
	target_compile_definitions(alg PRIVATE -DHAVE_GEOS=1)
endif(HAVE_GEOS)

if(HAVE_ARMADILLO)
	target_include_directories(alg PRIVATE ${GEOS_INCLUDE_DIRS})
	target_compile_definitions(alg PRIVATE -DHAVE_ARMADILLO)
endif()

if(USE_CPL)
	target_compile_definitions(alg PRIVATE -DUSE_CPL)
endif(USE_CPL)

if(PAM_ENABLED)
	target_compile_definitions(alg PRIVATE -DPAM_ENABLED)
endif(PAM_ENABLED)

if (HAVE_OPENCL)
	target_include_directories(alg PRIVATE ${OpenCL_INCLUDE_DIRS})
	target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${OpenCL_LIBRARIES})
	target_compile_definitions(alg PRIVATE -DHAVE_OPENCL)
	target_sources(alg PRIVATE
		gdalwarpkernel_opencl.h
		gdalwarpkernel_opencl.cpp
	)
endif()

if(GDAL_QHULL)
    if(GDAL_USE_QHULL_INTERNAL)
        target_compile_definitions(alg PRIVATE -DINTERNAL_QHULL)
        target_sources(alg PRIVATE internal_qhull_headers.h)
        target_include_directories(alg PRIVATE $<TARGET_PROPERTY:qhull,SOURCE_DIR>)
    else()
        target_compile_definitions(alg PRIVATE -DEXTERNAL_QHULL)
        if(QHULL_INCLUDE_SUBDIR STREQUAL "libqhull")
            target_compile_definitions(alg PRIVATE -DQHULL_INCLUDE_SUBDIR_IS_LIBQHULL=1)
        else()
            target_compile_definitions(alg PRIVATE -DQHULL_INCLUDE_SUBDIR_IS_LIBQHULL=0)
        endif()
        target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${QHULL_LIBRARY})
    endif()
endif()

if(GEOS_FOUND)
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${GEOS_LIBRARY})
endif(GEOS_FOUND)

if(ARMADILLO_FOUND)
	target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${ARMADILLO_LIBRARIES})
endif(ARMADILLO_FOUND)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:alg>)
install(FILES
		gdalgrid.h
        gdalwarper.h
        gdal_alg.h
        gdal_alg_priv.h
        gdalgrid.h
        gdalgrid_priv.h
        gvgcpfit.h
        thinplatespline.h
        gdal_simplesurf.h
		gdallinearsystem.h
		gdalpansharpen.h
	DESTINATION include/gdal)
