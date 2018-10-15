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

set(GDAL_ROOT_TEST_DIR "${CMAKE_CURRENT_LIST_DIR}")
add_subdirectory(cpp)

if(NOT DEFINED Python_EXECUTABLE)
    if(PYTHON_VERSION)
        find_package(Python ${PYTHON_VERSION} COMPONENTS Interpreter)
    else()
        find_package(Python COMPONENTS Interpreter)
    endif()
endif()

function(set_autotest_properties)
    cmake_parse_arguments(_SAP "" "TIMEOUT" "TESTS" ${ARGN})
    get_target_property(PLUGIN_OUTPUT_DIR gdal PLUGIN_OUTPUT_DIR)
    if(_SAP_TIMEOUT)
        set(TTO ${_SAP_TIMEOUT})
    else()
        set(TTO 2)
    endif()
    set(_TEST_ENV)
    if(WIN32)
        set(_SEP ";")
    else()
        set(_SEP ":")
    endif()
    list(APPEND _TEST_ENV
                "PATH=${CMAKE_BINARY_DIR}/gdal/apps${_SEP}$ENV{PATH}"
                "PYTHONPATH=${CMAKE_BINARY_DIR}/gdal/swig/python${_SEP}${CMAKE_CURRENT_LIST_DIR}/pymod"
                "LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/gdal${_SEP}$ENV{LD_LIBRARY_PATH}"
                "GDAL_DATA=${CMAKE_SOURCE_DIR}/gdal/data"
                "GDAL_DRIVER_PATH=${CMAKE_BINARY_DIR}/gdal/gdalplugins"
        )

    if(AUTOTEST_DOWNLOAD_TEST_DATA)
        list(APPEND _TEST_ENV GDAL_DOWNLOAD_TEST_DATA=1)
    endif()
    if(AUTOTEST_SLOW_TEST)
        list(APPEND _TEST_ENV GDAL_SLOW_TESTSA=1)
        set_tests_properties(${_SAP_TESTS}
                             PROPERTIES
                             ENVIRONMENT "${_TEST_ENV}"
                             WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
                             TIMEOUT ${TTO})
     else()
        set_tests_properties(${_SAP_TESTS}
                             PROPERTIES
                             ENVIRONMENT "${_TEST_ENV}"
                             WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
                             TIMEOUT ${TTO})
    endif()
endfunction()

if(DEFINED Python_EXECUTABLE)
    add_subdirectory(gcore)
    add_subdirectory(gdrivers)
    add_subdirectory(osr)
    add_subdirectory(ogr)
    add_subdirectory(gnm)
    add_subdirectory(utilities)
    add_subdirectory(pyscripts)
    add_custom_target(autotest COMMAND ${CMAKE_CTEST_COMMAND} -L "\"(gcore|gdrivers|alg|osr|ogr|utilities|pyscripts)-test\""
                      --force-new-ctest-process --output-on-failure)

    # compat definitions
    add_test(gcore-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py gcore)
    add_test(gdrivers-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py gdrivers)
    add_test(alg-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py alg)
    add_test(osr-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py osr)
    add_test(ogr-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py ogr)
    add_test(utilities-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py utilities)
    add_test(pyscripts-test ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py pyscripts)
    set_autotest_properties(TESTS gcore-test gdrivers-test alg-test osr-test ogr-test utilities-test pyscripts-test
                            TIMEOUT 300)
    add_custom_target(autotest-compat COMMAND ${CMAKE_CTEST_COMMAND}
                      -R "\"(gcore|gdrivers|alg|osr|ogr|utilities|pyscripts)-test\"" --force-new-ctest-process
                      --verbose)
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
add_custom_target(test_misc COMMAND ${CMAKE_CTEST_COMMAND} --force-new-ctest-process --output-on-failure -R '^testa-.*'
        DEPENDS
            test_include_from_c_file
            test_c_include_from_cpp_file
            testperfcopywords)
add_custom_target(test_sse COMMAND ${CMAKE_CTEST_COMMAND} --force-new-ctest-process --output-on-failure -R '^testsse.*'
        DEPENDS
            testsse1
            testsse2
            testsse3)
