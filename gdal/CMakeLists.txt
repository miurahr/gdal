# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Hiroshi Miura, Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru
# ******************************************************************************
# * Copyright (C) 2017,2018 Hiroshi Miura
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

# Switches to control build targets(cached)
option(USE_CPL "Set ON to use cpl" ON)
option(ENABLE_GNM "Build GNM module" ON)
option(ENABLE_PAM "Set ON to enable pam" ON)
option(BUILD_APPS "Build command utilities" ON)
option(BUILD_DOCS "Build documents" ON)
option(GDAL_ENABLE_PLUGIN "Set ON prefer to build drivers as plugin" OFF)

# Default definitions during build
add_definitions(-DGDAL_COMPILATION)
if(UNIX)
    add_definitions(-D_FORTIFY_SOURCE)
    set(CMAKE_POSITION_INDEPENDENT_CODE ON)
    if(USE_CPL)
        add_definitions(-DCPL_LSB)
    endif()
endif()

################################################################################
# generate ${CMAKE_CURRENT_BINARY_DIR}/gcore/gdal_version.h
# and set GDAL_VERSION variable
include(GdalVersion)
set(GDAL_SOVERSION 20 CACHE STRING "")

################################################################
# find 3rd party libraries
include(CheckDependentLibraries)

# generate ${CMAKE_CURRENT_BINARY_DIR}/port/cpl_config.h
include(configure)

################################################################################
## libgdal shared/satic library generation
option(BUILD_SHARED_LIBS "Set ON to build shared library" ON)
add_library(gdal gcore/gdal.h)
add_library(GDAL_LINK_LIBRARY INTERFACE)
target_link_libraries(gdal PRIVATE $<TARGET_NAME:GDAL_LINK_LIBRARY>)
set_property(TARGET gdal PROPERTY PLUGIN_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/gdalplugins)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/gdalplugins)

# Set project and C++ Standard properties
set_target_properties(gdal PROPERTIES
                      PROJECT_LABEL ${PROJECT_NAME}
                      VERSION ${GDAL_VERSION}
                      SOVERSION ${GDAL_SOVERSION}
                      ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                      LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                      RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                      CXX_STANDARD 11
                      CXX_STANDARD_REQUIRED YES)
if(APPLE)
   set_target_properties(gdal PROPERTIES
       FRAMEWORK TRUE
       FRAMEWORK_VERSION A
       MACOSX_FRAMEWORK_SHORT_VERSION_STRING ${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}
       MACOSX_FRAMEWORK_BUNDLE_VERSION ${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}
       MACOSX_FRAMEWORK_IDENTIFIER org.osgeo.libgdal
       XCODE_ATTRIBUTE_INSTALL_PATH "@rpath"
       #PUBLIC_HEADER ""
   )
endif()

################################################################################
# Install properties
if(APPLE)
    include(OSXInstallDirs)
    set(INSTALL_PLUGIN_DIR "${CMAKE_INSTALL_PREFIX}/PlugIns"
            CACHE PATH "Installation direcotry for plugins")
    set(CMAKE_MACOSX_RPATH ON)
else()
    include(GNUInstallDirs)
    set(INSTALL_PLUGIN_DIR
        "${CMAKE_INSTALL_PREFIX}/lib/gdalplugins/${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}"
        CACHE PATH "Installation direcotry for plugins")
endif()

###############################################################################
# detect portability libs and set, so it should add at first
# Common Portability layer
add_subdirectory(port)

# Configure internal libraries
option(GDAL_QHULL "use qhull" ON)
if(GDAL_QHULL AND GDAL_USE_QHULL_INTERNAL)
    add_subdirectory(alg/internal_libqhull)
endif()
if(GDAL_USE_LIBZ_INTERNAL)
    add_subdirectory(frmts/zlib)
endif()
option(GDAL_USE_LIBPCIDSK_INTERNAL "Set ON to build pcidsk driver with internal sdk" OFF)
if(GDAL_USE_LIBPCIDSK_INTERNAL)
    add_subdirectory(frmts/pcidsk/sdk)
    set(HAVE_PCIDSK ON)
endif()
if(GDAL_USE_LIBJSONC_INTERNAL)
    add_subdirectory(ogr/ogrsf_frmts/geojson/libjson)
endif()
if(GDAL_USE_OPENCAD_INTERNAL AND OGR_ENABLE_CAD)
    add_subdirectory(ogr/ogrsf_frmts/cad/libopencad)
