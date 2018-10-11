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

set(GDAL_ROOT_TEST_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

add_subdirectory(cpp)

if(NOT DEFINED Python_EXECUTABLE)
    if(PYTHON_VERSION)
        find_package(Python ${PYTHON_VERSION} COMPONENTS Interpreter)
    else()
        find_package(Python COMPONENTS Interpreter)
    endif()
endif()

if(DEFINED Python_EXECUTABLE)
    add_test(gcore-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py gcore)
    add_test(gdrivers-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py gdrivers)
    add_test(alg-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py alg)
    add_test(osr-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py osr)
    add_test(ogr-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py ogr)
    add_test(utilities-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py utilities)
    add_test(pyscripts-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py pyscripts)
    get_target_property(PLUGIN_OUTPUT_DIR gdal PLUGIN_OUTPUT_DIR)
    set(_TEST_ENV)
    if(WIN32)
        set(_SEP ";")
    else()
        set(_SEP ":")
    endif()
    list(APPEND _TEST_ENV
                "PATH=${CMAKE_BINARY_DIR}/gdal/apps${_SEP}$ENV{PATH}"
                "PYTHONPATH=${CMAKE_BINARY_DIR}/gdal/swig/python${_SEP}${CMAKE_CURRENT_SOURCE_DIR}/pymod"
                "LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/gdal${_SEP}$ENV{LD_LIBRARY_PATH}"
                "GDAL_DATA=${CMAKE_SOURCE_DIR}/gdal/data"
                "GDAL_DRIVER_PATH=${CMAKE_BINARY_DIR}/gdal/gdalplugins"
        )
    option(AUTOTEST_DOWNLOAD_TEST_DATA "Autotest to download test data" OFF)
    if(AUTOTEST_DOWNLOAD_TEST_DATA)
        list(APPEND _TEST_ENV GDAL_DOWNLOAD_TEST_DATA=1)
    endif()
    option(AUTOTEST_SLOW_TEST "Autotest to run slow test" OFF)
    if(AUTOTEST_SLOW_TEST)
        list(APPEND _TEST_ENV GDAL_SLOW_TESTSA=1)
        set_tests_properties(gcore-test gdrivers-test alg-test osr-test ogr-test utilities-test pyscripts-test
                             PROPERTIES
                             ENVIRONMENT "${_TEST_ENV}"
                             # run_all.py enforce us to run on a directory where script exist.
                             WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                             TIMEOUT 600)
     else()
        set_tests_properties(gcore-test gdrivers-test alg-test osr-test ogr-test utilities-test pyscripts-test
                             PROPERTIES
                             ENVIRONMENT "${_TEST_ENV}"
                             # run_all.py enforce us to run on a directory where script exist.
                             WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                             TIMEOUT 360)
    endif()
    add_custom_target(autotest COMMAND ${CMAKE_CTEST_COMMAND} -I 1,7
                       DEPENDS
                       testblockcache
                       testperfcopywords
                       test_include_from_c_file
                       test_c_include_from_cpp_file
                       testsse1
                       testsse2
                       testsse3)
    unset(_TEST_ENV)
    unset(_SEP)
endif()

#if(ANDROID)
#find_program(ADB adb)
#if(ADB)
#add_custom_command(TARGET gdal_unit_test POST_BUILD
#                   COMMAND ${ADB} shell mkdir -p /data/local/tmp/${ANDROID_ABI}
#                   COMMAND ${ADB} push $<TARGET_FILE:gdal> /data/local/tmp/${ANDROID_ABI}/
#                   COMMAND ${ADB} push $<TARGET_FILE:gdal_unit_test> /data/local/tmp/${ANDROID_ABI}/
#                   COMMAND ${ADB} shell \"export LD_LIBRARY_PATH=/data/local/tmp/${ANDROID_ABI}\; /data/local/tmp/${ANDROID_ABI}/gdal_unit_test\")
#endif()
#endif()

get_property(_plugins GLOBAL PROPERTY PLUGIN_MODULES )
add_custom_target(quicktest COMMAND ${CMAKE_CTEST_COMMAND} -R '^test-.*'
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
add_custom_target(test_misc COMMAND ${CMAKE_CTEST_COMMAND} -R '^testa-.*'
        DEPENDS
            test_include_from_c_file
            test_c_include_from_cpp_file
            testperfcopywords)
add_custom_target(test_sse COMMAND ${CMAKE_CTEST_COMMAND} -R '^testsse.*'
        DEPENDS
            testsse1
            testsse2
            testsse3)
