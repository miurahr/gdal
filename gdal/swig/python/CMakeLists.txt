# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru,
# *			Hiroshi Miura <miurahr@linux.com>
# ******************************************************************************
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

add_subdirectory(osgeo)
add_subdirectory(scripts)

set(_py_depends)
if(NumPy_FOUND)
    if(NumPy_VERSION VERSION_LESS 1.0.0)
        message(WARNING "numpy version ${NumPy_VERSION} must be > 1.0.0")
        message(WARNING "disable numpy support")
        set(NumPy_FOUND OFF)
    else()
        foreach(v IN ITEMS 2 3)
            if(Python${v}_FOUND)
                list(APPEND _py_depends _gdal_array${v})
           endif()
        endforeach()
    endif()
endif()
if(ENABLE_GNM)
    foreach(v IN ITEMS 2 3)
        if(Python${v}_FOUND)
            list(APPEND _py_depends _gnm${v})
       endif()
    endforeach()
endif()

macro(py_ext name source)
    # FIXME: current script builds from generated sources
    foreach(v IN ITEMS 2 3)
        if(NOT Python${v}_FOUND)
            continue()
        endif()
        add_library(${name}${v} SHARED ${CMAKE_CURRENT_SOURCE_DIR}/extensions/${source})
        set_target_properties(${name}${v} PROPERTIES
                              LIBRARY_OUTPUT_NAME ${name}
                              PREFIX ""
                              LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${v}/osgeo)
        gdal_standard_includes(${name}${v})
        target_include_directories(${name}${v} PRIVATE
                                   ${Python${v}_INCLUDE_DIRS}
                                   $<TARGET_PROPERTY:appslib,SOURCE_DIR>
                                   $<TARGET_PROPERTY:gnm,SOURCE_DIR>
                                   )
        if(WIN32 AND NOT CYGWIN)
            set_target_properties(${name}${v} PROPERTIES SUFFIX ".pyd")
            target_compile_definitions(${name}${v} PRIVATE -D__MSVCRT_VERSION__=0x0601)
        endif()
        if(APPLE)
            set_target_properties(${name}${v} PROPERTIES SUFFIX ".so")
        endif()
        target_link_libraries(${name}${v} PRIVATE ${Python${v}_LIBRARIES} $<TARGET_NAME:gdal>)
        install(TARGETS ${name}${v} DESTINATION ${Python${v}_SITEARCH}/osgeo)
    endforeach()
endmacro()

py_ext(_gdal gdal_wrap.cpp)
py_ext(_gdalconst gdalconst_wrap.c)
py_ext(_gnm gnm_wrap.cpp)
py_ext(_ogr ogr_wrap.cpp)
py_ext(_osr osr_wrap.cpp)

if(NumPy_FOUND)
    py_ext(_gdal_array gdal_array_wrap.cpp)
    foreach(v IN ITEMS 2 3)
        if(Python${v}_FOUND)
            target_include_directories(_gdal_array${v} PRIVATE ${NumPy_INCLUDE_DIRS})
            install(TARGETS _gdal_array${v} DESTINATION ${Python${v}_SITEARCH}/osgeo)
        endif()
    endforeach()
endif()

add_custom_target(python_binding ALL
                  DEPENDS _gdal2 _gdalconst2 _ogr2 _osr2
                  DEPENDS _gdal3 _gdalconst3 _ogr3 _osr3
                  ${_py_depends})
if(Python2_FOUND)
    add_custom_command(TARGET python_binding PRE_BUILD
                   COMMAND ${CMAKE_COMMAND} -E make_directory
				       ${CMAKE_CURRENT_BINARY_DIR}/2/osgeo/
                   COMMAND ${CMAKE_COMMAND} -E copy
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/__init__.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/gdal.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/gdalconst.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/gdalnumeric.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/ogr.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/osr.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/gnm.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/gdal_array.py
                       ${CMAKE_CURRENT_BINARY_DIR}/2/osgeo/)
endif()
if(Python3_FOUND)
    add_custom_command(TARGET python_binding PRE_BUILD
                   COMMAND ${CMAKE_COMMAND} -E make_directory
                           ${CMAKE_CURRENT_BINARY_DIR}/3/osgeo/
                   COMMAND ${Python3_EXECUTABLE} -m lib2to3
                       --fix=import --fix=next --fix=renames
                       --fix=unicode --fix=ws_comma --fix=xrange
                       --write --write-unchanged-files --nobackups
                       --output-dir=${CMAKE_CURRENT_BINARY_DIR}/3/osgeo/
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/__init__.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/gdal.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/gdalconst.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/gdalnumeric.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/ogr.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/osr.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/gnm.py
                       ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/gdal_array.py)
endif()
foreach(v IN ITEMS 2 3)
    if(Python${v}_FOUND)
        install(FILES
                ${CMAKE_CURRENT_BINARY_DIR}/${v}/__init__.py
                ${CMAKE_CURRENT_BINARY_DIR}/${v}/gdal.py
                ${CMAKE_CURRENT_BINARY_DIR}/${v}/gdalconst.py
                ${CMAKE_CURRENT_BINARY_DIR}/${v}/gdalnumeric.py
                ${CMAKE_CURRENT_BINARY_DIR}/${v}/gnm.py
                ${CMAKE_CURRENT_BINARY_DIR}/${v}/ogr.py
                ${CMAKE_CURRENT_BINARY_DIR}/${v}/osr.py
                DESTINATION ${Python${v}_SITELIB}/osgeo)
        if(NumPy_FOUND)
            install(FILES
                    ${CMAKE_CURRENT_BINARY_DIR}/${v}/gdal_array.py
                    DESTINATION ${Python${v}_SITELIB}/osgeo
                    )
        endif()
    endif()
endforeach()

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_layer_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrlayer_8cpp.xml ../include/python/docs/ogr_layer_docs.i OGRLayerShadow OGR_L_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_geometry_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrgeometry_8cpp.xml ../include/python/docs/ogr_geometry_docs.i OGRGeometryShadow OGR_G_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_datasource_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrdatasource_8cpp.xml ../include/python/docs/ogr_datasource_docs.i OGRDataSourceShadow OGR_DS_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_driver_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrsfdriver_8cpp.xml ../include/python/docs/ogr_driver_docs.i OGRDriverShadow OGR_Dr_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_feature_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrfeature_8cpp.xml ../include/python/docs/ogr_feature_docs.i OGRFeatureShadow OGR_F_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_featuredef_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrfeaturedefn_8cpp.xml ../include/python/docs/ogr_featuredef_docs.i OGRFeatureDefnShadow OGR_FD_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_fielddef_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrfielddefn_8cpp.xml ../include/python/docs/ogr_fielddef_docs.i OGRFieldDefnShadow OGR_Fld_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_target(epydoc COMMAND epydoc --config epydoc.conf
                  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
