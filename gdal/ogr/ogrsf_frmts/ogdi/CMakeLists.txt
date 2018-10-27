add_gdal_driver(TARGET ogr_OGDI SOURCES ogrogdi.h ogrogdidatasource.cpp ogrogdidriver.cpp ogrogdilayer.cpp)
gdal_standard_includes(ogr_OGDI)
target_include_directories(ogr_OGDI PRIVATE
                           ${PROJ4_INCLUDE_DIRS}
                           ${OGDI_INCLUDE_DIRS})
gdal_target_link_Libraries(TARGET ogr_OGDI LIBRARIES
                           ${PROJ4_LIBRARIES}
                           OGDI::OGDI)