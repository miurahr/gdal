# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru,
# *         Hiroshi Miura <miurahr@linux.com>
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

# alllow individual autotest tree
cmake_minimum_required (VERSION 3.5)
project(gdal_autotest C CXX)
set(CMAKE_COLOR_MAKEFILE ON)
enable_testing()

option(AUTOTEST_DOWNLOAD_TEST_DATA "Autotest to download test data" OFF)
option(AUTOTEST_SLOW_TEST "Autotest to run slow test" OFF)
if(NOT DEFINED ENV{CTEST_PARALLEL_LEVEL})
    set(PARALLEL_OPTION "-j1")
endif()
set(GDAL_ROOT_TEST_DIR "${CMAKE_CURRENT_LIST_DIR}")
add_subdirectory(cpp)

set(AUTOTEST_PYTHON_VERSION 2 CACHE STRING "Python version for autotest target")
if(AUTOTEST_PYTHON_VERSION STREQUAL 2)
    if(NOT Python2_EXECUTABLE)
        find_package(Python2 COMPONENTS Interpreter)
    endif()
    set(Python_EXECUTABLE ${Python2_EXECUTABLE})
    find_program(PIP_EXECUTABLE pip)
elseif(AUTOTEST_PYTHON_VERSION STREQUAL 3)
    if(NOT Python3_EXECUTABLE)
        find_package(Python3 COMPONENTS Interpreter)
    endif()
    set(Python_EXECUTABLE ${Python3_EXECUTABLE})
    find_program(PIP_EXECUTABLE pip3)
endif()

function(set_autotest_properties)
    cmake_parse_arguments(_SAP "SLOW_TESTS;DOWNLOAD_TEST_DATA" "" "TESTS" ${ARGN})
    get_target_property(PLUGIN_OUTPUT_DIR gdal PLUGIN_OUTPUT_DIR)
    if(WIN32)
        set(_SEP ";")
    else()
        set(_SEP ":")
    endif()
    list(APPEND _TEST_ENV
                "PATH=${CMAKE_BINARY_DIR}/gdal/apps${_SEP}$ENV{PATH}"
                "PYTHONPATH=${CMAKE_BINARY_DIR}/gdal/swig/python/${AUTOTEST_PYTHON_VERSION}/"
                "LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/gdal${_SEP}$ENV{LD_LIBRARY_PATH}"
                "GDAL_DATA=${CMAKE_SOURCE_DIR}/gdal/data"
                "GDAL_DRIVER_PATH=${CMAKE_BINARY_DIR}/gdal/gdalplugins"
        )
    if(_SAP_DOWNLOAD_TEST_DATA)
        list(APPEND _TEST_ENV GDAL_DOWNLOAD_TEST_DATA=YES)
    else()
        list(APPEND _TEST_ENV GDAL_DOWNLOAD_TEST_DATA=NO)
    endif()
    if(_SAP_SLOW_TESTS)
        list(APPEND _TEST_ENV GDAL_RUN_SLOW_TESTS=YES)
    else()
        list(APPEND _TEST_ENV GDAL_RUN_SLOW_TESTS=NO)
    endif()
    set_tests_properties(${_SAP_TESTS}
                         PROPERTIES
                         ENVIRONMENT "${_TEST_ENV}"
                         WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/autotest
                         TIMEOUT 1200)
endfunction()

if(Python_EXECUTABLE)
  add_test(NAME autotest COMMAND pytest)
  set_autotest_properties(TESTS autotest)
  add_custom_target(autotest COMMAND ${CMAKE_CTEST_COMMAND} -R autotest)
  #execute_process(COMMAND ${PIP_EXECUTABLE} install -r ${CMAKE_CURRENT_SOURCE_DIR}/requirements.txt)
  find_program(RSYNC_EXECUTABLE rsync)
  if(RSYNC_EXECUTABLE)
    execute_process(COMMAND ${RSYNC_EXECUTABLE} -a --include='*.ini' --include='*.py' --include='*/' --exclude='*'
                    ${CMAKE_SOURCE_DIR}/autotest/ ${CMAKE_BINARY_DIR}/autotest/)
  else()
    execute_process(COMMAND ${CMAKE_COMMAND} -E tar cfj ${CMAKE_CURRENT_BINARY_DIR}/tmp.tar . WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    execute_process(COMMAND ${CMAKE_COMMAND} -E tar xfj ${CMAKE_CURRENT_BINARY_DIR}/tmp.tar)
    execute_process(COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_CURRENT_BINARY_DIR}/tmp.tar)
  endif()
endif()

get_property(_plugins GLOBAL PROPERTY PLUGIN_MODULES )
add_custom_target(quicktest COMMAND ${CMAKE_CTEST_COMMAND} --force-new-ctest-process --output-on-failure -R '^test-.*'
              DEPENDS
                  gdal
                  ${_plugins}
                gdal_unit_test
                testblockcache
                testcopywords
                testclosedondestroydm
                testthreadcond
                testvirtualmem
                testblockcachewrite
                testblockcachelimits
                testmultithreadedwriting
                testdestroy)
add_custom_target(test_misc COMMAND ${CMAKE_CTEST_COMMAND} ${PARALLEL_OPTION} --force-new-ctest-process --output-on-failure -R '^testa-.*'
        DEPENDS
            test_include_from_c_file
            test_c_include_from_cpp_file
            testperfcopywords)
add_custom_target(test_sse COMMAND ${CMAKE_CTEST_COMMAND} ${PARALLEL_OPTION} --force-new-ctest-process --output-on-failure -R '^testsse.*'
        DEPENDS
            testsse1
            testsse2
            testsse3)
