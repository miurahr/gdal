add_gdal_driver(TARGET ogr_ODS
			SOURCES ods_formula_node.cpp ods_formula_parser.hpp
            ods_formula.cpp ods_formula.h ogr_ods.h ogrodsdatasource.cpp ogrodsdriver.cpp)
gdal_standard_includes(ogr_ODS)
target_include_directories(ogr_ODS PRIVATE $<TARGET_PROPERTY:ogr_MEM,SOURCE_DIR>)
add_executable(testparser EXCLUDE_FROM_ALL testparser.cpp)

if(HAVE_EXPAT)
    target_include_directories(ogr_ODS PRIVATE ${EXPAT_INCLUDE_DIRS})
    gdal_target_link_libraries(TARGET ogr_ODS LIBRARIES EXPAT::EXPAT)
    target_compile_definitions(ogr_ODS PRIVATE -DHAVE_EXPAT=1)
endif()