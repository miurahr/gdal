include(GdalStandardIncludes)

add_executable(gdal_fuzzer gdal_fuzzer.cpp fuzzingengine.cpp)
add_executable(gdal_translate_fuzzer gdal_translate_fuzzer.cpp fuzzingengine.cpp)
add_executable(gdal_vector_translate_fuzzer gdal_vector_translate_fuzzer.cpp fuzzingengine.cpp)
add_executable(ogr_fuzzer ogr_fuzzer.cpp fuzzingengine.cpp)
#add_executable(alg_fuzzer gdal_fuzzer.cpp fuzzingengine.cpp)
#target_compile_definitions(alg_fuzzer PRIVATE
#	-DREGISTER_FUNC=GDALRegister_AIGrid -DMEM_FILENAME="\"/vsimem/test.tar\"" -DGDAL_FILENAME="\"/vsitar//vsimem/test.tar/hdr.adf\"")
#add_executable(ogr_sdts_fuzzer ogr_fuzzer.cpp fuzzingengine.cpp)
#target_compile_definitions(ogr_sdts_fuzzer PRIVATE -DREGISTER_FUNC=RegisterOGRSDTS -DMEM_FILENAME="\"/vsimem/test.tar\"" -DGDAL_FILENAME="\"/vsitar//vsimem/test.tar/TR01CATD.DDF\"")
#add_executable(mitab_tag_fuzzer ogr_fuzzer.cpp fuzzingengine.cpp)
#target_compile_definitions(mitab_tag_fuzzer PRIVATE
# -DREGISTER_FUNC=OGRRegisterAll -DMEM_FILENAME="\"/vsimem/test.tar\"" -DGDAL_FILENAME="\"/vsitar//vsimem/test.tar/my.tab\"")

foreach(FUZZER IN ITEMS gdal_translate_fuzzer gdal_vector_translate_fuzzer
		gdal_fuzzer ogr_fuzzer)
    target_link_libraries(${FUZZER} PRIVATE gdal)
    gdal_standard_includes(${FUZZER})
    #get_target_property(appslib_folder appslib SOURCE_DIR)
    target_include_directories(${FUZZER} PRIVATE
                               $<TARGET_PROPERTY:appslib,SOURCE_DIR>)
    ## Windows(Mingw/MSVC) link libraries
    if (CMAKE_SYSTEM_NAME MATCHES "Windows")
        target_link_libraries(${FUZZER} PRIVATE wsock32 ws2_32 psapi)
    endif()
endforeach()
add_custom_command(OUTPUT /tmp/dxf
                   COMMAND SRC=/tmp OUT=/tmp ${CMAKE_CURRENT_SOURCE_DIR}/build_google_oss_fuzzers.sh
                   COMMAND OUT=/tmp ${CMAKE_CURRENT_SOURCE_DIR}/build_seed_corpus.sh
                   DEPENDS FuzzingEngine
)
