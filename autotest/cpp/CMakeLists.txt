# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Hiroshi Miura, Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru,
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


if(NOT CMAKE_CROSSCOMPILING)
    if(LINUX)
        add_library(vsipreload MODULE
                ${CMAKE_SOURCE_DIR}/gdal/port/vsipreload.cpp)
        target_link_libraries(vsipreload PRIVATE $<TARGET_NAME:gdal>)
    endif()
endif()

add_executable(gdal_unit_test
        tut/tut.hpp
        tut/tut_assert.hpp
        tut/tut_console_reporter.hpp
        tut/tut_exception.hpp
        tut/tut_gdal.h
        tut/tut_gdal.cpp
        tut/tut_posix.hpp
        tut/tut_reporter.hpp
        tut/tut_restartable.hpp
        tut/tut_result.hpp
        tut/tut_runner.hpp
        gdal_unit_test.cpp
        test_alg.cpp
        test_cpl.cpp
        test_gdal.cpp
        test_gdal_aaigrid.cpp
        test_gdal_dted.cpp
        test_gdal_gtiff.cpp
        test_ogr.cpp
        test_ogr_geos.cpp
        test_ogr_shape.cpp
        test_osr.cpp
        test_osr_pci.cpp
        test_osr_ct.cpp
        test_osr_proj4.cpp
        test_triangulation.cpp
        )
target_link_libraries(gdal_unit_test PRIVATE $<TARGET_NAME:gdal>)
add_dependencies(gdal_unit_test gdal)
gdal_standard_includes(gdal_unit_test)
target_compile_definitions(gdal_unit_test PRIVATE -DGDAL_TEST_ROOT_DIR="${GDAL_ROOT_TEST_DIR}" )
target_include_directories(gdal_unit_test PRIVATE
                           ${CMAKE_CURRENT_SOURCE_DIR}
                           ${CMAKE_CURRENT_SOURCE_DIR}/tut
                           $<TARGET_PROPERTY:appslib,SOURCE_DIR>
                           $<TARGET_PROPERTY:gdal_vrt,SOURCE_DIR>)
target_compile_definitions(gdal_unit_test PRIVATE -DGDAL_TEST_ROOT_DIR="${GDAL_ROOT_TEST_DIR}" )
add_test(NAME test-unit  COMMAND gdal_unit_test)
set(TEST_ENV)
list(APPEND TEST_ENV
            GDAL_DRIVER_PATH=${CMAKE_BINARY_DIR}/gdal/gdalplugins
            GDAL_DATA=${CMAKE_SOURCE_DIR}/gdal/data)
set_tests_properties(test-unit PROPERTIES ENVIRONMENT "${TEST_ENV}")

macro(gdal_test_target _target _source)
    add_executable(${_target} EXCLUDE_FROM_ALL ${_source})
    target_link_libraries(${_target} PRIVATE $<TARGET_NAME:gdal>)
    gdal_standard_includes(${_target})
    target_include_directories(${_target} PRIVATE $<TARGET_PROPERTY:appslib,SOURCE_DIR>)
    target_compile_definitions(${_target} PRIVATE -DGDAL_TEST_ROOT_DIR="${GDAL_ROOT_TEST_DIR}" )
    add_dependencies(${_target} gdal)
endmacro()

gdal_test_target(testblockcache testblockcache.cpp)

add_test(NAME block-cache-1
                COMMAND testblockcache -check -co TILED=YES --debug TEST,LOCK -loops 3 --config GDAL_RB_LOCK_DEBUG_CONTENTION YES)
add_test(NAME block-cache-2
                COMMAND testblockcache -check -co TILED=YES --debug TEST,LOCK -loops 3 --config GDAL_RB_LOCK_DEBUG_CONTENTION YES --config GDAL_RB_LOCK_TYPE SPIN)
add_test(NAME block-cache-3
                COMMAND testblockcache -check -co TILED=YES -migrate)
add_test(NAME block-cache-4
                COMMAND testblockcache -check -memdriver)
add_test(NAME block-cache-5
                COMMAND testblockcache --config GDAL_BAND_BLOCK_CACHE HASHSET -check -co TILED=YES --debug TEST,LOCK -loops 3 --config GDAL_RB_LOCK_DEBUG_CONTENTION YES)
add_test(NAME block-cache-6
                COMMAND testblockcache --config GDAL_BAND_BLOCK_CACHE HASHSET -check -co TILED=YES --debug TEST,LOCK -loops 3 --config GDAL_RB_LOCK_DEBUG_CONTENTION YES --config GDAL_RB_LOCK_TYPE SPIN)

gdal_test_target(testsse1 testsse.cpp)
target_compile_options(testsse1 PRIVATE -mavx2)
gdal_test_target(testsse2 testsse.cpp)
target_compile_definitions(testsse2 PRIVATE -DUSE_SSE2_EMULATION)
gdal_test_target(testsse3 testsse.cpp)
add_test(NAME testsse1 COMMAND testsse1)
add_test(NAME testsse2 COMMAND testsse2)
add_test(NAME testsse3 COMMAND testsse3)
foreach(tgt IN ITEMS block-cache-1 block-cache-2 block-cache-3 block-cache-4 block-cache-5 testsse1 testsse2 testsse3)
    set_tests_properties(${tgt} PROPERTIES ENVIRONMENT "${TEST_ENV}" WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endforeach()
macro(gdal_autotest_target _target testlabel _source options)
    if(NOT CMAKE_CROSSCOMPILING)
        gdal_test_target(${_target} ${_source})
        add_test(NAME ${testlabel}
            COMMAND ${_target} ${options})
        set_tests_properties(${testlabel} PROPERTIES ENVIRONMENT "${TEST_ENV}")
    endif()
endmacro()

gdal_autotest_target(testcopywords test-copy-words testcopywords.cpp "")
gdal_autotest_target(testclosedondestroydm test-closed-on-destroy-DM testclosedondestroydm.cpp "")
gdal_autotest_target(testthreadcond test-threaded-condition testthreadcond.cpp "")
gdal_autotest_target(testvirtualmem test-virtual-memory testvirtualmem.cpp "")
gdal_autotest_target(testblockcachewrite test-block-cache-write testblockcachewrite.cpp "--debug ON")
gdal_autotest_target(testblockcachelimits test-block-cache-limit testblockcachelimits.cpp "--debug ON")
gdal_autotest_target(testmultithreadedwriting test-multi-threaded-writing testmultithreadedwriting.cpp "")
gdal_autotest_target(testdestroy test-destroy testdestroy.cpp "")
gdal_autotest_target(test_include_from_c_file testa-include-from-C-file test_include_from_c_file.c "")
gdal_autotest_target(test_c_include_from_cpp_file testa-C-include-from-CPP-file test_c_include_from_cpp_file.cpp "")
gdal_autotest_target(testperfcopywords testa-performance-copy-words testperfcopywords.cpp "")
