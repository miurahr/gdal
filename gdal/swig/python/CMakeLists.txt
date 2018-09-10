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

find_package(Python COMPONENTS Interpreter Development)

if(NOT Python_FOUND)
    return()
endif()

INCLUDE_DIRECTORIES(${Python_INCLUDE_DIRS})

add_subdirectory(osgeo)
add_subdirectory(scripts)

add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/osgeo/__init__.py
        COMMAND ${CMAKE_COMMAND} -E copy
            ${CMAKE_CURRENT_SOURCE_DIR}/osgeo/*.py
            ${CMAKE_CURRENT_BINARY_DIR}/osgeo/
)

if(NumPy_FOUND)
    add_custom_target(python_binding ALL
                      DEPENDS _gdal _gdalconst _gnm _ogr _osr
                      _gdal_array
                      ${CMAKE_CURRENT_BINARY_DIR}/osgeo/__init__.py)
else()
    add_custom_target(python_binding ALL
                  DEPENDS _gdal _gdalconst _gnm _ogr _osr
                      ${CMAKE_CURRENT_BINARY_DIR}/osgeo/__init__.py)
endif()


add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_layer_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrlayer_8cpp.xml ../include/python/docs/ogr_layer_docs.i OGRLayerShadow OGR_L_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_geometry_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrgeometry_8cpp.xml ../include/python/docs/ogr_geometry_docs.i OGRGeometryShadow OGR_G_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_datasource_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrdatasource_8cpp.xml ../include/python/docs/ogr_datasource_docs.i OGRDataSourceShadow OGR_DS_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

# TODO
#$(PYTHON) ../include/python/docs/doxy2swig.py ../../xml/ogrsfdriver_8cpp.xml ../include/python/docs/ogr_driver_docs.i OGRDriverShadow OGR_Dr_
#$(PYTHON) ../include/python/docs/doxy2swig.py ../../xml/ogrfeature_8cpp.xml ../include/python/docs/ogr_feature_docs.i OGRFeatureShadow OGR_F_
#$(PYTHON) ../include/python/docs/doxy2swig.py ../../xml/ogrfeaturedefn_8cpp.xml ../include/python/docs/ogr_featuredef_docs.i OGRFeatureDefnShadow OGR_FD_
#$(PYTHON) ../include/python/docs/doxy2swig.py ../../xml/ogrfielddefn_8cpp.xml ../include/python/docs/ogr_fielddef_docs.i OGRFieldDefnShadow OGR_Fld_

add_custom_target(epydoc COMMAND epydoc --config epydoc.conf
                  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
