# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru,
# *			Hiroshi Miura <miurahr@linux.com>
# ******************************************************************************
# * Copyright (C) 2017 Hiroshi Miura
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


include(CMakeDependentOption)
cmake_dependent_option(SWIG_PYTHON "Build the Python binding" ON "HAVE_PYTHON" OFF)
if(SWIG_PYTHON)
    message(STATUS "Python binding is added.")
    add_subdirectory(python)
endif()

cmake_dependent_option(SWIG_JAVA "Build the JAVA binding" OFF "HAVE_JAVA" OFF)
if(SWIG_JAVA)
    message(STATUS "JAVA binding is added.")
    add_subdirectory(java)
endif()

cmake_dependent_option(SWIG_PERL "Build the Perl binding" OFF "HAVE_PERL" OFF)
if(SWIG_PERL)
    message(STATUS "Perl binding is added.")
    add_subdirectory(perl)
endif()

cmake_dependent_option(SWIG_PHP "Build the PHP binding" OFF "HAVE_PHP" OFF)
if(SWIG_PHP)
    message(STATUS "PHP binding is added.")
    add_subdirectory(php)
endif()

cmake_dependent_option(SWIG_CSHARP "Build the C# binding" OFF "HAVE_CSHARP" OFF)
if(SWIG_CSHARP)
    message(STATUS "CSHARP binding is added.")
    add_subdirectory(csharp)
endif()
