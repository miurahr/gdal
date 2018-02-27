# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# *	Author:	Hiroshi Miura <miurahr@linux.com>
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

FIND_PACKAGE(SWIG REQUIRED)
find_package(Perl REQUIRED)
file(MAKE_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/perl/lib/Geo/GDAL)
set(SWIG_ARGS -DPERL_CPAN_NAMESPACE -outdir ${GDAL_ROOT_BINARY_DIR}/swig/perl/lib/Geo)
set(GDAL_PERL_SWIG_OUTPUT
        ${GDAL_ROOT_BINARY_DIR}/swig/perl/lib/Geo/GDAL.pm
        ${GDAL_ROOT_BINARY_DIR}/swig/perl/lib/Geo/Const.pm
        ${GDAL_ROOT_BINARY_DIR}/swig/perl/lib/Geo/OGR.pm
        ${GDAL_ROOT_BINARY_DIR}/swig/perl/lib/Geo/OSR.pm
)
include(MacroSwigBindings)
MACRO_SWIG_BINDINGS(perl SWIG_ARGS GDAL_PERL_SWIG_OUTPUT)
#------------------------------------------------------------
# HACK to compile interface source
#   this should do by Makefile.PL
find_package(PerlLibs)
add_library(swig_perl_wrap OBJECT
        ${GDAL_ROOT_BINARY_DIR}/swig/perl/extensions/gdal_wrap.cpp
        ${GDAL_ROOT_BINARY_DIR}/swig/perl/extensions/gdalconst_wrap.c
        ${GDAL_ROOT_BINARY_DIR}/swig/perl/extensions/gnm_wrap.cpp
        ${GDAL_ROOT_BINARY_DIR}/swig/perl/extensions/ogr_wrap.cpp
        ${GDAL_ROOT_BINARY_DIR}/swig/perl/extensions/osr_wrap.cpp
)
set_target_properties(swig_perl_wrap PROPERTIES CXX_STANDARD 98)
gdal_standard_includes(swig_perl_wrap)
target_include_directories(swig_perl_wrap PRIVATE ${PERL_INCLUDE_PATH})
target_compile_definitions(swig_perl_wrap PRIVATE -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE)
set(GDAL_PERL_WRAP_OBJ_DIR "CMakeFiles/swig_perl_wrap.dir/extensions")
configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/Makefile.PL.in ${GDAL_ROOT_BINARY_DIR}/swig/perl/Makefile.PL @ONLY)
#--------------------------------------------------------------
add_custom_command(
        OUTPUT
            ${GDAL_ROOT_BINARY_DIR}/swig/perl/lib/Geo/GDAL/Const.pm
        COMMAND ${CMAKE_COMMAND} -E copy
            ${GDAL_ROOT_BINARY_DIR}/swig/perl/lib/Geo/Const.pm
            ${GDAL_ROOT_BINARY_DIR}/swig/perl/lib/Geo/GDAL/
        )

add_custom_command(
        OUTPUT
            ${GDAL_ROOT_BINARY_DIR}/swig/perl/Makefile_Geo__GDAL
            ${GDAL_ROOT_BINARY_DIR}/swig/perl/Makefile_Geo__GDAL__Const
            ${GDAL_ROOT_BINARY_DIR}/swig/perl/Makefile_Geo__OSR
            ${GDAL_ROOT_BINARY_DIR}/swig/perl/Makefile_Geo__OGR
        COMMAND ${PERL_EXECUTABLE} Makefile.PL INSTALL_BASE=${CMAKE_INSTALL_PREFIX}
        WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/perl
        DEPENDS gdal_perl_wrappers swig_perl_wrap
            ${GDAL_ROOT_BINARY_DIR}/swig/perl/lib/Geo/GDAL/Const.pm
            ${GDAL_ROOT_BINARY_DIR}/swig/perl/Makefile.PL
)

add_custom_target(perl_binding
				  COMMAND
                      make -f Makefile_Geo__GDAL && make -f Makefile_Geo__GDAL__Const &&
                      make -f Makefile_Geo__OSR && make -f Makefile_Geo__OGR
				  WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/perl
				  DEPENDS ${GDAL_ROOT_BINARY_DIR}/swig/perl/Makefile_Geo__GDAL gdal
				  COMMENT "generating perl binding..."
)

#------------------------------------------------------------
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/cmake_perl_install.cmake "execute_process(COMMAND make -f Makefile_Geo__GDAL install WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/perl)\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/cmake_perl_install.cmake "execute_process(COMMAND make -f Makefile_Geo__GDAL__Const install WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/perl)\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/cmake_perl_install.cmake "execute_process(COMMAND make -f Makefile_Geo__OSR install  WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/perl)\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/cmake_perl_install.cmake "execute_process(COMMAND make -f Makefile_Geo__OGR install  WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/perl)\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/cmake_perl_install.cmake "execute_process(COMMAND make -f Makefile_Geo__GNM install  WORKING_DIRECTORY ${GDAL_ROOT_BINARY_DIR}/swig/perl)\n")
install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/cmake_perl_install.cmake COMPONENT runtime)

# vim: ts=4 sw=4 sts=4 et
