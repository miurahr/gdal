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
option(PAM_ENABLED "Set ON to enable pam" ON)
option(BUILD_APPS "Build command utilities" ON)
option(GDAL_ENABLE_PLUGIN "Set ON prefer to build drivers as plugin" OFF)

# Default definitions during build
add_definitions(-DGDAL_COMPILATION)
if(UNIX AND USE_CPL)
    add_definitions(-DCPL_LSB)
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
# Install properties
if(OSX_FRAMEWORK)
    # same as nextgis-borsch/lib_gdal
    # set(CMAKE_INSTALL_PREFIX "/Library/Application Support/GDAL/${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}")
    set(INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin"
            CACHE INTERNAL "Installation directory for executables" FORCE)
    set(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/Library/Frameworks"
            CACHE INTERNAL "Installation directory for libraries" FORCE)
    set(SKIP_INSTALL_EXECUTABLES OFF)
    set(SKIP_INSTALL_EXPORT ON)
    set(SKIP_INSTALL_DOCS ON)
    set(CMAKE_MACOSX_RPATH ON)

    # Use, i.e. don't skip the full RPATH for the build tree
    #set(CMAKE_SKIP_BUILD_RPATH  TRUE)

    # When building, don't use the install RPATH already
    # (but later on when installing)
    #set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

    # The RPATH to be used when installing
    #set(CMAKE_INSTALL_RPATH "${INSTALL_LIB_DIR}")
    #set(CMAKE_INSTALL_RPATH "@loader_path/../../../../Library/Frameworks")

    # Don't add the automatically determined parts of the RPATH
    # which point to directories outside the build tree to the install RPATH
    #set(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)

    set(BUILD_DOCS OFF CACHE INTERNAL "Don't build docs on Mac OS X" FORCE)

    # special place for plugin install
    set(INSTALL_PLUGIN_DIR "${CMAKE_INSTALL_PREFIX}/PlugIns"
            CACHE INTERNAL "Installation direcotry for plugins" FORCE)
else()
    include(GNUInstallDirs)
    set(INSTALL_BIN_DIR "${CMAKE_INSTALL_BINDIR}"
            CACHE INTERNAL "Installation directory for executables" FORCE)
    set(INSTALL_LIB_DIR "${CMAKE_INSTALL_LIBDIR}"
            CACHE INTERNAL "Installation directory for libraries" FORCE)
    set(INSTALL_INC_DIR "${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}"
            CACHE INTERNAL "Installation directory for headers" FORCE)
    set(INSTALL_SHARE_DIR "${CMAKE_INSTALL_DATADIR}/gdal"
            CACHE INTERNAL "Installation directory for share data" FORCE)
    set(INSTALL_PKGCONFIG_DIR "${INSTALL_LIB_DIR}/pkgconfig"
            CACHE INTERNAL "Installation directory for pkgconfig (.pc) files" FORCE)
    set(INSTALL_MAN_DIR ${CMAKE_INSTALL_MANDIR} CACHE INTERNAL
            "Installation directory for manual pages" FORCE)
    set(INSTALL_DOC_DIR ${CMAKE_INSTALL_DOCDIR} CACHE INTERNAL
            "Installation directory for doc pages" FORCE)
    set(INSTALL_PLUGIN_DIR
            "${CMAKE_INSTALL_PREFIX}/lib/gdalplugins/${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}"
            CACHE INTERNAL "Installation direcotry for plugins" FORCE)
endif()

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
                      CXX_STANDARD_REQUIRED YES
                      CXX_EXTENSIONS NO
)

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
if(GDAL_USE_OPENCAD_INTERNAL)
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
add_subdirectory(fuzzers)

# Document/Manuals
option(BUILD_DOCS "Build documents" ON)
if(BUILD_DOCS)
    add_subdirectory(doc)
endif()

# OSX Framework specific properties
if(OSX_FRAMEWORK)
    set_target_properties(gdal PROPERTIES
        FRAMEWORK TRUE
        FRAMEWORK_VERSION ${FRAMEWORK_VERSION}
        MACOSX_FRAMEWORK_SHORT_VERSION_STRING ${VERSION}
        MACOSX_FRAMEWORK_BUNDLE_VERSION ${VERSION}
        MACOSX_FRAMEWORK_IDENTIFIER org.osgeo.libgdal
        XCODE_ATTRIBUTE_INSTALL_PATH "@rpath"
        PUBLIC_HEADER "${INST_HEADER}"
    )
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
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/port/cpl_config.h DESTINATION ${INSTALL_INC_DIR})

# data resource
install(DIRECTORY "${GDAL_ROOT_SOURCE_DIR}/data/"
        DESTINATION ${INSTALL_SHARE_DIR}/${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}
        COMPONENT libraries FILES_MATCHING PATTERN "*.*")

# pkg-config resource
if(UNIX AND NOT OSX_FRAMEWORK)
    configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/gdal.pc.in
                   ${CMAKE_CURRENT_BINARY_DIR}/gdal.pc @ONLY)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/gdal.pc DESTINATION ${INSTALL_PKGCONFIG_DIR}
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
include(summary)

# vim: ts=4 sw=4 sts=4 et
