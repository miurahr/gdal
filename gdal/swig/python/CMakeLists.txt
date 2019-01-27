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
macro(py_ext name v source)
    if(v EQUAL 2)
        python2_add_library(${name}2 MODULE ${CMAKE_CURRENT_SOURCE_DIR}/extensions/${source})
    else()
        python3_add_library(${name}3 MODULE ${CMAKE_CURRENT_SOURCE_DIR}/extensions/${source})
    endif()
    set_target_properties(${name}${v} PROPERTIES  LIBRARY_OUTPUT_NAME ${name}
                          LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${v}/osgeo)
    gdal_standard_includes(${name}${v})
    target_include_directories(${name}${v} PRIVATE $<TARGET_PROPERTY:appslib,SOURCE_DIR> $<TARGET_PROPERTY:gnm,SOURCE_DIR>)
    if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
        target_compile_definitions(${name}${v} PRIVATE -D__MSVCRT_VERSION__=0x0601)
    endif()
    target_link_libraries(${name}${v} PRIVATE $<TARGET_NAME:gdal>)
    install(TARGETS ${name}${v} DESTINATION ${Python${v}_SITEARCH}/osgeo)
endmacro()

foreach(v IN ITEMS 2 3)
    if(NOT Python${v}_FOUND)
        continue()
    endif()
    py_ext(_gdal ${v} gdal_wrap.cpp)
    py_ext(_gdalconst ${v} gdalconst_wrap.c)
    py_ext(_gnm ${v} gnm_wrap.cpp)
    py_ext(_ogr ${v} ogr_wrap.cpp)
    py_ext(_osr ${v} osr_wrap.cpp)
    set(_py_depends)
    if(Python${v}_NumPy_FOUND)
        if(NOT Pyhton${v}_NumPy_VERSION VERSION_LESS 1.0.0)
          py_ext(_gdal_array ${v} gdal_array_wrap.cpp)
          target_include_directories(_gdal_array${v} PRIVATE ${Python${v}_NumPy_INCLUDE_DIRS})
          install(TARGETS _gdal_array${v} DESTINATION ${Python${v}_SITEARCH}/osgeo)
          list(APPEND _py_depends _gdal_array${v})
          install(FILES
                  ${CMAKE_CURRENT_BINARY_DIR}/${v}/osgeo/gdal_array.py
                  DESTINATION ${Python${v}_SITELIB}/osgeo)
        endif()
    endif()
    if(ENABLE_GNM)
        list(APPEND _py_depends _gnm${v})
    endif()
    add_custom_target(python${v}_binding ALL
                      DEPENDS _gdal${v} _gdalconst${v} _ogr${v} _osr${v}
                      ${_py_depends})
    file(TO_NATIVE_PATH "${CMAKE_CURRENT_BINARY_DIR}/${v}/osgeo/" osgeo_binary_dir)
    file(TO_NATIVE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/osgeo/" osgeo_source_dir)
    if(v EQUAL 2)
        add_custom_command(TARGET python${v}_binding POST_BUILD
                       COMMAND ${CMAKE_COMMAND} -E make_directory ${osgeo_binary_dir}
                       COMMAND ${CMAKE_COMMAND} -E copy
                           ${osgeo_source_dir}__init__.py
                           ${osgeo_source_dir}gdal.py
                           ${osgeo_source_dir}gdalconst.py
                           ${osgeo_source_dir}gdalnumeric.py
                           ${osgeo_source_dir}ogr.py
                           ${osgeo_source_dir}osr.py
                           ${osgeo_source_dir}gnm.py
                           ${osgeo_source_dir}gdal_array.py
                           ${osgeo_binary_dir})
    else()
        add_custom_command(TARGET python${v}_binding POST_BUILD
                       COMMAND ${CMAKE_COMMAND} -E make_directory ${osgeo_binary_dir}
                       COMMAND ${Python3_EXECUTABLE} -m lib2to3
                           --fix=import --fix=next --fix=renames
                           --fix=unicode --fix=ws_comma --fix=xrange
                           --write --write-unchanged-files --nobackups
                           --output-dir=${osgeo_binary_dir}
                           ${osgeo_source_dir}__init__.py
                           ${osgeo_source_dir}gdal.py
                           ${osgeo_source_dir}gdalconst.py
                           ${osgeo_source_dir}gdalnumeric.py
                           ${osgeo_source_dir}ogr.py
                           ${osgeo_source_dir}osr.py
                           ${osgeo_source_dir}gnm.py
                           ${osgeo_source_dir}gdal_array.py)
    endif()
    install(FILES
            ${CMAKE_CURRENT_BINARY_DIR}/${v}/osgeo/__init__.py
            ${CMAKE_CURRENT_BINARY_DIR}/${v}/osgeo/gdal.py
            ${CMAKE_CURRENT_BINARY_DIR}/${v}/osgeo/gdalconst.py
            ${CMAKE_CURRENT_BINARY_DIR}/${v}/osgeo/gdalnumeric.py
            ${CMAKE_CURRENT_BINARY_DIR}/${v}/osgeo/gnm.py
            ${CMAKE_CURRENT_BINARY_DIR}/${v}/osgeo/ogr.py
            ${CMAKE_CURRENT_BINARY_DIR}/${v}/osgeo/osr.py
            DESTINATION ${Python${v}_SITELIB}/osgeo)
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
