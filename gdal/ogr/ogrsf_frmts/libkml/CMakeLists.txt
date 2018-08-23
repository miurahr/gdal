ADD_GDAL_DRIVER(TARGET ogr_LIBKML SOURCES
				libkml_headers.h         ogrlibkmldriver.cpp   ogrlibkmlfeaturestyle.cpp  ogrlibkmlfield.h       ogrlibkmllayer.cpp
				ogr_libkml.h             ogrlibkmlfeature.cpp  ogrlibkmlfeaturestyle.h    ogrlibkmlgeometry.cpp  ogrlibkmlstyle.cpp
				ogrlibkmldatasource.cpp  ogrlibkmlfeature.h    ogrlibkmlfield.cpp         ogrlibkmlgeometry.h    ogrlibkmlstyle.h
			)
gdal_driver_standard_includes(ogr_LIBKML)

TARGET_INCLUDE_DIRECTORIES(ogr_LIBKML PRIVATE ${LIBKML_INCLUDE_DIR})
GDAL_TARGET_LINK_LIBRARIES(TARGET ogr_LIBKML
                           LIBRARIES ${LIBKML_BASE_LIBRARY} ${LIBKML_DOM_LIBRARY} ${LIBKML_ENGINE_LIBRARY})
