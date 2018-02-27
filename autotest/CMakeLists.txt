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

# not support test on cross compiling, but mingw support with wine
if(NOT CMAKE_CROSSCOMPILING OR MINGW)
    add_subdirectory(cpp)

    find_package(PythonInterp)
    find_package(PythonLibs)
    if(PythonInterp_FOUND)
        set(OPYTHONPATH ENV{PYTHONPATH})
        add_test(gcore-test ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py gcore)
        add_test(gdrivers-test ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py gdrivers)
        add_test(alg-test ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py alg)
        add_test(osr-test ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py osr)
        add_test(ogr-test ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py ogr)
        add_test(utilities-test ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py utilities)
        add_test(pyscripts-test ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/run_all.py pyscripts)
        set_tests_properties(gcore-test gdrivers-test alg-test osr-test ogr-test utilities-test pyscripts-test
                PROPERTIES
                ENVIRONMENT LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/gdal
                ENVIRONMENT PYTHONPATH=${CMAKE_BINARY_DIR}/gdal/swig/python:${CMAKE_CURRENT_SOURCE_DIR}/pymod:${OPYTHONPATH}
                #ENVIRONMENT GDAL_DOWNLOAD_TEST_DATA=1
                #ENVIRONMENT GDAL_SLOW_TESTSA=1
                # FIXME only run in-source currently.
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                TIMEOUT 300
                DEPENDS python_binding)
        add_custom_target(autotest_py COMMAND ${CMAKE_CTEST_COMMAND} -I 1,7)
    endif()

    add_custom_target(quicktest COMMAND ${CMAKE_CTEST_COMMAND} -R '^test-.*|^block-.*'
                  DEPENDS
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
endif()
