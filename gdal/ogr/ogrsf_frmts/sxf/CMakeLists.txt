ADD_GDAL_DRIVER(TARGET ogr_SXF SOURCES
				ogr_sxf.h ogrsxfdatasource.cpp ogrsxflayer.cpp ogrsxfdriver.cpp)
target_include_directories(ogr_SXF PRIVATE
						   $<BUILD_INTERFACE:${GDAL_ROOT_SOURCE_DIR}/ogr/ogrsf_frmts/generic>)
gdal_driver_standard_includes(ogr_SXF)

if(USE_CPL)
	target_compile_definitions(ogr_SXF PRIVATE -DUSE_CPL)
endif(USE_CPL)
