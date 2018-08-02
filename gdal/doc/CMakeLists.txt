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


# Documentation rules
find_package(Doxygen)
IF(DOXYGEN_FOUND)
      file(MAKE_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/html)
      # Generate translated docs. Should go first, because index.html page should
      # be overwritten with the main one later
       add_custom_command(
          OUTPUT
              ${GDAL_ROOT_BINARY_DIR}/html/header.html
              ${GDAL_ROOT_BINARY_DIR}/html/footer.html
              ${GDAL_ROOT_BINARY_DIR}/html/stylesheet.css
          COMMAND ${DOXYGEN_EXECUTABLE} -w html header.html footer.html stylesheet.css
          WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/html
      )
      #-------------------------------------------------------------------
      # Generate Russian document
      set(GDAL_DOXYGEN_OUTPUT_DIRECTORY "${GDAL_ROOT_BINARY_DIR}")
      set(GDAL_DOXYGEN_PROJECT_NAME "RU")
      set(GDAL_DOXYGEN_LANGUAGE "Russian")
      set(GDAL_DOXYGEN_JAVADOC_AUTOBRIEF "NO")
      set(GDAL_DOXYGEN_EXTRACT_LOCAL_CLASSES "YES")
      set(GDAL_DOXYGEN_INPUT "gdal_building_ru.dox gdal_datamodel_ru.dox gdal_tutorial_ru.dox index_ru.dox")
      set(GDAL_DOXYGEN_EXAMPLE_PATH "")
      set(GDAL_DOXYGEN_IMAGE_PATH "")
      set(GDAL_DOXYGEN_LAYOUT_FILE "")
      set(GDAL_ENABLED_SECTIONS "")
      set(GDAL_GENERATE_HTML "YES")
      set(GDAL_FILE_PATTERNS
                          "*.h \
                           *.cpp \
                           *.c \
                           *.dox"
      )
      set(GDAL_GENERATE_MAN "NO")
      configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/Doxyfile.in ${GDAL_ROOT_BINARY_DIR}/doc/Doxyfile_ru)
      add_custom_command(
              OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/index_ru.html
              COMMAND ${DOXYGEN_EXECUTABLE} ${GDAL_ROOT_BINARY_DIR}/doc/Doxyfile_ru
              MAIN_DEPENDENCY ${GDAL_ROOT_BINARY_DIR}/doc/Doxyfile_ru
              WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}/doc/ru
      )
      add_custom_command(
              OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/header_ru.html
              COMMAND ${CMAKE_COMMAND}
              ARGS
              -Dinfile:FILEPATH=${GDAL_ROOT_BINARY_DIR}/html/header.html
              -Doutfile:FILEPATH=${GDAL_ROOT_BINARY_DIR}/html/header_ru.html
              -Dfrom:STRING="iso-8859-1"
              -Dto:STRING="utf-8"
              -P ${CMAKE_CURRENT_SOURCE_DIR}/ReplaceStr.cmake
              MAIN_DEPENDENCY
              ${GDAL_ROOT_BINARY_DIR}/html/header.html
              WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/html
      )
      #-------------------------------------------------------------------
      # generate Brazillian document
      set(GDAL_DOXYGEN_OUTPUT_DIRECTORY "${GDAL_ROOT_BINARY_DIR}")
      set(GDAL_DOXYGEN_PROJECT_NAME "BR")
      set(GDAL_DOXYGEN_LANGUAGE "Brazilian")
      set(GDAL_DOXYGEN_JAVADOC_AUTOBRIEF "NO")
      set(GDAL_DOXYGEN_EXTRACT_LOCAL_CLASSES "YES")
      set(GDAL_DOXYGEN_INPUT "gdal_building_br.dox gdal_datamodel_br.dox gdal_tutorial_br.dox index_br.dox")
      set(GDAL_DOXYGEN_EXAMPLE_PATH "")
      set(GDAL_DOXYGEN_IMAGE_PATH "")
      set(GDAL_ENABLED_SECTIONS "")
      set(GDAL_DOXYGEN_LAYOUT_FILE "")
      set(GDAL_GENERATE_HTML "YES")
      set(GDAL_FILE_PATTERNS
                          "*.h \
                           *.cpp \
                           *.c \
                           *.dox"
      )
      set(GDAL_GENERATE_MAN "NO")
      configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/Doxyfile.in ${GDAL_ROOT_BINARY_DIR}/doc/Doxyfile_br)
      add_custom_command(
              OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/index_br.html
              COMMAND ${DOXYGEN_EXECUTABLE} ${GDAL_ROOT_BINARY_DIR}/doc/Doxyfile_br
              MAIN_DEPENDENCY ${GDAL_ROOT_BINARY_DIR}/doc/Doxyfile_br
              WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}/doc/br
      )
      add_custom_command(
              OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/header_br.html
              COMMAND ${CMAKE_COMMAND} -E copy
              ${GDAL_ROOT_BINARY_DIR}/html/header.html
              ${GDAL_ROOT_BINARY_DIR}/html/header_br.html
              DEPENDS ${GDAL_ROOT_BINARY_DIR}/html/header.html
      )

      #-------------------------------------------------------------------
      # run main doxygen
      set(GDAL_DOXYGEN_OUTPUT_DIRECTORY "${GDAL_ROOT_BINARY_DIR}")
      set(GDAL_DOXYGEN_PROJECT_NAME "GDAL")
      set(GDAL_DOXYGEN_LANGUAGE "English")
      set(GDAL_DOXYGEN_JAVADOC_AUTOBRIEF "YES")
      set(GDAL_DOXYGEN_EXTRACT_LOCAL_CLASSES "NO")
      set(GDAL_ENABLED_SECTIONS "")
      set(GDAL_GENERATE_HTML "YES")
      set(GDAL_DOXYGEN_INCLUDE_PATH
          "${GDAL_ROOT_BINARY_DIR}/port \
           ${GDAL_ROOT_BINARY_DIR}/gcore")
      set(GDAL_DOXYGEN_INPUT
          "port gcore frmts/gdalallregister.cpp alg frmts/vrt \
               doc apps ogr ogr/ogrsf_frmts ogr/ogrsf_frmts/generic \
               ogr/ogrsf_frmts/geojson/ogrgeojsonwriter.cpp \
               ogr/ogrsf_frmts/kml/ogr2kmlgeometry.cpp \
               swig/python/scripts gnm"
      )
      set(GDAL_DOXYGEN_EXAMPLE_PATH
              "apps frmts frmts/jdem"
              )
      set(GDAL_DOXYGEN_IMAGE_PATH ${GDAL_ROOT_SOURCE_DIR}/doc/grid)
      set(GDAL_DOXYGEN_LAYOUT_FILE ${GDAL_ROOT_SOURCE_DIR}/DoxygenLayout.xml)
      set(GDAL_GENERATE_MAN "NO")
      configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/Doxyfile.in ${GDAL_ROOT_BINARY_DIR}/doc/Doxyfile_main)
      add_custom_command(
              OUTPUT ${GDAL_ROOT_BINARY_DIR}/html/index.html
              COMMAND ${DOXYGEN_EXECUTABLE} ${GDAL_ROOT_BINARY_DIR}/doc/Doxyfile_main
              MAIN_DEPENDENCY ${GDAL_ROOT_BINARY_DIR}/doc/Doxyfile_main ${GDAL_ROOT_BINARY_DIR}/html/header.html
                              ${GDAL_ROOT_BINARY_DIR}/html/index_ru.html ${GDAL_ROOT_BINARY_DIR}/html/index_br.html
              WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}
      )

      #-------------------------------------------------------------------
      # copy rest of files for html generation
      file(GLOB OTHER_DOCS
              ${GDAL_ROOT_SOURCE_DIR}/doc/images/act-logo.png
              ${GDAL_ROOT_SOURCE_DIR}/doc/images/cadcorp_logo.jpg
              ${GDAL_ROOT_SOURCE_DIR}/doc/images/foss4g2013.png
              ${GDAL_ROOT_SOURCE_DIR}/doc/images/foss4g2014.png
              ${GDAL_ROOT_SOURCE_DIR}/doc/images/foss4g2017.png
              ${GDAL_ROOT_SOURCE_DIR}/doc/images/i3-logo.jpg
              ${GDAL_ROOT_SOURCE_DIR}/doc/images/ingres-logo.png
              ${GDAL_ROOT_SOURCE_DIR}/doc/images/OSGeo_project.png
              ${GDAL_ROOT_SOURCE_DIR}/doc/images/safe-logo.png
              ${GDAL_ROOT_SOURCE_DIR}/doc/images/src-logo.png
              ${GDAL_ROOT_SOURCE_DIR}/doc/images/waypoint_logo.png
              ${GDAL_ROOT_SOURCE_DIR}/doc/grid/*.png
              ${GDAL_ROOT_SOURCE_DIR}/frmts/*.html
              ${GDAL_ROOT_SOURCE_DIR}/frmts/*/frmt_*.html
              ${GDAL_ROOT_SOURCE_DIR}/frmts/openjpeg/*.xml
              ${GDAL_ROOT_SOURCE_DIR}/frmts/wms/frmt_*.xml
              ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/*/frmt_*.html
              ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/*/dev_*.html
              ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/gpkg/geopackage_aspatial.html
              ${GDAL_ROOT_SOURCE_DIR}/ogr/*.gif
              ${GDAL_ROOT_SOURCE_DIR}/data/gdalicon.png
              ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/ogr_formats.html
              ${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/ogr_formats.html
              ${GDAL_ROOT_SOURCE_DIR}/ogr/ogr_feature_style.html
      )
      add_custom_target(_copy_other_docs) ## FIXME: better way not to use internal custom target.
      foreach(f ${OTHER_DOCS})
          add_custom_command(TARGET _copy_other_docs PRE_BUILD
                  COMMAND ${CMAKE_COMMAND} -E
                      copy ${f} ${GDAL_ROOT_BINARY_DIR}/html)
      endforeach()
      add_custom_target(documents
              DEPENDS
              #            ${GDAL_ROOT_BINARY_DIR}/html/classes.html
              ${GDAL_ROOT_BINARY_DIR}/html/index.html
              ${GDAL_ROOT_BINARY_DIR}/html/index_ru.html
              ${GDAL_ROOT_BINARY_DIR}/html/index_br.html
              ${GDAL_ROOT_BINARY_DIR}/html/header.html
              ${GDAL_ROOT_BINARY_DIR}/html/footer.html
              ${GDAL_ROOT_BINARY_DIR}/html/stylesheet.css
              ${GDAL_ROOT_BINARY_DIR}/html/header_br.html
              ${GDAL_ROOT_BINARY_DIR}/html/header_ru.html
              _copy_other_docs
      )

    #-------------------------------------------------------------------
    # Build man
    set(GDAL_DOXYGEN_OUTPUT_DIRECTORY "${GDAL_ROOT_BINARY_DIR}")
    set(GDAL_DOXYGEN_PROJECT_NAME "GDAL")
    set(GDAL_DOXYGEN_LANGUAGE "English")
    set(GDAL_DOXYGEN_JAVADOC_AUTOBRIEF "YES")
    set(GDAL_ENABLED_SECTIONS "man")
    set(GDAL_DOXYGEN_EXTRACT_LOCAL_CLASSES "NO")
    set(GDAL_DOXYGEN_INPUT "apps swig/python/scripts")
    set(GDAL_FILE_PATTERNS "*.cpp *.dox")
    set(GDAL_GENERATE_HTML "NO")
    set(GDAL_DOXYGEN_EXAMPLE_PATH
            "apps \
             frmts \
             frmts/jdem"
            )
    set(GDAL_DOXYGEN_IMAGE_PATH ${GDAL_ROOT_SOURCE_DIR}/doc/grid)
    set(GDAL_DOXYGEN_LAYOUT_FILE "/dev/null")
    set(GDAL_GENERATE_MAN "YES")
    configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/Doxyfile.in ${GDAL_ROOT_BINARY_DIR}/doc/Doxyfile_man)
    add_custom_command(
            OUTPUT ${GDAL_ROOT_BINARY_DIR}/man/man1/gdalinfo.1
                ${GDAL_ROOT_BINARY_DIR}/man/man1/gdal-config.1
                ${GDAL_ROOT_BINARY_DIR}/man/man1/ogrlinfo.1
                ${GDAL_ROOT_BINARY_DIR}/man/man1/ogr2ogr.1
            COMMAND ${DOXYGEN_EXECUTABLE} ${GDAL_ROOT_BINARY_DIR}/doc/Doxyfile_man
            MAIN_DEPENDENCY ${GDAL_ROOT_BINARY_DIR}/doc/Doxyfile_man
            WORKING_DIRECTORY ${GDAL_ROOT_SOURCE_DIR}
    )
    add_custom_target(manpages
            DEPENDS
                ${GDAL_ROOT_BINARY_DIR}/man/man1/gdalinfo.1
                ${GDAL_ROOT_BINARY_DIR}/man/man1/gdal-config.1
                ${GDAL_ROOT_BINARY_DIR}/man/man1/ogrlinfo.1
                ${GDAL_ROOT_BINARY_DIR}/man/man1/ogr2ogr.1
    )
ENDIF()
