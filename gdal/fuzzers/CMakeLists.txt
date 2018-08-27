include(GdalStandardIncludes)

function(build_fuzzer)
    set(_options)
    set(_oneValueArgs NAME)
    set(_multiValueArgs SOURCES DEFINITIONS)
    cmake_parse_arguments(_FUZZ "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
    add_executable(${_FUZZ_NAME} ${_FUZZ_SOURCES})
    target_compile_definitions(${_FUZZ_NAME} PRIVATE ${FUZZ_DEFINITIONS})
    target_link_libraries(${_FUZZ_NAME} PRIVATE $<TARGET_NAME:gdal>)
    gdal_standard_includes(${_FUZZ_NAME})
    set_target_properties(${_FUZZ_NAME} PROPERTIES
                          CXX_STANDARD 11
                          CXX_STANDARD_REQUIRED YES)
    target_include_directories(${_FUZZ_NAME} PRIVATE
                               $<TARGET_PROPERTY:ogr_SQLite,SOURCE_DIR>
                               $<TARGET_PROPERTY:appslib,SOURCE_DIR>)
    ## Windows(Mingw/MSVC) link libraries
    if (CMAKE_SYSTEM_NAME MATCHES "Windows")
        target_link_libraries(${_FUZZ_NAME} PRIVATE wsock32 ws2_32 psapi)
    endif()
endfunction()

build_fuzzer(NAME gdal_fuzzer SOURCES gdal_fuzzer.cpp fuzzingengine.cpp)
build_fuzzer(NAME gdal_translate_fuzzer SOURCES gdal_translate_fuzzer.cpp fuzzingengine.cpp)
build_fuzzer(NAME gdal_vector_translate_fuzzer SOURCES gdal_vector_translate_fuzzer.cpp fuzzingengine.cpp)
build_fuzzer(NAME ogr_fuzzer SOURCES ogr_fuzzer.cpp fuzzingengine.cpp)
build_fuzzer(NAME alg_fuzzer SOURCES gdal_fuzzer.cpp fuzzingengine.cpp
             DEFINITIONS  -DREGISTER_FUNC=GDALRegister_AIGrid
                          -DMEM_FILENAME="/vsimem/test.tar"
                          -DGDAL_FILENAME="/vsitar//vsimem/test.tar/hdr.adf")

function(build_ogr_specialized_fuzzer _format _registerFunc _memfile _gdalfile)
    build_fuzzer(NAME ${_format}_fuzzer SOURCES ogr_fuzzer.cpp fuzzingengine.cpp
                 DEFINITIONS -DREGISTER_FUNC=${_registerFunc}
                           -DMEM_FILENAME="${_memfile}"
                           -DGDAL_FILENAME="${_gdalfile}")
endfunction()

build_ogr_specialized_fuzzer(dxf RegisterOGRDXF "/vsimem/test" "/vsimem/test")
build_ogr_specialized_fuzzer(ogr_sdts RegisterOGRSDTS "/vsimem/test.tar" "/vsitar//vsimem/test.tar/TR01CATD.DDF")
build_ogr_specialized_fuzzer(openfilegdb RegisterOGROpenFileGDB "/vsimem/test.gdb.tar" "/vsimem/test.gdb.tar")
build_ogr_specialized_fuzzer(shape OGRRegisterAll "/vsimem/test.tar" "/vsitar//vsimem/test.tar/my.shp")
build_ogr_specialized_fuzzer(mitab_mif OGRRegisterAll "/vsimem/test.tar" "/vsitar//vsimem/test.tar/my.mif")
build_ogr_specialized_fuzzer(mitab_tab OGRRegisterAll "/vsimem/test.tar" "/vsitar//vsimem/test.tar/my.tab")
build_ogr_specialized_fuzzer(csv RegisterOGRCSV "/vsimem/test.csv" "/vsimem/test.csv")
build_ogr_specialized_fuzzer(bna RegisterOGRBNA "/vsimem/test.bna" "/vsimem/test.bna")
build_ogr_specialized_fuzzer(wasp RegisterOGRWAsP "/vsimem/test.map" "/vsimem/test.map")
build_ogr_specialized_fuzzer(xlsx RegisterOGRXLSX "/vsimem/test.xlsx" "/vsitar/{/vsimem/test.xlsx}")
build_ogr_specialized_fuzzer(ods RegisterOGRODS "/vsimem/test.ods" "/vsitar/{/vsimem/test.ods}")
build_ogr_specialized_fuzzer(avce00 RegisterOGRAVCE00 "/vsimem/test.e00" "/vsimem/test.e00")
build_ogr_specialized_fuzzer(avcbin RegisterOGRAVCBin "/vsimem/test.tar" "/vsitar/{/vsimem/test.tar}/testavc")
build_ogr_specialized_fuzzer(gml RegisterOGRGML "/vsimem/test.tar" "/vsitar//vsimem/test.tar/test.gml")

build_fuzzer(NAME cad_fuzzer SOURCES ogr_fuzzer.cpp fuzzingengine.cpp DEFINITIONS -DREGISTER_FUNC=RegisterOGRCAD)
build_fuzzer(NAME rec_fuzzer SOURCES ogr_fuzzer.cpp fuzzingengine.cpp DEFINITIONS -DREGISTER_FUNC=RegisterOGRREC -DUSE_FILESYSTEM -DEXTENSION="rec")
