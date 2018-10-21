add_gdal_driver(TARGET ogr_LIBKML SOURCES
				libkml_headers.h ogrlibkmldriver.cpp ogrlibkmlfeaturestyle.cpp ogrlibkmlfield.h ogrlibkmllayer.cpp
				ogr_libkml.h ogrlibkmlfeature.cpp ogrlibkmlfeaturestyle.h ogrlibkmlgeometry.cpp ogrlibkmlstyle.cpp
				ogrlibkmldatasource.cpp ogrlibkmlfeature.h ogrlibkmlfield.cpp ogrlibkmlgeometry.h ogrlibkmlstyle.h)
gdal_standard_includes(ogr_LIBKML)
target_include_directories(ogr_LIBKML PRIVATE ${LIBKML_INCLUDE_DIR})
gdal_target_link_libraries(TARGET ogr_LIBKML
                           LIBRARIES ${LIBKML_BASE_LIBRARY} ${LIBKML_DOM_LIBRARY} ${LIBKML_ENGINE_LIBRARY})