endif()
if(GDAL_USE_LIBTIFF_INTERNAL)
    option(RENAME_INTERNAL_LIBTIFF_SYMBOLS OFF)
    add_subdirectory(frmts/gtiff/libtiff)
endif()
if(GDAL_USE_LIBGEOTIFF_INTERNAL)
    add_subdirectory(frmts/gtiff/libgeotiff)
endif()
if(GDAL_USE_LIBJPEG_INTERNAL)
    add_subdirectory(frmts/jpeg/libjpeg)
endif()
if(GDAL_USE_GIFLIB_INTERNAL)
    add_subdirectory(frmts/gif/giflib)
endif()
if(GDAL_USE_LIBPNG_INTERNAL)
    add_subdirectory(frmts/png/libpng)
endif()
if(GDAL_USE_LIBCSF_INTERNAL)
    add_subdirectory(frmts/pcraster/libcsf)
endif()
if(GDAL_USE_LIBLERC_INTERNAL)
    add_subdirectory(frmts/mrf/libLERC)
    add_subdirectory(third_party/LercLib)
endif()

# Core components
add_subdirectory(alg)
add_subdirectory(ogr)
add_subdirectory(gnm)
add_subdirectory(gcore)

# Raster/Vector drivers (built-in and plugins)
add_subdirectory(frmts)
add_subdirectory(ogr/ogrsf_frmts)

# Bindings
add_subdirectory(swig)

# Utilities
add_subdirectory(apps)

# Google OSS-Fuzz project utilities
add_subdirectory(fuzzers)

# Document/Manuals
if(BUILD_DOCS)
    add_subdirectory(doc)
endif()

## MSVC spefific resource preparation
if(MSVC)
    target_sources(gdal PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/gcore/Version.rc)
    source_group("Resource Files" FILES ${CMAKE_CURRENT_SOURCE_DIR}/gcore/Version.rc)
    gdal_standard_includes(gdal)
    if(CMAKE_CL_64)
		set_target_properties(gdal PROPERTIES STATIC_LIBRARY_FLAGS "/machine:x64")
    endif()
endif()

## Windows(Mingw/MSVC) link libraries
if (CMAKE_SYSTEM_NAME MATCHES "Windows")
    target_link_libraries(gdal PRIVATE wsock32 ws2_32 psapi)
endif()

################################################################################
configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/gdal_def.h.in
               ${CMAKE_CURRENT_BINARY_DIR}/gcore/gdal_def.h @ONLY)

################################################################################
#
# gdal-config utility command generation
include(GenerateGdalConfig)
generate_gdal_config()

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/port/cpl_config.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
install(DIRECTORY "${GDAL_ROOT_SOURCE_DIR}/data/"
        DESTINATION ${INSTALL_SHARE_DIR}/${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}
        COMPONENT libraries FILES_MATCHING PATTERN "*.*")

# pkg-config resource
if(UNIX AND NOT APPLE)
    configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/gdal.pc.in
                   ${CMAKE_CURRENT_BINARY_DIR}/gdal.pc @ONLY)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/gdal.pc DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
            COMPONENT libraries)
endif()

install(TARGETS gdal
        EXPORT gdal-export
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        FRAMEWORK DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

# Genarate GdalConfig.cmake and GdalConfigVersion.cmake
export(EXPORT gdal-export
       FILE gdal-export.cmake)
install(EXPORT gdal-export
        FILE GdalConfig.cmake
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/gdal/
        EXPORT_LINK_INTERFACE_LIBRARIES)
include(CMakePackageConfigHelpers)
write_basic_package_version_file(GdalConfigVersion.cmake
                                 VERSION ${GDAL_VERSION}
                                 ## SameMinorVersion compatibility are supported CMake > 3.10.1
                                 ## so use ExactVersion instead.
                                 # COMPATIBILITY SameMinorVersion)
                                 COMPATIBILITY ExactVersion)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/GdalConfigVersion.cmake
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/gdal/)

################################################################################
configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/uninstall.cmake.in
               ${CMAKE_BINARY_DIR}/cmake_uninstall.cmake IMMEDIATE @ONLY)
add_custom_target(uninstall
                  COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)

################################################################################
## Print summry
include(SystemSummary)
system_summary(DESCRIPTION "GDAL is now configured on;")
include(FeatureSummary)
feature_summary(DESCRIPTION "Enabled drivers and features and found dependency packages"
                WHAT ALL
                VAR packagesAndFeaturesText)
message(STATUS "${packagesAndFeaturesText}")

# vim: ts=4 sw=4 sts=4 et
